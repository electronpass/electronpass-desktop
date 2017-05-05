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

#include "settings.hpp"

void SettingsManager::init(QSettings& settings_) {
    settings = &settings_;

    if (!settings->contains("data_location")) {
        QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

        path = QDir(path + QDir::separator() + "electronpass.wallet").absolutePath();

        settings->setValue("data_location", path);

        // The data file should be created.
        // The problem is that because it will be encrypted, we need a password, so it cannot be
        // created before the app is unlocked.
    }

    if (!settings->contains(kGdriveAccessToken)) settings->setValue(kGdriveAccessToken, "");
    if (!settings->contains(kGdriveRefreshToken)) settings->setValue(kGdriveRefreshToken, "");
    if (!settings->contains(kGdriveTokenExpiration)) settings->setValue(kGdriveTokenExpiration, QDateTime::currentDateTimeUtc());

    if (!settings->contains(kSyncManagerService)) settings->setValue(kSyncManagerService, "none");

    settings->sync();
}

QString SettingsManager::get_data_location() const {
    return settings->value("data_location").toString();
}

bool SettingsManager::set_data_location(const QString& new_data_location) {
    if (settings->value("data_location").toString() == new_data_location) return true;

    // TODO:
    // Move the file
    // Change value in settings
    return false;
}

bool SettingsManager::get_first_usage() const {
    return settings->value("first_usage").toBool();
}

void SettingsManager::set_first_usage(bool value) {
    settings->setValue("first_usage", value);
}

std::string SettingsManager::gdrive_get_access_token() const {
    return settings->value(kGdriveAccessToken).toString().toStdString();
}

std::string SettingsManager::gdrive_get_refresh_token() const {
    return settings->value(kGdriveRefreshToken).toString().toStdString();
}

QDateTime SettingsManager::gdrive_get_token_expiration() const {
    return settings->value(kGdriveTokenExpiration).toDateTime();
}

void SettingsManager::gdrive_set_access_token(const std::string& token) {
    settings->setValue(kGdriveAccessToken, QString(token.c_str()));
}

void SettingsManager::gdrive_set_refresh_token(const std::string &token) {
    settings->setValue(kGdriveRefreshToken, QString(token.c_str()));
}

void SettingsManager::gdrive_set_token_expiration(const QDateTime& expire_date) {
    settings->setValue(kGdriveTokenExpiration, expire_date);
}

std::string SettingsManager::sync_manager_get_service() const {
    return settings->value(kSyncManagerService).toString().toStdString();
}

void SettingsManager::sync_manager_set_service(const std::string &service) {
    settings->setValue(kSyncManagerService, service.c_str());
}
