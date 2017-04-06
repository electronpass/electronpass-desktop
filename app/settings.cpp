#include "settings.hpp"

void SettingsManager::init() {
    if (!settings.contains("theme")) settings.setValue("theme", 0);

    if (!settings.contains("data_location")) {
        QString path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        path += QString("/electronpass.wallet");

        settings.setValue("data_location", path);

        // The data file should be created.
        // The problem is that because it will be encrypted, we need a password, so it cannot be
        // created before the app is unlocked. 
    }
    settings.sync();
}

QString SettingsManager::get_data_location() {
    return settings.value("data_location").toString();
}

bool SettingsManager::set_data_location(const QString& new_data_location) {
    if (settings.value("data_location").toString() == new_data_location) return true;

    // TODO:
    // Move the file
    // Change value in settings
    return false;
}
