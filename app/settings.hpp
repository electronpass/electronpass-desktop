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

#include <QSettings>
#include <QStandardPaths>
#include <QString>
#include <string>

class SettingsManager {

private:
    QSettings settings;

public:
    SettingsManager(QSettings& settings_): settings(&settings_) {}

    // Checks if all settings are initialized and sets default values if not.
    void init();

    // Returns location where the file with passwords is stored.
    QString get_data_location();

    // TODO: Sets the location where the file with passowds will be stored.
    // TODO: File with passwords must be actually moved, which may cause some problems on different platforms.
    bool set_data_location(const QString& new_data_location);

};

#endif // SETTINGS_HPP
