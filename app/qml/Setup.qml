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

Rectangle {
    width: window.width
    height: window.height

    color: Material.color(Material.Grey, Material.Shade900)
    Material.theme: Material.Dark

    // visible only if setup is needed
    visible: setup.need_setup()

    Component.onCompleted: {
        if (setup.need_setup()) {
            lock.visible = false
            lock.removeFocus()
        }
    }

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Image {
                source: "qrc:/res/img/logo_transparent.png"
            }
            Label {
                text: qsTr("  ElectronPass")
                font.pixelSize: 24
                horizontalAlignment: Qt.AlignHCenter
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            RadioButton {
                id: new_user
                checked: true
                text: qsTr("I am a new ElectronPass user.")
            }
            RadioButton {
                id: existing_user
                text: qsTr("I have already used ElectronPass on other device(s).")
            }
        }

        Button {
            Layout.alignment: Qt.AlignCenter
            text: qsTr(" Continue ")
            onClicked: {
                if (new_user.checked) {
                    console.log("[Log] New user.")
                } else {
                    // TODO: Existing user...
                    console.log("[Log] Existing user file select is currently not supported.")

                    setupView.visible = false
                    setup.finish()

                    lockGUI()
                }
            }
        }
    }



}
