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
    id: syncDialog
    modal: true
    width: 250

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    closePolicy: Popup.NoAutoClose

    function sync() {
        syncManager.download_wallet();
    }
    function sync_upload() {
        var index = itemsList.currentIndex;
        itemsList.model = 0;
        itemsList.model = dataHolder.get_number_of_items();
        itemsList.setItemIndex(index);

        syncManager.upload_wallet();
    }

    Connections {
        target: syncManager

        onStatusMessageChanged: {
            if (syncDialog.visible) {
                statusLabel.text = syncManager.statusMessage
            }
        }
        onWallet_downloaded: {
            // TODO: Check if wallet was downloaded successfully
            if (syncDialog.visible) {
                if (walletMerger.need_decrypt_online_wallet()) {
                    syncOnlinePasswordDialog.open();
                } else if (walletMerger.is_corrupted()) {
                    syncOnlineFileCorruptedDialog.open();
                } else {
                    sync_upload();
                }
            }
        }
        onWallet_uploaded: {
            if (syncDialog.visible) {
                syncDialog.close();
            }
        }
    }


    ColumnLayout {
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
                syncDialog.close();
            }
        }
    }

}
