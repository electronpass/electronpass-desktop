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

#include "sync_manager.hpp"

SyncManager::Service SyncManager::string_to_service(const std::string& string) {
    if (string == "gdrive") return SyncManager::Service::GDRIVE;
    return SyncManager::Service::NONE;
}

std::string SyncManager::service_to_string(const Service& service) {
    if (service == SyncManager::Service::GDRIVE) return "gdrive";
    else return "none";
}

SyncManager::SyncManager(QObject *parent): QObject(parent) {}

void SyncManager::init() {
    Service service = string_to_service(globals::settings.sync_manager_get_service());

    if (service == Service::GDRIVE) {
        sync_object = new Gdrive(this);
        connect(dynamic_cast<QObject*>(sync_object), SIGNAL(wallet_downloaded(const std::string& wallet, int success)), this, SLOT(service_did_download_wallet(const std::string& wallet, int success)));
    }
}

void SyncManager::service_did_download_wallet(const std::string &wallet, int success) {
    emit wallet_downloaded(wallet, success);
}

void SyncManager::service_did_upload_wallet(int success) {
    emit wallet_uploaded(success);
}
