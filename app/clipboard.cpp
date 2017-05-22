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

#include "clipboard.hpp"

#define kClipboardMode QClipboard::Clipboard

void Clipboard::init() {
    clipboard = QApplication::clipboard();
}

void Clipboard::set_text(const QString &text) {
    clipboard->setText(text, kClipboardMode);
    last_copied = text.toStdString();
}

void Clipboard::clear() {
    if (clipboard->text(kClipboardMode).toStdString() == last_copied) {
        clipboard->clear();
        last_copied = "";
    }
}
