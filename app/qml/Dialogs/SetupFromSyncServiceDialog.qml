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

import QtQuick 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import "../Components"

Dialog {
    id: setupFromSyncServiceDialog
    modal: true

    width: Math.min(parent.width * 0.5, 300)
    height: Math.min(parent.height * 0.4, 200)

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    closePolicy: Popup.NoAutoClose

    onOpened: syncManager.download_wallet(false)

    Connections {
        target: syncManager

        onStatusMessageChanged: {
            if (setupFromSyncServiceDialog.visible) statusLabel.text = syncManager.statusMessage
        }
        onWallet_downloaded: {
            if (setupFromSyncServiceDialog.visible && error == 0) {
                setupFromSyncServiceDialog.close()
                passwordFromSyncServiceDialog.open()
            } else if (setupFromSyncServiceDialog.visible) {
                if (error == 1 || error == 4 || error == 5) return
                // error codes, that shouldn't happen here or don't have to be explicitly prompted
                // aborted, no sync provider selected, syncing in progress

                var msg
                if (error == 2) msg = "Connection error, network server is unreachable"
                else if (error == 3) msg = "Could not login to network server"
                else if (error == 6) msg = "Could not save downloaded wallet"
                messageDialog.openWithMsg(msg, "")
                setupFromSyncServiceDialog.close()
            }
        }
    }
    ColumnLayout {
        id: downloadLayout
        anchors.fill: parent
        BusyIndicator {
            Layout.alignment: Qt.AlignHCenter
            running: true
        }
        Label {
            id: statusLabel
            Layout.alignment: Qt.AlignHCenter
            text: syncManager.statusMessage
        }
        Button {
            text: qsTr("Cancel")
            Layout.alignment: Qt.AlignHCenter
            anchors.left: parent.left
            anchors.right: parent.right
            Layout.bottomMargin: -16
            highlighted: true
            flat: true
            onClicked: {
                syncManager.abort()
                setupFromSyncServiceDialog.close()
            }
        }
    }

    Dialog {
        id: passwordFromSyncServiceDialog
        modal: true

        width: Math.min(setupRoot.width * 0.65, 500)
        height: Math.min(setupRoot.height * 0.4, 300)

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        closePolicy: Popup.NoAutoClose

        onOpened: passwordField.forceActiveFocus()
        onClosed: {
            errorBar.text = ""
            passwordField.clear()
        }

        title: qsTr("Unlock your wallet")

        ColumnLayout {
            width: parent.width
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Please enter password to unlock your wallet."
            }
            Infobar {
                id: errorBar
                text: ""
                Layout.fillWidth: true
                opacity: 0
                onTextChanged: visible = text != ""
            }
            TextField {
                id: passwordField
                inputMethodHints: Qt.ImhSensitiveData
                Layout.alignment: Qt.AlignHCenter
                font.pointSize: 10
                echoMode: TextInput.Password
                placeholderText: "Password"
                focus: true
                font.family: robotoMonoFont.name
                Keys.onReturnPressed: unlockButton.clicked()
            }
        }

        footer: DialogButtonBox {
            Button {
                id: unlockButton
                text: qsTr("Unlock")
                flat: true
                onClicked: {
                    if (passwordField.text != "") {
                        var error = dataHolder.unlock(passwordField.text)
                        if (error == 0) {
                            passwordFromSyncServiceDialog.close()
                            unlockGUI()
                            setupView.visible = false
                            setup.finish()

                        } else if (error == 1) {
                            errorBar.text = qsTr("Crypto initialization was not successful.")
                            errorBar.opacity = 1
                        } else if (error == 2) {
                            errorBar.text = qsTr("Couldn't open data file.")
                            errorBar.opacity = 1
                        } else if (error == 3) {
                            errorBar.text = qsTr("Wrong password")
                            errorBar.opacity = 1
                            passwordField.forceActiveFocus()
                            passwordField.selectAll()
                        } else if (error == 4) {
                            errorBar.text = qsTr("Online file appears to be corrupted")
                            errorBar.opacity = 1
                            passwordField.visible = false
                            unlockButton.visible = false
                        }
                    } else {
                        errorBar.text = qsTr("Enter a password")
                        errorBar.opacity = 1
                    }
                }
            }
            Button {
                text: qsTr("Cancel")
                flat: true
                onClicked: {
                    passwordFromSyncServiceDialog.close()
                }
            }
        }
    }
}
