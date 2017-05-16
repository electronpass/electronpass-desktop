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

#include "setup.hpp"

Setup::Setup() {
    first_usage = globals::settings.get_first_usage();
}

bool Setup::need_setup() {
    return first_usage;
}

void Setup::finish() {
    globals::settings.set_first_usage(false);
}

bool Setup::set_password(const QString& password) {
    bool success = globals::data_holder.new_wallet(password);
    if (success) {
        assert(globals::data_holder.unlock(password) == 0);
    }
    return success;
}

bool Setup::restore_data_from_file(const QString& file_url) {
    QUrl url(file_url);
    std::string path = url.toLocalFile().toStdString();

    bool success = file_stream::copy_file(path);
    return success;
}

QString Setup::get_sync_service() const {
    std::string service = globals::settings.sync_manager_get_service();
    return QString::fromStdString(service);
}

void Setup::set_sync_service(const QString& service_name) {
    std::string service = service_name.toStdString();
    globals::settings.sync_manager_set_service(service);

    SyncManager::Service new_service = SyncManager::string_to_service(service_name.toStdString());

    globals::sync_manager.set_service(new_service);

    std::cout << "<setup.cpp> [Log] Sync service changed to ";
    std::cout << SyncManager::service_to_string(new_service) << std::endl;
}
