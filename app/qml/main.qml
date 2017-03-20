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
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("ElectronPass")

    Material.theme: Material.Light
    Material.accent: Material.Cyan

    header: ToolBar {
            Material.background: Material.color(Material.Grey, Material.Shade800)
            Image {
                id: image
                x: 8
                y: 8
                width: 32
                height: 32
                mipmap: true
                source: "qrc:/res/logo_transparent_256.png"
            }
            RowLayout {
                anchors.fill: parent
                Label {
                    text: "ElectronPass"
                    elide: Label.ElideRight
                    leftPadding: 48
                    horizontalAlignment: Qt.AlignHLeft
                    verticalAlignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }
                ToolButton {
                    text: qsTr("⋮")
                    onClicked: menu.open()
                }
            }
        }

    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: 0
        Rectangle {
            color: Material.color(Material.Red, Material.Shade500)
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 250
            Layout.preferredWidth: 250
            Layout.maximumWidth: 250
            Layout.minimumHeight: 150
            Text {
                anchors.centerIn: parent
                text: parent.width + "x" + parent.height
            }
        }
        Rectangle {
            color: Material.color(Material.Blue, Material.Shade500)
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 200
            Layout.preferredHeight: 100
            Text {
                anchors.centerIn: parent
                text: parent.width + "x" + parent.height
            }
        }
    }
}
