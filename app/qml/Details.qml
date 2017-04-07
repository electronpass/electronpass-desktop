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
import "Components"

Pane {
    padding: 0
    leftPadding: 8
    Material.elevation: 1
    Material.background: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade800) : "white"

    id: details
    property color greyTextColor: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade400) : Material.color(Material.Grey, Material.Shade700)

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        id: rootColumnLayout

        RowLayout {
            Layout.fillWidth: true
            Layout.bottomMargin: 16
            Label {
                text: "Github"
                font.pixelSize: 20
                Layout.fillWidth: true
            }
            ToolButton {
                font.family: materialIconsFont.name
                font.pixelSize: 18
                text: qsTr("\uE150")
            }
            ToolButton {
                font.family: materialIconsFont.name
                font.pixelSize: 18
                text: qsTr("\uE872")
                onClicked: deleteConfirmationDialog.open()
            }
        }

        ItemDetail {
            title: "Username"
            content: "zigapk"
        }

        ItemDetail {
            url: true
            title: "Url"
            content: "https://github.com/login"
        }

        ItemDetail {
            secure: true
            title: "Password"
            content: "asdfasdf"
        }
    }
}