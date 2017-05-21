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
#include "wallet_merger.hpp"
#include "file_stream.hpp"
#include "sync_base.hpp"
#include "gdrive.hpp"
#include "dropbox.hpp"

enum class SyncManagerStatus {
    SUCCESS, ALREADY_SYNCING, NETWORK_ERROR, COULD_NOT_AUTHORIZE, ABORTED, NO_SYNC_PROVIDER, COULD_NOT_OPEN_FILE
};

class SyncManager: public QObject {
    Q_OBJECT

    Q_PROPERTY(QString statusMessage
        READ statusMessage
        WRITE setStatusMessage
        NOTIFY statusMessageChanged)

    QString status_message = "Sync manager not initialized";

    SyncBase *sync_object = nullptr;
    bool initialized = false;

    // If true: after wallet is downloaded, it is merged with current wallet
    // If false: offline wallet will be overwritten by online wallet (used for setup)
    bool need_to_merge = true;

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

    void set_service(Service);
    Service get_service();

    Q_INVOKABLE void download_wallet(bool merge = true);
    Q_INVOKABLE void upload_wallet();
    Q_INVOKABLE void abort();

public slots:
    void service_did_download_wallet(const std::string& wallet, SyncManagerStatus status);
    void service_did_upload_wallet(SyncManagerStatus status);

signals:
    void wallet_downloaded(const QString& wallet, int error);
    void wallet_uploaded(int error);
    /* Error codes are static cast of SyncManagerStatus enum to int, therefore:
     * - 0: SUCCESS
     * - 1: ALREADY_SYNCING
     * - 2: NETWORK_ERROR
     * - 3: COULD_NOT_AUTHORIZE
     * - 4: ABORTED
     * - 5: NO_SYNC_PROVIDER
     * - 6: COULD_NOT_OPEN_FILE
     */
    void statusMessageChanged();
};



#endif //ELECTRONPASS_SYNC_MANAGER_HPP
