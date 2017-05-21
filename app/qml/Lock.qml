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
import "Dialogs"

Image {
    source: "qrc:/res/img/lock_background.jpg"
    fillMode: Image.PreserveAspectCrop
    id: lockRoot

    property int wrongPassCounter: 0

    width: window.width
    height: window.height

    Material.theme: Material.Dark

    Rectangle {
        width: window.width
        height: window.height
        color: "black"
        opacity: 0.85

        ColumnLayout {
            anchors.centerIn: parent
            id: container

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                Layout.topMargin: 64
                mipmap: true
                source: "qrc:/res/img/logo_transparent.png"
            }

            TextField {
                id: passInput
                inputMethodHints: Qt.ImhSensitiveData
                selectByMouse: true
                property int unlocked: 4  // not unlocked
                focus: true
                font.family: robotoMonoFont.name
                placeholderText: qsTr(" Type password to unlock ") // 6 spaces on each side to make textfield wider (if it's stupid but it works it ain't stupid)
                echoMode: TextInput.Password
                horizontalAlignment: TextInput.AlignHCenter

                Keys.onReturnPressed: {
                    lockRoot.wrongPassCounter += 1;
                    passInput.unlocked = dataHolder.unlock(passInput.text)
                    switch (passInput.unlocked) {
                        case 0:
                            unlockGUI();
                            passInput.clear();
                            toolTip.visible = false;
                            break;
                        case 1:
                            // Should not happen (only on random unsafe systems).
                            toolTip.text = "Crypto initialization was not successful."
                            break
                        case 2:
                            toolTip.text = "Couldn't open data file."
                            break
                        case 3:
                            toolTip.text = "Wrong password."
                            break
                        case 4:
                            toolTip.text = "Wallet file is corrupted."
                            break
                        default:
                            toolTip.text = "Unknown error."
                    }
                    if (passInput.unlocked != 0) {
                        toolTip.show()
                        passInput.selectAll()
                    }
                }
            }

            RowLayout {
                Layout.topMargin: 64
                ToolTip {
                   id: toolTip
                   text: "Locked."
                   timeout: 2000
                   visible: false

                   function show() {
                       timer.restart();
                       visible = true;
                   }

                   Behavior on opacity {
                       NumberAnimation { duration: 300 }
                   }

                   Timer {
                       id: timer

                       interval: toolTip.timeout

                       onTriggered: {
                           if (!running) {
                               toolTip.visible = false;
                           }
                       }
                   }
               }
           }
        }

        Button {
            anchors.top: container.bottom
            anchors.horizontalCenter: container.horizontalCenter
            anchors.topMargin: -32
            visible: lockRoot.wrongPassCounter > 0
            flat: true
            text: "Reset ElectronPass"
            onClicked: {
                resetDialog.open()
            }
        }

        ResetWalletDialog {
            id: resetDialog
        }
    }

    function setFocus() {
        passInput.forceActiveFocus();
    }
    function removeFocus() {
        passInput.focus = false;
    }

}
