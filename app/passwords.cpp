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

#include "passwords.hpp"

int Passwords::passStrengthToInt(const QString &pass) {
    electronpass::passwords::strength_category category;
    category = electronpass::passwords::password_strength_category(pass.toStdString());

    switch (category) {
        case electronpass::passwords::strength_category::TERRIBLE:
            return 1;
        case electronpass::passwords::strength_category::BAD:
            return 2;
        case electronpass::passwords::strength_category::MODERATE:
            return 3;
        case electronpass::passwords::strength_category::GOOD:
            return 4;
        case electronpass::passwords::strength_category::VERY_STRONG:
            return 5;
    }
    assert(false && "No such enum state!");
}

QString Passwords::categoryTooltipText(const QString &pass) {
    return QString::fromUtf8(electronpass::passwords::human_readable_password_strength_category(
            pass.toStdString()).c_str());
}

QString Passwords::generateRandomPass(int len) {
    return QString::fromUtf8(electronpass::passwords::generate_random_pass(len).c_str());
}

QString Passwords::generateRandomPassWithRecipe(int len, int digits, int symbols, int uppercase) {
    return QString::fromUtf8(electronpass::passwords::generate_random_pass(len, digits, symbols,
                                                                           uppercase).c_str());
}
