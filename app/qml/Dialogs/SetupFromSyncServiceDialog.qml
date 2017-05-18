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

Dialog {
    id: setupFromSyncServiceDialog
    modal: true

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    closePolicy: Popup.NoAutoClose

    onOpened: {
        syncManager.download_wallet(false);
    }
    onClosed: {
        // Reset visibility
        downloadLayout.visible = true;
        passwordLayout.visible = false;
    }

    Connections {
        target: syncManager

        onStatusMessageChanged: {
            if (setupFromSyncServiceDialog.visible) {
                statusLabel.text = syncManager.statusMessage
            }
        }
        onWallet_downloaded: {
            // TODO: check if wallet was downloaded successfully
            if (setupFromSyncServiceDialog.visible) {
                downloadLayout.visible = false;
                passwordLayout.visible = true;
            }
        }
    }

    ColumnLayout {
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
                    syncManager.abort();
                    setupFromSyncServiceDialog.close();
                }
            }
        }

        ColumnLayout {
            id: passwordLayout
            anchors.fill: parent
            visible: false

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Please enter password to unlock your wallet.")
            }
            Label {
                id: errorLabel
                Layout.alignment: Qt.AlignHCenter
                text: ""
                color: "red"
            }

            TextField {
                id: passwordField
                Layout.alignment: Qt.AlignHCenter
                font.pointSize: 10
                echoMode: TextInput.Password
                font.family: robotoMonoFont.name
            }
            RowLayout {
                Button {
                    id: unlockButton
                    text: qsTr("Unlock")
                    onClicked: {
                        if (passwordField.text != "") {
                            var error = dataHolder.unlock(passwordField.text);
                            if (error == 0) {
                                setupFromSyncServiceDialog.close();
                                unlockGUI();
                                passwordField.clear();
                                setupView.visible = false;
                                setup.finish();

                            } else if (error == 1) {
                                errorLabel.text = qsTr("Crypto initialization was not successful.")
                            } else if (error == 2) {
                                errorLabel.text = qsTr("Couldn't open data file.")
                            } else if (error == 3) {
                                errorLabel.text = qsTr("Wrong password");
                                passwordField.forceActiveFocus();
                                passwordField.selectAll();
                            } else if (error == 4) {
                                errorLabel.text = qsTr("Online file appears to be corrupted")
                                passwordField.visible = false;
                                unlockButton.visible = false;
                            }
                        } else {
                            errorLabel.text = qsTr("Enter a password");
                        }
                    }
                }

                Button {
                    text: qsTr("Cancel")
                    onClicked: {
                        setupFromSyncServiceDialog.close();
                    }
                }
            }
        }
    }
}
