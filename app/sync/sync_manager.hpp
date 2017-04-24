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

#ifndef ELECTRONPASS_SYNC_MANAGER_HPP
#define ELECTRONPASS_SYNC_MANAGER_HPP


#include <string>
#include <QObject>

#include "globals.hpp"
#include "sync_base.hpp"
#include "gdrive.hpp"


class SyncManager: public QObject {
    Q_OBJECT

    SyncBase *sync_object;
public:
    SyncManager(QObject *parent = 0);

    void init();

    enum class Service {
        NONE, GDRIVE
    };

    static Service string_to_service(const std::string &);
    static std::string service_to_string(const Service &);

public slots:
    void service_did_download_wallet(const std::string& wallet, int success);
    void service_did_upload_wallet(int success);

signals:
    void wallet_downloaded(const std::string& wallet, int success);
    void wallet_uploaded(int success);

    // Success codes:
    // 0: success
    // 1: already syncing
    // 2: no network
    // 3: could not authorize
};



#endif //ELECTRONPASS_SYNC_MANAGER_HPP
