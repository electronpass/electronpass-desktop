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
    id: confirmIndicator
    property bool valid: false

    function getColor(){
        if (parent.text == "") return Material.color(Material.Grey, Material.Shade500)
        else if (valid) return Material.color(Material.Green, Material.Shade500)
        else return Material.color(Material.Red, Material.Shade500)
    }

    Item {
        anchors.bottom: confirmIndicator.bottom
        Layout.fillWidth: true
        height: 2

        Rectangle {
            height: 2
            radius: 1
            opacity: (confirmIndicator.parent.text == "") ? 0.5 : 1
            width: parent.width
            color: confirmIndicator.getColor()
        }
    }
}
