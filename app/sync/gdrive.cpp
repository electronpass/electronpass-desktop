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
    connect(network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(network_manager_reply(QNetworkReply*)));
}

void Gdrive::open_url() {
    QDesktopServices::openUrl(QUrl("http://github.com/electronpass"));
    AuthServer *server = new AuthServer();
    connect(server, SIGNAL(auth_success(std::string)), this, SLOT(auth_server_request(std::string)));
}

void Gdrive::auth_server_request(std::string request) {
    std::cout << request << std::endl;
}

void Gdrive::network_manager_reply(QNetworkReply *reply) {
    std::cout << std::string(reply->readAll().data()) << std::endl;
}

void Gdrive::refresh_token() {
    if (globals::settings.gdrive_get_refresh_token() == "") {
        authorize_client();
        return;
    }
}

void Gdrive::authorize_client() {
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
}

void Gdrive::set_wallet(const std::string &) {

}
