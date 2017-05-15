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
#include "dropbox.hpp"

enum class SyncManagerStatus {
    SUCCESS, ALREADY_SYNCING, NO_NETWORK, COULD_NOT_AUTHORIZE
};

class SyncManager: public QObject {
    Q_OBJECT

    Q_PROPERTY(QString statusMessage
        READ statusMessage
        WRITE setStatusMessage
        NOTIFY statusMessageChanged)

    QString status_message = "Sync manager not initialized";

    SyncBase *sync_object;
    bool initialized = false;
public:
    SyncManager(QObject *parent = 0);

    // Return true if successful init, otherwise false
    bool init();

    enum class Service {
        NONE, GDRIVE, DROPBOX
    };

    QString statusMessage() const;
    void setStatusMessage(const QString& message);

    static Service string_to_service(const std::string &);
    static std::string service_to_string(const Service &);

    Q_INVOKABLE void download_wallet();
    Q_INVOKABLE void upload_wallet(const std::string& wallet);
    Q_INVOKABLE void cancel_syncing();

public slots:
    void service_did_download_wallet(const std::string& wallet, SyncManagerStatus success);
    void service_did_upload_wallet(SyncManagerStatus success);

signals:
    void wallet_downloaded(const std::string& wallet, int success);
    void wallet_uploaded(int success);

    // Success codes:
    // 0: success
    // 1: already syncing
    // 2: no network
    // 3: could not authorize

    void statusMessageChanged();
};



#endif //ELECTRONPASS_SYNC_MANAGER_HPP
