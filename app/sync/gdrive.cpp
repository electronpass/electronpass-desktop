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

std::string upload_body(const std::string& boundary, const std::string& content) {
    std::string body = "--" + boundary + "\n";
    body += "Content-Type: application/json; charset=UTF-8\n\n";
    body += "{\"name\": \"ElectronPass.wallet\"}\n\n";
    body += "--" + boundary + "\n";
    body += "Content-Type: text/plain\n\n";
    body += content + "\n\n";
    body += "--" + boundary + "--";

    return body;
}

bool Gdrive::check_authentication_error(const Json::Value& json) {
    if (json["error"].isObject()) {
        if (state == State::GET) emit wallet_downloaded("", 3);
        else if (state == State::SET) emit wallet_did_set(3);
        state = State::NONE;
        return true;
    }

    return false;
}

Gdrive::Gdrive(QObject *parent): QObject(parent) {
    network_manager = new QNetworkAccessManager(this);
//    clean_settings();
}

void Gdrive::open_url() {
    QDesktopServices::openUrl(QUrl("http://github.com/electronpass"));
    AuthServer *server = new AuthServer(this);
    connect(server, SIGNAL(auth_success(std::string)), this, SLOT(auth_server_request(std::string)));
}

void Gdrive::resume_state() {
    switch (state) {
        case State::GET:
            state = State::NONE;
            get_wallet();
            break;
        case State::SET:
            state = State::NONE;
            set_wallet(new_wallet);
            break;
        default:
            break;
    }
}

void Gdrive::client_authentication_ready() {
    Json::Value json;
    Json::Reader reader;
    reader.parse(current_reply->readAll().data(), json);
    current_reply->deleteLater();

    globals::settings.gdrive_set_access_token(json["access_token"].asString());
    globals::settings.gdrive_set_refresh_token(json["refresh_token"].asString());

    int expires_in = json["expires_in"].asInt() - 300;
    QDateTime expiration_time = QDateTime::currentDateTimeUtc().addSecs(expires_in);
    globals::settings.gdrive_set_token_expiration(expiration_time);

    resume_state();
}

void Gdrive::refresh_authentication_ready() {
    Json::Value json;
    Json::Reader reader;
    reader.parse(current_reply->readAll().data(), json);
    current_reply->deleteLater();

    globals::settings.gdrive_set_access_token(json["access_token"].asString());

    int expires_in = json["expires_in"].asInt() - 300;
    QDateTime expiration_time = QDateTime::currentDateTimeUtc().addSecs(expires_in);
    globals::settings.gdrive_set_token_expiration(expiration_time);

    resume_state();
}

void Gdrive::auth_server_request(std::string request) {
    std::regex code_regex("\\/\\?code=(.+)? ");
    std::smatch code_match;
    bool success = std::regex_search(request, code_match, code_regex);

    if (!success) {
        switch (state) {
            case State::GET:
                emit wallet_downloaded("", 3);
                break;
            case State::SET:
                emit wallet_did_set(3);
                break;
            case State::NONE:
                break;
        }
        state = State::NONE;
        return;
    }

    std::string code = code_match[1];

    QUrlQuery post_data;
    post_data.addQueryItem("code", QString(code.c_str()));
    post_data.addQueryItem("client_id", kGdriveClientID);
    post_data.addQueryItem("client_secret", kGdriveClientSecret);
    post_data.addQueryItem("grant_type", "authorization_code");
    post_data.addQueryItem("redirect_uri", "http://localhost:5160");

    QNetworkRequest network_request(QUrl("https://www.googleapis.com/oauth2/v4/token"));
    network_request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    current_reply = network_manager->post(network_request, post_data.toString(QUrl::FullyEncoded).toUtf8());
    connect(current_reply, SIGNAL(readyRead()), this, SLOT(client_authentication_ready()));
}

void Gdrive::refresh_token() {
    std::string refresh_token = globals::settings.gdrive_get_refresh_token();

    if (refresh_token == "") {
        authorize_client();
        return;
    }

    std::cout << "refreshing token" << std::endl;

    QUrlQuery post_data;
    post_data.addQueryItem("refresh_token", QString(refresh_token.c_str()));
    post_data.addQueryItem("client_id", kGdriveClientID);
    post_data.addQueryItem("client_secret", kGdriveClientSecret);
    post_data.addQueryItem("grant_type", "refresh_token");

    QNetworkRequest network_request(QUrl("https://www.googleapis.com/oauth2/v4/token"));
    network_request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    current_reply = network_manager->post(network_request, post_data.toString(QUrl::FullyEncoded).toUtf8());
    connect(current_reply, SIGNAL(readyRead()), this, SLOT(refresh_authentication_ready()));
}

void Gdrive::authorize_client() {
    std::cout << "authorizing client" << std::endl;

    QUrl url("https://accounts.google.com/o/oauth2/v2/auth");
    QUrlQuery url_query;
    url_query.addQueryItem("scope", QUrl::toPercentEncoding("https://www.googleapis.com/auth/drive"));
    url_query.addQueryItem("response_type", "code");
    url_query.addQueryItem("redirect_uri", QUrl::toPercentEncoding("http://localhost:5160"));
    url_query.addQueryItem("client_id", kGdriveClientID);

    url.setQuery(url_query);

    AuthServer *server = new AuthServer(this);
    connect(server, SIGNAL(auth_success(std::string)), this, SLOT(auth_server_request(std::string)));
    QDesktopServices::openUrl(url);
}

void Gdrive::get_wallet_id() {
    std::cout << "getting wallet id" << std::endl;

    QUrl url("https://www.googleapis.com/drive/v3/files");

    QUrlQuery url_query;
    url_query.addQueryItem("q", QUrl::toPercentEncoding("name='ElectronPass.wallet'"));
    url.setQuery(url_query);

    std::string access_token = globals::settings.gdrive_get_access_token();
    QNetworkRequest network_request(url);
    network_request.setRawHeader("Authorization", QByteArray(("Bearer " + access_token).c_str()));

    current_reply = network_manager->get(network_request);
    connect(current_reply, SIGNAL(readyRead()), this, SLOT(wallet_id_ready()));
}

void Gdrive::wallet_id_ready() {
    Json::Value json;
    Json::Reader reader;
    reader.parse(current_reply->readAll().data(), json);
    current_reply->deleteLater();

    if (check_authentication_error(json)) return;

    if (json["files"].size() == 0) {
        create_wallet();
        return;
    }

    wallet_id = json["files"][0]["id"].asString();
    resume_state();
}

void Gdrive::create_wallet() {
    std::cout << "creating wallet" << std::endl;

    const std::string boundary = "electronpass_request_boundary";

    QUrl url("https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart");

    QNetworkRequest network_request(url);
    network_request.setRawHeader("Content-Type", ("multipart/related; boundary=" + boundary).c_str());
    std::string access_token = globals::settings.gdrive_get_access_token();
    network_request.setRawHeader("Authorization", QByteArray(("Bearer " + access_token).c_str()));

    current_reply = network_manager->post(network_request, upload_body(boundary, "").c_str());
    connect(current_reply, SIGNAL(readyRead()), this, SLOT(create_wallet_ready()));
}

void Gdrive::create_wallet_ready() {
    Json::Value json;
    Json::Reader reader;
    reader.parse(current_reply->readAll().data(), json);
    current_reply->deleteLater();

    if (check_authentication_error(json)) return;

    wallet_id = json["id"].asString();
    resume_state();
}

void Gdrive::wallet_download_ready() {
    std::string wallet(current_reply->readAll().data());
    current_reply->deleteLater();

    std::cout << "wallet downloaded" << std::endl;
    std::cout << wallet << std::endl;

    state = State::NONE;
    emit wallet_downloaded(wallet, 0);
}

void Gdrive::get_wallet() {
    if (state != State::NONE) {
        emit wallet_downloaded("", 1);
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

    std::cout << "getting wallet" << std::endl;

    std::string url_string = "https://www.googleapis.com/drive/v3/files/" + wallet_id + "?alt=media";
    QUrl url = QUrl::fromEncoded(QByteArray(url_string.c_str()));

    std::string access_token = globals::settings.gdrive_get_access_token();
    QNetworkRequest network_request(url);
    network_request.setRawHeader("Authorization", QByteArray(("Bearer " + access_token).c_str()));

    current_reply = network_manager->get(network_request);
    connect(current_reply, SIGNAL(readyRead()), this, SLOT(wallet_download_ready()));
}

void Gdrive::upload_wallet_ready() {
    std::string reply(current_reply->readAll().data());
    current_reply->deleteLater();

    std::cout << "wallet uploaded" << std::endl;
    std::cout << reply << std::endl;

    state = State::NONE;
    emit wallet_did_set(0);
}

void Gdrive::set_wallet(const std::string& wallet) {
    if (state != State::NONE) {
        emit wallet_did_set(1);
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

    std::cout << "setting wallet" << std::endl;

    std::string url_string = "https://www.googleapis.com/upload/drive/v3/files/" + wallet_id + "?uploadType=multipart";
    QUrl url = QUrl::fromEncoded(QByteArray(url_string.c_str()));

    const std::string boundary = "electronpass_request_boundary";

    std::string access_token = globals::settings.gdrive_get_access_token();
    QNetworkRequest network_request(url);
    network_request.setRawHeader("Authorization", QByteArray(("Bearer " + access_token).c_str()));
    network_request.setRawHeader("Content-Type", ("multipart/related; boundary=" + boundary).c_str());

    current_reply = network_manager->sendCustomRequest(network_request, "PATCH", upload_body(boundary, wallet).c_str());
    connect(current_reply, SIGNAL(readyRead()), this, SLOT(upload_wallet_ready()));
}