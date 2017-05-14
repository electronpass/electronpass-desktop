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

#ifndef SETUP_HPP
#define SETUP_HPP

#include <QObject>
#include <QString>
#include <QUrl>
#include <string>
#include <iostream>
#include <electronpass/wallet.hpp>
#include "globals.hpp"

class Setup : public QObject {
    Q_OBJECT
    bool first_usage;
public:
    Setup();

    // true if setup is needed (usually at first launch of this app).
    Q_INVOKABLE bool need_setup();

    // Sets first_usage in settings to false.
    Q_INVOKABLE void finish();

    // Creates new empty wallet and saves it.
    Q_INVOKABLE bool set_password(const QString& password);

    Q_INVOKABLE bool restore_data_from_file(const QString& file_url);

    Q_INVOKABLE QString get_sync_service() const;
    Q_INVOKABLE void set_sync_service(const QString& service_name);
};

#endif // SETUP_HPP
