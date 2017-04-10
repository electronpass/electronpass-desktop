#include "settings.hpp"

void SettingsManager::init(QSettings& settings_) {
    settings = &settings_;

    if (!settings->contains("theme")) settings->setValue("theme", 0);

    if (!settings->contains("data_location")) {
        QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        path += QString("/electronpass.wallet");

        settings->setValue("data_location", path);

        // The data file should be created.
        // The problem is that because it will be encrypted, we need a password, so it cannot be
        // created before the app is unlocked.
    }

    if (!settings->contains(kGdriveAccessToken)) settings->setValue(kGdriveAccessToken, "");
    if (!settings->contains(kGdriveRefreshToken)) settings->setValue(kGdriveRefreshToken, "");
    if (!settings->contains(kGdriveTokenExpiration)) settings->setValue(kGdriveTokenExpiration, QDateTime::currentDateTimeUtc());


    settings->sync();
}

QString SettingsManager::get_data_location() {
    return settings->value("data_location").toString();
}

bool SettingsManager::set_data_location(const QString& new_data_location) {
    if (settings->value("data_location").toString() == new_data_location) return true;

    // TODO:
    // Move the file
    // Change value in settings
    return false;
}

std::string SettingsManager::gdrive_get_access_token() {
    return settings->value(kGdriveAccessToken).toString().toStdString();
}

std::string SettingsManager::gdrive_get_refresh_token() {
    return settings->value(kGdriveRefreshToken).toString().toStdString();
}

QDateTime SettingsManager::gdrive_get_token_expiration() {
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
