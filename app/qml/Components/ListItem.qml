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


ItemDelegate {
    id: delegate

    Control {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Label {
            id: title
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 8
            leftPadding: 16
            rightPadding: 16
            font.weight: Font.Medium
            font.pointSize: 13
            color: Material.foreground
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft

            text: dataHolder.get_item_name(modelData)
        }

        Label {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: title.bottom
            anchors.topMargin: 0
            leftPadding: 16
            rightPadding: 16
            font.weight: Font.Light
            font.pointSize: 10
            color: Material.hintTextColor
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignLeft

            text: dataHolder.get_item_subname(modelData)
        }

    }

    width: listView.width - scrollIndicator.width
    onClicked: {
        listView.currentIndex = modelData;
    }
}
