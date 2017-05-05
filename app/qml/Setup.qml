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

        // ElectronPass logo & stuff
        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: 15
            Layout.bottomMargin: 20
            Layout.preferredHeight: 64

            Image {
                source: "qrc:/res/img/logo_transparent.png"
            }
            Label {
                text: qsTr("  ElectronPass")
                color: "white"
                font.pixelSize: 24
                horizontalAlignment: Qt.AlignHCenter
            }
        }

        // First "page"
        ColumnLayout {
            id: firstPage
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredWidth: 500

            Label {
                text: qsTr("Hi awesome user! Welcome to the ElectronPass.")
            }
            ColumnLayout {
                RadioButton {
                    id: newUser
                    checked: true
                    text: qsTr("I am a new ElectronPass user.")
                }
                RadioButton {
                    id: existingUser
                    text: qsTr("I have already used ElectronPass on other device(s).")
                }
            }

            // Bad idea for vertical fill
            ColumnLayout {}

            Button {
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                text: qsTr(" Continue ")
                Layout.bottomMargin: 10

                onClicked: {
                    if (newUser.checked) {
                        // TODO: somehow create animation
                        firstPage.visible = false
                        createPasswordForm.visible = true

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

        ColumnLayout {
            id: createPasswordForm
            visible: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredWidth: 500

            Label {
                text: qsTr("Please create your master password. Make sure you never forget your "
                    + "\npassword, otherwise there is now way to recover your data.")
            }

            ColumnLayout {
                Layout.topMargin: 10

                RowLayout {
                    Label {
                        text: qsTr("Enter master password     ")
                    }
                    TextField {
                        id: password
                        Layout.leftMargin: 15
                        echoMode: TextInput.Password
                    }
                }
                RowLayout {
                    Label {
                        text: qsTr("Confirm master password")
                    }
                    TextField {
                        id: confirmPassword
                        Layout.leftMargin: 15
                        echoMode: TextInput.Password
                    }
                }

            }

            // Bad idea for vertical fill
            ColumnLayout {}

            Button {
                Layout.alignment: Qt.AlignRight
                Layout.bottomMargin: 10
                text: qsTr(" Continue ")

                onClicked: {
                    // TODO: Create a popup window to confirm creating master password.
                    if (password.text == "") {
                        console.log("Enter master password")
                    } else if (password.text == confirmPassword.text) {
                        if (setup.set_password(password.text)) {
                            unlockGUI()
                            setup.finish()
                            setupView.visible = false
                        } else console.log("error")
                    } else {
                        console.log("Passwords do not match")
                    }
                }
            }
        }

    }



}
