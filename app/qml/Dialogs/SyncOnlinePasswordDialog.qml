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
    id: syncOnlinePasswordDialog
    modal: true

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    closePolicy: Popup.NoAutoClose

    onClosed: {
        errorLabel.text = ""
        onlinePassword.text = ""
    }
    onOpened: {
        onlinePassword.forceActiveFocus();
    }

    ColumnLayout {
        anchors.fill: parent
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Wallet saved online appears to be encrypted\n" +
                        "with different password. Enter that password\nto merge wallets.")
        }
        Label {
            id: errorLabel
            text: qsTr("")
            color: "red"
        }
        TextField {
            id: onlinePassword
            inputMethodHints: Qt.ImhSensitiveData
            Layout.alignment: Qt.AlignHCenter
            font.pointSize: 10
            echoMode: TextInput.Password
            placeholderText: "Password"
            font.family: robotoMonoFont.name
            Keys.onReturnPressed: confirmButton.clicked()
        }
        RowLayout {
            Button {
                id: confirmButton
                text: qsTr("Decrypt")
                onClicked: {
                    var error = walletMerger.decrypt_online_wallet(onlinePassword.text);
                    onlinePassword.text = "";
                    if (error == 0) {
                        errorLabel.text = "";
                        syncOnlinePasswordDialog.close();

                        syncDialog.sync_upload();
                    } else if (error == 1) {
                        errorLabel.text = "Wrong password";
                    } else if (error == 2) {
                        // should not happen, becuase, sync dialog must redirect on corrupted file dialog.
                        errorLabel.text = "Online wallet appears to be corrupted.";
                        confirmButton.active = false;
                    }
                }
            }
            Button {
                // TODO: alert if user wants to discard online wallet, which will be overwritten.
                id: discardButton
                text: qsTr("Discard")
                onClicked: {
                    syncOnlinePasswordDialog.close();
                    syncDialog.sync_upload();
                }
            }
        }
    }

}
