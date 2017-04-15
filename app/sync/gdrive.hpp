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

#ifndef ELECTRONPASS_GDRIVE_HPP
#define ELECTRONPASS_GDRIVE_HPP

#include <QObject>
#include <QDesktopServices>
#include <QUrl>
#include <QDateTime>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>

#include <electronpass/json/json.h>

#include <string>
#include <iostream>
#include <regex>

#include "auth_server.hpp"
#include "globals.hpp"
#include "settings.hpp"
#include "keys.hpp.in"

class Gdrive: public QObject {
    Q_OBJECT

    enum class State {
        SET, GET, NONE
    };

    Gdrive::State state = State::NONE;
    std::string new_wallet;
    std::string wallet_id;

    QNetworkAccessManager *network_manager;
    QNetworkReply *current_reply;

    void authorize_client();
    void refresh_token();
    void get_wallet_id();
    void create_wallet();

    void resume_state();
    bool check_authentication_error(const Json::Value&);

    void clean_settings() {
        globals::settings.gdrive_set_token_expiration(QDateTime::currentDateTimeUtc());
        globals::settings.gdrive_set_refresh_token("");
        globals::settings.gdrive_set_access_token("");
    }
public:
    Gdrive(QObject *parent = 0);

    Q_INVOKABLE void open_url();
    Q_INVOKABLE void get_wallet();
    void set_wallet(const std::string&);

public slots:
    void auth_server_request(std::string request);
    void client_authentication_ready();
    void refresh_authentication_ready();
    void wallet_id_ready();
    void create_wallet_redy();

signals:
    void wallet_downloaded(const std::string& wallet, int success);
    void wallet_did_set(int success);
    // Success codes:
    // 0: success
    // 1: already syncing
    // 2: no network
    // 3: could not authorize
};


#endif //ELECTRONPASS_GDRIVE_HPP
