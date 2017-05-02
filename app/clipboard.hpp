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

#ifndef CLIPBOARD_HPP
#define CLIPBOARD_HPP

#include <QString>
#include <QClipboard>
#include <QApplication>
#include <iostream>
#include <string>

class Clipboard : public QObject {
    Q_OBJECT
    QClipboard *clipboard;

public:
    Clipboard() {};

    // Init needs to be called after GuiApplication is created.
    void init();

    Q_INVOKABLE void set_text(const QString& text);

    // Data in clipboard should be cleared when application is closed or locked.
    Q_INVOKABLE void clear();
};

#endif // CLIPBOARD_HPP
