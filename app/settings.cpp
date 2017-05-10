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

#define kGdriveAccessToken "gdrive_access_token"
#define kGdriveRefreshToken "gdrive_refresh_token"
#define kGdriveTokenExpiration "gdrive_token_expiration"
#define kDropboxAccessToken "dropbox_access_token"
#define kSyncManagerService "sync_manager"

void SettingsManager::init(QSettings& settings_) {
    settings = &settings_;

    if (!settings->contains("first_usage")) settings->setValue("first_usage", true);

    if (!settings->contains("data_folder") || !settings->contains("data_location")) {
        QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

        // Create folders if necessary
        QDir qdir;
        bool success = qdir.mkpath(path);
        assert(success && "Error creating folder at app writable location.");

        settings->setValue("data_folder", path);

        QString data_path = QDir(path + QDir::separator() + "electronpass.wallet").absolutePath();

        settings->setValue("data_location", data_path);
    }

    if (!settings->contains(kGdriveAccessToken)) settings->setValue(kGdriveAccessToken, "");
    if (!settings->contains(kGdriveRefreshToken)) settings->setValue(kGdriveRefreshToken, "");
    if (!settings->contains(kGdriveTokenExpiration)) settings->setValue(kGdriveTokenExpiration, QDateTime::currentDateTimeUtc());

    if (!settings->contains(kDropboxAccessToken)) settings->setValue(kDropboxAccessToken, "");

    if (!settings->contains(kSyncManagerService)) settings->setValue(kSyncManagerService, "none");

    settings->sync();
}

QString SettingsManager::get_data_location() const {
    return settings->value("data_location").toString();
}

QString SettingsManager::get_data_folder() const {
    return settings->value("data_folder").toString();
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
    std::string encrypted_token = settings->value(kGdriveAccessToken).toString().toStdString();

    bool success;
    return token_crypto.decrypt(encrypted_token, success);
}

std::string SettingsManager::gdrive_get_refresh_token() const {
    std::string encrypted_token = settings->value(kGdriveRefreshToken).toString().toStdString();

    bool success;
    return token_crypto.decrypt(encrypted_token, success);
}

QDateTime SettingsManager::gdrive_get_token_expiration() const {
    return settings->value(kGdriveTokenExpiration).toDateTime();
}

void SettingsManager::gdrive_set_access_token(const std::string& token) {
    bool success;
    settings->setValue(kGdriveAccessToken, token_crypto.encrypt(token, success).c_str());
}

void SettingsManager::gdrive_set_refresh_token(const std::string &token) {
    bool success;
    settings->setValue(kGdriveRefreshToken, token_crypto.encrypt(token, success).c_str());
}

void SettingsManager::gdrive_set_token_expiration(const QDateTime& expire_date) {
    settings->setValue(kGdriveTokenExpiration, expire_date);
}

std::string SettingsManager::dropbox_get_access_token() const {
    std::string encrypted_token = settings->value(kDropboxAccessToken).toString().toStdString();
    bool success;
    return token_crypto.decrypt(encrypted_token, success);
}

void SettingsManager::dropbox_set_access_token(const std::string &token) {
    bool success;
    settings->setValue(kDropboxAccessToken, token_crypto.encrypt(token, success).c_str());
}

std::string SettingsManager::sync_manager_get_service() const {
    return settings->value(kSyncManagerService).toString().toStdString();
}

void SettingsManager::sync_manager_set_service(const std::string &service) {
    settings->setValue(kSyncManagerService, service.c_str());
}
