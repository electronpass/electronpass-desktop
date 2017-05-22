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

#ifndef SETTINGS_HPP
#define SETTINGS_HPP

#include <string>
#include <cassert>
#include <iostream>

#include <QSettings>
#include <QStandardPaths>
#include <QString>
#include <QDateTime>
#include <QDir>

#include <electronpass/crypto.hpp>
#include "sync/keys.hpp"

class SettingsManager {

private:
    QSettings *settings;
    electronpass::Crypto token_crypto;

public:
    SettingsManager(): token_crypto(kTokenPassword) {}

    // Checks if all settings are initialized and sets default values if not.
    void init(QSettings &settings_);

    void reset();

    // Returns location where the file with passwords is stored.
    QString get_data_location() const;
    QString get_data_folder() const;

    bool get_first_usage() const;
    void set_first_usage(bool value);

    // Google ouath2 settings
    std::string gdrive_get_access_token() const;
    std::string gdrive_get_refresh_token() const;
    QDateTime gdrive_get_token_expiration() const;

    void gdrive_set_access_token(const std::string &token);
    void gdrive_set_refresh_token(const std::string &token);
    void gdrive_set_token_expiration(const QDateTime &expire_date);

    // Dropbox oauth2 settings
    std::string dropbox_get_access_token() const;
    void dropbox_set_access_token(const std::string &token);

    // Sync manager settings
    std::string sync_manager_get_service() const;
    void sync_manager_set_service(const std::string &service);
};

#endif // SETTINGS_HPP
