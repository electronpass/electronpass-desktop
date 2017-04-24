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
    id: strengthIndicator
    property string password: parent.content
    property int strength: passwordManager.passStrengthToInt(password) //strength in int from 1 to 5

    function getColor() {
        if (strengthIndicator.strength == 1) return Material.color(Material.Red, Material.Shade500);
        if (strengthIndicator.strength == 2) return Material.color(Material.DeepOrange, Material.Shade500);
        if (strengthIndicator.strength == 3) {
            if (Material.theme == Material.Dark) return Material.color(Material.Yellow, Material.Shade500);
            return Material.color(Material.Amber, Material.Shade500);
        }
        if (strengthIndicator.strength == 4) return Material.color(Material.LightGreen, Material.Shade500);
        if (strengthIndicator.strength == 5) return Material.color(Material.Green, Material.Shade500);
        return Material.color(Material.Grey, Material.Shade500);
    }

    Item {
        anchors.bottom: strengthIndicator.bottom
        Layout.fillWidth: true
        height: 2

        Rectangle {
            height: 2
            radius: 1
            width: parent.width
            opacity: 0.5
            color: Material.color(Material.Grey, Material.Shade500)
        }


        Rectangle {
            height: 2
            radius: 1
            width: parent.width / 5 * strengthIndicator.strength
            color: strengthIndicator.getColor()

            Behavior on width {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutCubic
                }
            }
        }
    }
}
