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
#include <string>
#include <iostream>
#include "globals.hpp"

class Setup : public QObject {
    Q_OBJECT
    bool first_usage;
public:
    Setup();

    // true if setup is needed (usually at first launch of this app).
    Q_INVOKABLE bool need_setup();

    Q_INVOKABLE void finish();

    // Q_INVOKABLE void set_password();
    // Q_INVOKABLE void set_sync_service();
    // Q_INVOKABLE void set_file_path();
};

#endif // SETUP_HPP
