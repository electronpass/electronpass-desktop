/*
This file is part of ElectronPass.

ElectronPass is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ElectronPass is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with ElectronPass. If not, see <http://www.gnu.org/licenses/>.
*/

#include "dropbox.hpp"

Dropbox::Dropbox(QObject *parent): QObject(parent) {
    network_manager = new QNetworkAccessManager(this);
}

void Dropbox::resume_state() {
    switch (state) {
        case State::GET:
            state = State::NONE;
            download_wallet();
            break;
        case State::SET:
            state = State::NONE;
            upload_wallet(new_wallet);
            break;
        default:
            break;
    }
}

void Dropbox::auth_server_request(std::string request) {
    std::regex code_regex("\\/\\?code=(.+)? ");
    std::smatch code_match;
    bool success = std::regex_search(request, code_match, code_regex);

    if (!success) {
        switch (state) {
            case State::GET:
                emit wallet_downloaded("", SyncManagerStatus::COULD_NOT_AUTHORIZE);
                break;
            case State::SET:
                emit wallet_uploaded(SyncManagerStatus::COULD_NOT_AUTHORIZE);
                break;
            case State::NONE:
                break;
        }
        state = State::NONE;
        return;
    }

    network_state = NetworkState::AUTHORIZE;
    std::string code = code_match[1];

    QUrlQuery post_data;
    post_data.addQueryItem("code", code.c_str());
    post_data.addQueryItem("grant_type", "authorization_code");
    post_data.addQueryItem("client_id", kDropboxClientID);
    post_data.addQueryItem("client_secret", kDropboxClientSecret);
    post_data.addQueryItem("redirect_uri", "http://localhost:5160/");

    QNetworkRequest network_request(QUrl("https://api.dropboxapi.com/oauth2/token"));
    network_request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    reply = network_manager->post(network_request, post_data.toString(QUrl::FullyEncoded).toUtf8());
    connect(reply, SIGNAL(finished()), this, SLOT(reply_finished()));
}

void Dropbox::authorize_client(const std::string &data) {
    Json::Value json;
    Json::Reader reader;
    reader.parse(data, json);

    if (json["access_token"].empty()) {
        if (state == State::GET) {
            state = State::NONE;
            emit wallet_downloaded("", SyncManagerStatus::COULD_NOT_AUTHORIZE);
        } else if (state == State::SET) {
            state = State::NONE;
            emit wallet_uploaded(SyncManagerStatus::COULD_NOT_AUTHORIZE);
        }
        return;
    }

    globals::settings.dropbox_set_access_token(json["access_token"].asString());

    resume_state();
}

void Dropbox::authorize_client() {
    std::cout << "<dropbox.cpp> [Log] Authorizing client." << std::endl;

    QUrl url("https://www.dropbox.com/oauth2/authorize");
    QUrlQuery url_query;
    url_query.addQueryItem("response_type", "code");
    url_query.addQueryItem("client_id", kDropboxClientID);
    url_query.addQueryItem("redirect_uri", QUrl::toPercentEncoding("http://localhost:5160/"));

    url.setQuery(url_query);

    AuthServer *server = new AuthServer(this);
    if (!server->init()) {
        if (state == State::GET) {
            state = State::NONE;
            emit wallet_downloaded("", SyncManagerStatus::COULD_NOT_AUTHORIZE);
        } else if (state == State::SET) {
            state = State::NONE;
            emit wallet_uploaded(SyncManagerStatus::COULD_NOT_AUTHORIZE);
        }

        return;
    }

    connect(server, SIGNAL(auth_success(std::string)), this, SLOT(auth_server_request(std::string)));
    QDesktopServices::openUrl(url);
}

void Dropbox::download_wallet(const std::string &reply) {
    std::cout << "<dropbox.cpp> [Log] Wallet downloaded." << std::endl;
    state = State::NONE;
    emit wallet_downloaded(reply, SyncManagerStatus::SUCCESS);
}

void Dropbox::download_wallet() {
    if (state != State::NONE) {
        emit wallet_downloaded("", SyncManagerStatus::ALREADY_SYNCING);
        return;
    }

    if (network_manager->networkAccessible() != QNetworkAccessManager::NetworkAccessibility::Accessible) {
        emit wallet_downloaded("", SyncManagerStatus::NO_NETWORK);
        return;
    }

    state = State::GET;

    if (globals::settings.dropbox_get_access_token() == "") {
        authorize_client();
        return;
    }

    std::cout << "<dropbox.cpp> [Log] Getting wallet." << std::endl;

    network_state = NetworkState::DOWNLOAD_WALLET;

    QUrl url("https://content.dropboxapi.com/2/files/download");

    std::string params = "{\"path\": \"/ElectronPass.wallet\"}";

    std::string access_token = globals::settings.dropbox_get_access_token();
    QNetworkRequest network_request(url);
    network_request.setRawHeader("Authorization", ("Bearer " + access_token).c_str());
    network_request.setRawHeader("Dropbox-API-Arg", params.c_str());

    reply = network_manager->get(network_request);
    connect(reply, SIGNAL(finished()), this, SLOT(reply_finished()));
}

void Dropbox::upload_wallet_reply(const std::string &reply) {
    std::cout << "<dropbox.cpp> [Log] Wallet uploaded." << std::endl;

    Json::Value json;
    Json::Reader reader;
    reader.parse(reply, json);
    state = State::NONE;
    if (!json["error"].empty()) emit wallet_uploaded(SyncManagerStatus::COULD_NOT_AUTHORIZE);
    else emit wallet_uploaded(SyncManagerStatus::SUCCESS);
}

void Dropbox::upload_wallet(const std::string &wallet) {
    if (state != State::NONE) {
        emit wallet_uploaded(SyncManagerStatus::ALREADY_SYNCING);
        return;
    }

    if (network_manager->networkAccessible() != QNetworkAccessManager::NetworkAccessibility::Accessible) {
        emit wallet_uploaded(SyncManagerStatus::ALREADY_SYNCING);
        return;
    }

    state = State::SET;
    new_wallet = wallet;

    if (globals::settings.dropbox_get_access_token() == "") {
        authorize_client();
        return;
    }

    std::cout << "<dropbox.cpp> [Log] Uploading wallet." << std::endl;

    network_state = NetworkState::UPLOAD_WALLET;

    QUrl url("https://content.dropboxapi.com/2/files/upload");
    std::string params = "{\"path\":\"/ElectronPass.wallet\",\"mode\":\"overwrite\",\"mute\":true}";

    std::string access_token = globals::settings.dropbox_get_access_token();
    QNetworkRequest network_request(url);
    network_request.setRawHeader("Authorization", ("Bearer " + access_token).c_str());
    network_request.setRawHeader("Dropbox-API-Arg", params.c_str());
    network_request.setRawHeader("Content-Type", "text/plain; charset=dropbox-cors-hack");

    reply = network_manager->post(network_request, wallet.c_str());
    connect(reply, SIGNAL(finished()), this, SLOT(reply_finished()));
}

void Dropbox::reply_finished() {
    int error = reply->error();
    std::string data(reply->readAll().data());

    bool log_error = error != 0;

    reply->deleteLater();

    NetworkState ns = network_state;
    network_state = NetworkState::NONE;

    switch (ns) {
        case NetworkState::AUTHORIZE:
            authorize_client(data);
            break;
        case NetworkState::DOWNLOAD_WALLET:
            if (error == 206) {
                log_error = false;
                data = "";
            }
            download_wallet(data);
            break;
        case NetworkState::UPLOAD_WALLET:
            upload_wallet_reply(data);
            break;
        default:
            break;
    }

    if (log_error) {
        std::cout << "<dropbox.cpp> [Warning] QReply error code: " << error << std::endl;
    }
}

void Dropbox::abort() {
    if (network_state != NetworkState::NONE) {
        reply->abort();
        reply->deleteLater();
        network_state = NetworkState::NONE;
    }

    if (state == State::GET) emit wallet_downloaded("", SyncManagerStatus::ABORTED);
    if (state == State::SET) emit wallet_uploaded(SyncManagerStatus::ABORTED);
    state = State::NONE;
}
