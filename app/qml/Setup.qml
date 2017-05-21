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
import QtQuick.Dialogs 1.0
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
            newUser.forceActiveFocus()
        }
    }

    function continueButtonEnabled(){
      if (setupSwipeView.currentIndex == 0) {
          return true;
      } else if (setupSwipeView.currentIndex == 1) {
          if (password.text != "" && confirmPassword.text == password.text) return true;
          return false;
      } else if (setupSwipeView.currentIndex == 2) {
          return true;
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
                        Keys.onReturnPressed: continueButton.clicked()
                    }
                    RadioButton {
                        id: existingUser
                        text: qsTr("I have already used ElectronPass on other device(s).")
                        Keys.onReturnPressed: continueButton.clicked()
                    }
                }
            }
          }

          Page {
            background: Rectangle{ color: "transparent" }
            visible: newUser.checked

            ColumnLayout {
                width: parent.width
                height: parent.height

                Label {
                    text: qsTr("Please create your master password.")
                }

                ColumnLayout {
                    Layout.topMargin: -16
                    Layout.leftMargin: 32

                    Keys.onReturnPressed: {
                        if (continueButtonEnabled()) continueButton.clicked()
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
                            inputMethodHints: Qt.ImhSensitiveData
                            width: 128
                            font.pointSize: 8
                            focus: true
                            echoMode: TextInput.Password
                            font.family: robotoMonoFont.name
                            placeholderText: "Password"
                            Layout.fillWidth: true
                            selectByMouse: true

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
                            inputMethodHints: Qt.ImhSensitiveData
                            width: 128
                            font.pointSize: 8
                            echoMode: TextInput.Password
                            placeholderText: "Password again"
                            font.family: robotoMonoFont.name
                            Layout.fillWidth: true
                            selectByMouse: true

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
        Page {
            background: Rectangle{ color: "transparent" }

            ColumnLayout {
                anchors.fill: parent

                Label {
                    text: qsTr("Please select an option from where you want to restore your data.")
                }

                Rectangle {
                    Layout.topMargin: 16
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredHeight: 300
                    Layout.preferredWidth: parent.width
                    color: Material.color(Material.Grey, Material.Shade100)

                    ListView {
                        id: syncList
                        anchors.fill: parent
                        highlight: Rectangle { color: Material.color(Material.Blue, Material.Shade200) }
                        focus: true
                        highlightMoveDuration: 0
                        currentIndex: 0
                        Keys.onReturnPressed: continueButton.clicked()

                        model: ListModel {
                            ListElement {
                                name: "Backup file"
                            }
                            ListElement {
                                name: "Google Drive"
                            }
                            ListElement {
                                name: "Dropbox"
                            }
                        }
                        delegate: ItemDelegate {
                            id: delegate

                            Control {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom

                                Label {
                                    id: title
                                    text: name
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.verticalCenter: parent.verticalCenter
                                    leftPadding: 16
                                    rightPadding: 16
                                    topPadding: 16
                                    font.weight: Font.Medium
                                    color: "black"

                                }

                            }

                            width: syncList.width
                            onClicked: {
                                syncList.currentIndex = model.index;
                            }
                        }
                    }
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
                onClicked: {
                    if (setupSwipeView.currentIndex == 1 || setupSwipeView.currentIndex == 2) {
                        newUser.forceActiveFocus();
                        setupSwipeView.currentIndex = 0;
                    }
                }
            }

            Button {
                anchors.right: parent.right
                text: qsTr("Continue")
                id: continueButton
                enabled: continueButtonEnabled()

                onClicked: {
                    if (setupSwipeView.currentIndex == 0){
                        if (newUser.checked) {
                            password.forceActiveFocus();
                            setupSwipeView.currentIndex = 1;
                        } else {
                            syncList.forceActiveFocus();
                            setupSwipeView.currentIndex = 2;
                        }
                    } else if (setupSwipeView.currentIndex == 1) {

                      if (setup.set_password(password.text)) {
                          unlockGUI()
                          setup.finish()
                          setupView.visible = false

                      } else console.log("[Error] Error in Setup.qml")
                    } else if (setupSwipeView.currentIndex == 2) {
                        if (syncList.currentIndex == 0) {
                            fileDialog.open()
                        } else {
                            if (syncList.currentIndex == 1) setup.set_sync_service("gdrive");
                            if (syncList.currentIndex == 2) setup.set_sync_service("dropbox");

                            setupFromSyncServiceDialog.open();
                        }
                    }
                }
            }
        }
    }


    FileDialog {
        id: fileDialog
        title: "Please choose a backup wallet file."
        folder: shortcuts.home
        selectMultiple: false
        onAccepted: {
            var url = Qt.resolvedUrl(fileDialog.fileUrl)
            var error = dataHolder.restore_wallet(url, "")
            if (error == 0) {
                setup.finish()
                setupView.visible = false
                unlockGUI()
            } else if (error == 1) {
                passwordDialog.path = url
                passwordDialog.open()
            } else if (error == 2) {
                messageDialog.openWithMsg("Wallet is corrupted", "Wallet file seems to be corrupted.")
            } else if (error == 3) {
                messageDialog.openWithMsg("File could not be read", "Wallet file seems to be missing or it has wrong permissions set.")
            }
        }
        onRejected: {}
    }

    Dialog {
        id: passwordDialog
        modal: true

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        onClosed: {
            passwordText.text = ""
            errorLabel.text = ""
        }
        onOpened: {
            passwordText.forceActiveFocus();
        }

        property string path: ""

        ColumnLayout {
            anchors.fill: parent
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Please enter the password for backuped wallet.")
            }
            Label {
                id: errorLabel
                text: ""
                color: "red"
            }
            TextField {
                id: passwordText
                inputMethodHints: Qt.ImhSensitiveData
                Layout.alignment: Qt.AlignHCenter
                echoMode: TextInput.Password
                placeholderText: qsTr("Password")
                selectByMouse: true
                Keys.onReturnPressed: {
                    restoreButton.clicked()
                }
            }
            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                Button {
                    id: restoreButton
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: 8
                    text: qsTr("Restore")
                    onClicked: {
                        var success = dataHolder.restore_wallet(passwordDialog.path, passwordText.text)
                        if (success == 0) {
                            errorLabel.text = ""
                            passwordText.text = ""
                            passwordDialog.close()
                            setup.finish()
                            setupView.visible = false
                            unlockGUI()
                        } else if (success == 1) {
                            errorLabel.text = qsTr("Wrong password.")
                            passwordText.forceActiveFocus()
                            passwordText.selectAll()
                        } else if (success == 4) {
                            passwordDialog.close()
                            messageDialog.openWithMsg("Wallet could not be copied", "");
                        }
                    }
                }
                Button {
                    anchors.left: parent.horizontalCenter
                    anchors.leftMargin: 8
                    text: qsTr("Cancel")
                    onClicked: {
                        passwordDialog.close()
                    }
                }
            }

        }
    }
}
