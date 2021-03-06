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

import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

RowLayout {
    id: shortcutItem
    property string shortcut
    property string description
    Layout.fillWidth: true
    spacing: 10
    Item {
        width: 108
        ShortcutBlock {
            text: shortcutItem.shortcut
        }
    }
    Label {
        text: shortcutItem.description
        font.weight: Font.Light
        lineHeight: parent.height
        Layout.fillWidth: true
    }
}