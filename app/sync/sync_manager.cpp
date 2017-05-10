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

#define kGdrive "gdrive"
#define kDropbox "dropbox"
#define kNone "none"

SyncManager::Service SyncManager::string_to_service(const std::string& string) {
    if (string == kGdrive) return SyncManager::Service::GDRIVE;
    if (string == kDropbox) return SyncManager::Service::DROPBOX;
    return SyncManager::Service::NONE;
}

std::string SyncManager::service_to_string(const Service& service) {
    if (service == SyncManager::Service::GDRIVE) return kGdrive;
    if (service == SyncManager::Service::DROPBOX) return kDropbox;
    return kNone;
}

SyncManager::SyncManager(QObject *parent): QObject(parent) {}

bool SyncManager::init() {
    if (initialized) {
        std::cout << "<sync_manager.cpp> [Warning] Sync manager already initialized. Ignoring init() call." << std::endl;
        return false;
    }
    Service service = string_to_service(globals::settings.sync_manager_get_service());

    if (service == Service::NONE) {
        sync_object = nullptr;
        return false;
    }

    if (service == Service::GDRIVE) sync_object = new Gdrive(this);
    if (service == Service::DROPBOX) sync_object = new Dropbox(this);

    connect(dynamic_cast<QObject*>(sync_object),
            SIGNAL(wallet_downloaded(const std::string&, SyncManagerStatus)),
            this,
            SLOT(service_did_download_wallet(const std::string&, SyncManagerStatus)));
    connect(dynamic_cast<QObject*>(sync_object),
            SIGNAL(wallet_uploaded(SyncManagerStatus)),
            this,
            SLOT(service_did_upload_wallet(SyncManagerStatus)));

    initialized = true;
    return true;
}

void SyncManager::download_wallet() {
    if (!initialized) std::cout << "<sync_manager.cpp> [Warning] Sync manager not initialized. Ignoring download_wallet() call." << std::endl;
    else if (sync_object == nullptr) std::cout << "<sync_manager.cpp> [Warning] Sync manager service is NONE - can't sync." << std::endl;
    else sync_object->download_wallet();
}

void SyncManager::upload_wallet(const std::string &wallet) {
    if (!initialized) std::cout << "<sync_manager.cpp> [Warning] Sync manager not initialized. Ignoring upload_wallet() call." << std::endl;
    else if (sync_object == nullptr) std::cout << "<sync_manager.cpp> [Warning] Sync manager service is NONE - can't sync." << std::endl;
    else sync_object->upload_wallet(wallet);
}

void SyncManager::service_did_download_wallet(const std::string &wallet, SyncManagerStatus success) {
    std::cout << "<sync_manager.cpp> [Log] Downloaded wallet." << std::endl << wallet << std::endl;
    emit wallet_downloaded(wallet, static_cast<int>(success));
}

void SyncManager::service_did_upload_wallet(SyncManagerStatus success) {
    std::cout << "<sync_manager.cpp> [Log] Uploaded wallet." << std::endl;
    emit wallet_uploaded(static_cast<int>(success));
}
