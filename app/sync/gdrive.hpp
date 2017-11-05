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

#ifndef GDRIVE_HPP
#define GDRIVE_HPP

#define kRequestBoundary "electronpass_request_boundary"

#include <string>
#include <iostream>
#include <regex>

#include <QObject>
#include <QDesktopServices>
#include <QUrl>
#include <QDateTime>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>

#include "electronpass/json/json.h"

#include "auth_server.hpp"
#include "globals.hpp"
#include "settings.hpp"
#include "sync/sync_base.hpp"
#include "sync/keys.hpp"
#include "sync/sync_manager.hpp"

enum class SyncManagerStatus;

class Gdrive: public QObject, public SyncBase {
    Q_OBJECT

    enum class State {
        SET, GET, NONE
    };

    enum class NetworkState {
        NONE, AUTHORIZE, REFRESH_TOKEN, GET_WALLET_ID, CREATE_WALLET,
        DOWNLOAD_WALLET, UPLOAD_WALLET
    };

    State state = State::NONE;
    NetworkState network_state = NetworkState::NONE;
    std::string new_wallet;
    std::string wallet_id;

    AuthServer *auth_server = nullptr;
    QNetworkAccessManager *network_manager;
    QNetworkReply *reply;

    void authorize_client();
    void refresh_token();
    void get_wallet_id();
    void create_wallet();

    void authorize_client(const std::string &reply);
    void refresh_token(const std::string &reply);
    void get_wallet_id(const std::string &reply);
    void create_wallet(const std::string &reply);
    void download_wallet(const std::string &reply);
    void upload_wallet_reply(const std::string &reply);

    void resume_state();
    bool check_authentication_error(const Json::Value&);

public:
    Gdrive(QObject *parent = 0);

    void download_wallet();
    void upload_wallet(const std::string&);
    void abort();

public slots:
    void auth_server_request(std::string request);
    void reply_finished();
    void auth_server_did_delete();

signals:
    void wallet_downloaded(const std::string& wallet, SyncManagerStatus status);
    void wallet_uploaded(SyncManagerStatus status);
};

#endif // GDRIVE_HPP
