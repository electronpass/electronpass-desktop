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

#include "gdrive.hpp"

std::string upload_body(const std::string& content) {

    std::string body = "--" kRequestBoundary "\n";
    body += "Content-Type: application/json; charset=UTF-8\n\n";
    body += "{\"name\": \"ElectronPass.wallet\"}\n\n";
    body += "--" kRequestBoundary "\n";
    body += "Content-Type: text/plain\n\n";
    body += content + "\n\n";
    body += "--" kRequestBoundary "--";

    return body;
}

Gdrive::Gdrive(QObject *parent): QObject(parent) {
    network_manager = new QNetworkAccessManager(this);
}

bool Gdrive::check_authentication_error(const Json::Value& json) {
    if (!json["error"].empty()) {
        if (state == State::GET) emit wallet_downloaded("", SyncManagerStatus::COULD_NOT_AUTHORIZE);
        else if (state == State::SET) emit wallet_uploaded(SyncManagerStatus::COULD_NOT_AUTHORIZE);
        state = State::NONE;
        return true;
    }

    return false;
}

void Gdrive::resume_state() {
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

void Gdrive::auth_server_request(std::string request) {
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
    post_data.addQueryItem("code", QString(code.c_str()));
    post_data.addQueryItem("client_id", kGdriveClientID);
    post_data.addQueryItem("client_secret", kGdriveClientSecret);
    post_data.addQueryItem("grant_type", "authorization_code");
    post_data.addQueryItem("redirect_uri", "http://localhost:5160");

    QNetworkRequest network_request(QUrl("https://www.googleapis.com/oauth2/v4/token"));
    network_request.setHeader(QNetworkRequest::ContentTypeHeader,
                              "application/x-www-form-urlencoded");
    reply = network_manager->post(network_request, post_data.toString(QUrl::FullyEncoded).toUtf8());
    connect(reply, SIGNAL(finished()), this, SLOT(reply_finished()));
}

void Gdrive::authorize_client(const std::string &reply) {
    Json::Value json;
    Json::Reader reader;
    reader.parse(reply.c_str(), json);

    globals::settings.gdrive_set_access_token(json["access_token"].asString());
    globals::settings.gdrive_set_refresh_token(json["refresh_token"].asString());

    int expires_in = json["expires_in"].asInt() - 300;
    QDateTime expiration_time = QDateTime::currentDateTimeUtc().addSecs(expires_in);
    globals::settings.gdrive_set_token_expiration(expiration_time);

    resume_state();
}

void Gdrive::refresh_token(const std::string &reply) {
    Json::Value json;
    Json::Reader reader;
    reader.parse(reply.c_str(), json);

    if (!json["error"].empty()) {
        authorize_client();
        return;
    }

    globals::settings.gdrive_set_access_token(json["access_token"].asString());

    int expires_in = json["expires_in"].asInt() - 300;
    QDateTime expiration_time = QDateTime::currentDateTimeUtc().addSecs(expires_in);
    globals::settings.gdrive_set_token_expiration(expiration_time);

    resume_state();
}

void Gdrive::refresh_token() {
    std::string refresh_token = globals::settings.gdrive_get_refresh_token();

    if (refresh_token == "") {
        authorize_client();
        return;
    }

    std::cout << "<gdrive.cpp> [Log] Refreshing access token." << std::endl;

    network_state = NetworkState::REFRESH_TOKEN;

    QUrlQuery post_data;
    post_data.addQueryItem("refresh_token", QString(refresh_token.c_str()));
    post_data.addQueryItem("client_id", kGdriveClientID);
    post_data.addQueryItem("client_secret", kGdriveClientSecret);
    post_data.addQueryItem("grant_type", "refresh_token");

    QNetworkRequest network_request(QUrl("https://www.googleapis.com/oauth2/v4/token"));
    network_request.setHeader(QNetworkRequest::ContentTypeHeader,
                              "application/x-www-form-urlencoded");
    reply = network_manager->post(network_request, post_data.toString(QUrl::FullyEncoded).toUtf8());
    connect(reply, SIGNAL(finished()), this, SLOT(reply_finished()));
}

void Gdrive::authorize_client() {
    globals::sync_manager.setStatusMessage("Please authorize in browser.");
    std::cout << "<gdrive.cpp> [Log] Authorizing client." << std::endl;

    QUrl url("https://accounts.google.com/o/oauth2/v2/auth");
    QUrlQuery url_query;
    url_query.addQueryItem("scope",
                           QUrl::toPercentEncoding("https://www.googleapis.com/auth/drive"));
    url_query.addQueryItem("response_type", "code");
    url_query.addQueryItem("redirect_uri", QUrl::toPercentEncoding("http://localhost:5160"));
    url_query.addQueryItem("client_id", kGdriveClientID);

    url.setQuery(url_query);

    auth_server = new AuthServer(this);

    connect(auth_server, SIGNAL(did_delete()), this, SLOT(auth_server_did_delete()));

    if (!auth_server->init()) {
        if (state == State::GET) {
            state = State::NONE;
            emit wallet_downloaded("", SyncManagerStatus::COULD_NOT_AUTHORIZE);
        } else if (state == State::NONE) {
            state = State::NONE;
            emit wallet_uploaded(SyncManagerStatus::COULD_NOT_AUTHORIZE);
        }
        return;
    }

    connect(auth_server, SIGNAL(auth_success(std::string)),
            this, SLOT(auth_server_request(std::string)));
    QDesktopServices::openUrl(url);
}

void Gdrive::get_wallet_id() {
    std::cout << "<gdrive.cpp> [Log] Getting wallet id." << std::endl;

    network_state = NetworkState::GET_WALLET_ID;

    QUrl url("https://www.googleapis.com/drive/v3/files");

    QUrlQuery url_query;
    url_query.addQueryItem("q", QUrl::toPercentEncoding("name='ElectronPass.wallet'"));
    url.setQuery(url_query);

    std::string access_token = globals::settings.gdrive_get_access_token();
    QNetworkRequest network_request(url);
    network_request.setRawHeader("Authorization", QByteArray(("Bearer " + access_token).c_str()));

    reply = network_manager->get(network_request);
    connect(reply, SIGNAL(finished()), this, SLOT(reply_finished()));
}

void Gdrive::get_wallet_id(const std::string &reply) {
    Json::Value json;
    Json::Reader reader;
    reader.parse(reply.c_str(), json);

    if (check_authentication_error(json)) return;

    if (json["files"].size() == 0) {
        create_wallet();
        return;
    }

    wallet_id = json["files"][0]["id"].asString();
    resume_state();
}

void Gdrive::create_wallet() {
    network_state = NetworkState::CREATE_WALLET;

    std::cout << "<gdrive.cpp> [Log] Creating wallet." << std::endl;

    QUrl url("https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart");

    QNetworkRequest network_request(url);
    network_request.setRawHeader("Content-Type", "multipart/related; boundary=" kRequestBoundary);
    std::string access_token = globals::settings.gdrive_get_access_token();
    network_request.setRawHeader("Authorization", QByteArray(("Bearer " + access_token).c_str()));

    reply = network_manager->post(network_request, upload_body("").c_str());
    connect(reply, SIGNAL(finished()), this, SLOT(reply_finished()));
}

void Gdrive::create_wallet(const std::string &reply) {
    Json::Value json;
    Json::Reader reader;
    reader.parse(reply.c_str(), json);

    if (check_authentication_error(json)) return;

    wallet_id = json["id"].asString();
    resume_state();
}

void Gdrive::download_wallet(const std::string &reply) {
    std::cout << "<gdrive.cpp> [Log] Wallet downloaded." << std::endl;

    state = State::NONE;
    emit wallet_downloaded(reply, SyncManagerStatus::SUCCESS);
}

void Gdrive::download_wallet() {
    if (state != State::NONE) {
        emit wallet_downloaded("", SyncManagerStatus::ALREADY_SYNCING);
        return;
    }

    if (network_manager->networkAccessible() != QNetworkAccessManager::NetworkAccessibility::Accessible) {
        emit wallet_downloaded("", SyncManagerStatus::NETWORK_ERROR);
        return;
    }

    state = State::GET;

    if (globals::settings.gdrive_get_token_expiration() <= QDateTime::currentDateTimeUtc()) {
        refresh_token();
        return;
    }

    if (wallet_id == "") {
        get_wallet_id();
        return;
    }

    std::cout << "<gdrive.cpp> [Log] Getting wallet." << std::endl;

    network_state = NetworkState::DOWNLOAD_WALLET;

    std::string url_string = "https://www.googleapis.com/drive/v3/files/" + wallet_id + "?alt=media";
    QUrl url = QUrl::fromEncoded(QByteArray(url_string.c_str()));

    std::string access_token = globals::settings.gdrive_get_access_token();
    QNetworkRequest network_request(url);
    network_request.setRawHeader("Authorization", QByteArray(("Bearer " + access_token).c_str()));

    reply = network_manager->get(network_request);
    connect(reply, SIGNAL(finished()), this, SLOT(reply_finished()));
}

void Gdrive::reply_finished() {
    int error = reply->error();
    if (error != 0 && error != 5) {
        if (state == State::GET) emit wallet_downloaded("", SyncManagerStatus::NETWORK_ERROR);
        if (state == State::SET) emit wallet_uploaded(SyncManagerStatus::NETWORK_ERROR);
        state = State::NONE;
        network_state = NetworkState::NONE;
        reply->deleteLater();
        return;
    }

    std::string data;
    // Aborted, network states is already none.
    if (error == 5) {
        reply->deleteLater();
        return;
    }
    data = std::string(reply->readAll().data());

    reply->deleteLater();

    NetworkState ns = network_state;
    network_state = NetworkState::NONE;

    switch (ns) {
        case NetworkState::AUTHORIZE:
            authorize_client(data);
            break;
        case NetworkState::REFRESH_TOKEN:
            refresh_token(data);
            break;
        case NetworkState::GET_WALLET_ID:
            get_wallet_id(data);
            break;
        case NetworkState::CREATE_WALLET:
            create_wallet(data);
            break;
        case NetworkState::DOWNLOAD_WALLET:
            download_wallet(data);
            break;
        case NetworkState::UPLOAD_WALLET:
            upload_wallet_reply(data);
            break;
        default:
            break;
    }
}

void Gdrive::auth_server_did_delete() {
    auth_server = nullptr;
}

void Gdrive::abort() {
    if (network_state != NetworkState::NONE) {
        reply->abort();
        reply->deleteLater();
        network_state = NetworkState::NONE;
    }

    if (state == State::GET) emit wallet_downloaded("", SyncManagerStatus::ABORTED);
    if (state == State::SET) emit wallet_uploaded(SyncManagerStatus::ABORTED);
    state = State::NONE;

    if (auth_server != nullptr) {
        delete auth_server;
        auth_server = nullptr;
    }
}

void Gdrive::upload_wallet_reply(const std::string &reply) {
    std::cout << "<gdrive.cpp> [Log] Wallet uploaded." << std::endl;

    Json::Value json;
    Json::Reader reader;
    reader.parse(reply.c_str(), json);

    if (check_authentication_error(json)) return;

    state = State::NONE;
    emit wallet_uploaded(SyncManagerStatus::SUCCESS);
}

void Gdrive::upload_wallet(const std::string &wallet) {
    if (state != State::NONE) {
        emit wallet_uploaded(SyncManagerStatus::ALREADY_SYNCING);
        return;
    }

    if (network_manager->networkAccessible() != QNetworkAccessManager::NetworkAccessibility::Accessible) {
        emit wallet_uploaded(SyncManagerStatus::NETWORK_ERROR);
        return;
    }

    state = State::SET;
    new_wallet = wallet;

    if (globals::settings.gdrive_get_token_expiration() <= QDateTime::currentDateTimeUtc()) {
        refresh_token();
        return;
    }

    if (wallet_id == "") {
        get_wallet_id();
        return;
    }

    std::cout << "<gdrive.cpp> [Log] Uploading wallet." << std::endl;

    network_state = NetworkState::UPLOAD_WALLET;

    std::string url_string = "https://www.googleapis.com/upload/drive/v3/files/" + wallet_id + "?uploadType=multipart";
    QUrl url = QUrl::fromEncoded(QByteArray(url_string.c_str()));

    std::string access_token = globals::settings.gdrive_get_access_token();
    QNetworkRequest network_request(url);
    network_request.setRawHeader("Authorization", QByteArray(("Bearer " + access_token).c_str()));
    network_request.setRawHeader("Content-Type", "multipart/related; boundary=" kRequestBoundary);

    reply = network_manager->sendCustomRequest(network_request, "PATCH",
                                               upload_body(wallet).c_str());
    connect(reply, SIGNAL(finished()), this, SLOT(reply_finished()));
}
