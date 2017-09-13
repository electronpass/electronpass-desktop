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

#ifndef PASSWORDS_HPP
#define PASSWORDS_HPP

#include <string>
#include <cassert>

#include <QSettings>
#include <QStandardPaths>
#include <QString>

#include "electronpass/passwords.hpp"

class Passwords : public QObject {
    Q_OBJECT

public:
    Q_INVOKABLE int passStrengthToInt(const QString &pass);

    Q_INVOKABLE QString categoryTooltipText(const QString &pass);

    Q_INVOKABLE QString generateRandomPass(int len);

    Q_INVOKABLE QString generateRandomPassWithRecipe(int len, int digits, int symbols,
                                                     int uppercase);
};

#endif // PASSWORDS_HPP
