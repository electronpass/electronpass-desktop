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

Gdrive::Gdrive(QObject *parent): QObject(parent) {
    network_manager = new QNetworkAccessManager(this);
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

void Gdrive::get_wallet() {
    std::cout << kGdriveClientSecret << std::endl << kGdriveClientID << std::endl;

    if (state != State::NONE) {
        emit wallet_downloaded("", 1);
        return;
    }

    state = State::GET;

    if (globals::settings.gdrive_get_token_expiration() <= QDateTime::currentDateTimeUtc()) {
        refresh_token();
        return;
    }

    std::cout << "getting wallet" << std::endl;
}

void Gdrive::set_wallet(const std::string &) {

}
