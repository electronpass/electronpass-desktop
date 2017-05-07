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

    function continueButtonEnabled(){
      if (setupSwipeView.currentIndex == 0){
          if (newUser.checked) return true;
          return false;
      }else if (setupSwipeView.currentIndex == 1){
          if (password.text != "" && confirmPassword.text == password.text) return true;
          return false;
      }
    }

    ColumnLayout {
        anchors.fill: parent

        // ElectronPass logo & stuff
        RowLayout {
            id: setupLogoContainer
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

        SwipeView {
          id: setupSwipeView
          anchors.top: setupLogoContainer.bottom
          anchors.bottom: buttonsRow.top
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.margins: 42
          clip: true
          interactive: false

          Page {
            background: Rectangle{ color: "transparent" }

            ColumnLayout {
                Label {
                    text: qsTr("Hi awesome user! Welcome to the ElectronPass.")
                }
                ColumnLayout {
                    Layout.topMargin: 16
                    Layout.leftMargin: 16
                    spacing: -16
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
            }
          }

          Page {
            background: Rectangle{ color: "transparent" }

            ColumnLayout {
                width: parent.width
                height: parent.height

                Label {
                    text: qsTr("Please create your master password.")
                }

                ColumnLayout {
                    Layout.topMargin: -16
                    Layout.leftMargin: 32

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
                            echoMode: TextInput.Password
                            font.family: robotoMonoFont.name
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
                }

                Infobar {
                    text: "Make sure you don't forget your password, there is no way to recover it."
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBottom
                }
              }
          }
        }

        // buttons row
        RowLayout {
            Layout.alignment: Qt.AlignBottom
            anchors.right: parent.right
            anchors.margins: 16
            Layout.bottomMargin: 8
            id: buttonsRow

            Button {
                anchors.right: continueButton.left
                anchors.rightMargin: 16
                text: qsTr("Back")
                enabled: (setupSwipeView.currentIndex > 0)
                onClicked: setupSwipeView.currentIndex -= 1;
            }

            Button {
                anchors.right: parent.right
                text: qsTr("Continue")
                id: continueButton
                enabled: continueButtonEnabled()

                onClicked: {
                    if (setupSwipeView.currentIndex == 0){
                        if (newUser.checked) setupSwipeView.currentIndex = 1;
                    } else if (setupSwipeView.currentIndex == 1) {
                      if (setup.set_password(password.text)) {
                          unlockGUI()
                          setup.finish()
                          setupView.visible = false
                      } else console.log("error")
                    }
                }
            }
        }
    }
}
