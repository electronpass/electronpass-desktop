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

Image {
    source: "qrc:/res/img/lock_background.jpg"
    fillMode: Image.PreserveAspectCrop

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

            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                mipmap: true
                source: "qrc:/res/img/logo_transparent.png"
            }

            TextField {
                id: passInput
                selectByMouse: true
                property int unlocked: 4  // not unlocked
                focus: true
                font.family: robotoMonoFont.name
                placeholderText: qsTr(" Type password to unlock ") // 6 spaces on each side to make textfield wider (if it's stupid but it works it ain't stupid)
                echoMode: TextInput.Password
                horizontalAlignment: TextInput.AlignHCenter
                Keys.onReturnPressed: {
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

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                flat: true
                text: "Reset wallet"
                onClicked: {
                    resetDialog.open()
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

        Dialog {
            id: resetDialog

            x: (parent.width - width) / 2
            y: (parent.height - height) / 2

            ColumnLayout {
                anchors.fill: parent
                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Warning: your current wallet will be deleted!"
                    font.weight: Font.Bold
                    font.pointSize: 12
                }

                RowLayout {
                    Layout.maximumWidth: 330
                    Item {
                      width: 156
                      Label {
                          id: passLabel
                          anchors.right: parent.right
                          anchors.left: parent.left
                          anchors.verticalCenter: parent.verticalCenter
                          text: qsTr("Master password: ")
                          font.weight: Font.Light
                          horizontalAlignment: Text.AlignRight
                      }
                    }
                    TextField {
                        id: password
                        width: 128
                        font.pointSize: 8
                        focus: true
                        echoMode: TextInput.Password
                        font.family: robotoMonoFont.name
                        placeholderText: "Password"
                        Layout.fillWidth: true

                        background: PassStrengthIndicator {
                            height: password.height-16
                            password: password.text
                            type: "password"
                            anchors.centerIn: parent
                            width: parent.width
                        }
                    }
                }
                RowLayout {
                    Layout.maximumWidth: 330
                    Item {
                      width: 156
                      Label {
                          anchors.right: parent.right
                          anchors.left: parent.left
                          anchors.verticalCenter: parent.verticalCenter
                          text: qsTr("Confirm password: ")
                          font.weight: Font.Light
                          horizontalAlignment: Text.AlignRight
                      }
                    }
                    TextField {
                        id: confirmPassword
                        width: 128
                        font.pointSize: 8
                        echoMode: TextInput.Password
                        placeholderText: "Password again"
                        font.family: robotoMonoFont.name
                        Layout.fillWidth: true

                        background: ConfirmPassIndicator {
                            height: password.height-16
                            valid: (confirmPassword.text == password.text)
                            anchors.centerIn: parent
                            width: parent.width
                        }
                    }
                }

                RowLayout {
                    Button {
                        flat: true
                        text: "I understand, delete my wallet"
                        font.pointSize: 8
                        enabled: password.text != "" && password.text == confirmPassword.text
                        onClicked: {
                            resetDialog.close()
                            dataHolder.new_wallet(password.text)
                            dataHolder.unlock(password.text)
                            setup.set_sync_service("none")
                            unlockGUI()
                        }
                    }

                    Button {
                        flat: true
                        highlighted: true
                        text: "Cancel"
                        onClicked: {
                            resetDialog.close()
                        }
                    }
                }
            }
        }

        Dialog {
            id: setPasswordDialog

            x: (parent.width - width) / 2
            y: (parent.height - height) / 2
        }
    }

    function setFocus() {
        passInput.forceActiveFocus();
    }
    function removeFocus() {
        passInput.focus = false;
    }

}
