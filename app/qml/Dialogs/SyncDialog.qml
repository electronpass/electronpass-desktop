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

    function messageError(error) {
        if (error == 0 || error == 1 || error == 4 || error == 6) return false
        // No message for success, already syncing, abort, could not open file
        // don't need to close dialog

        var msg = "Unknown error"
        if (error == 2) msg = "Connection error, network server is unreachable"
        else if (error == 3) msg = "Could not login to network server"
        else if (error == 5) msg = "No sync service selected"
        messageDialog.openWithMsg("Sync error", msg)
        return true  // error message was displayed, close dialog
    }

    Connections {
        target: syncManager

        onStatusMessageChanged: {
            if (syncDialog.visible) statusLabel.text = syncManager.statusMessage
        }
        onWallet_downloaded: {
            if (syncDialog.visible) {
                var need_to_close = messageError(error)
                if (need_to_close) syncDialog.close()
            }
        }
        onWallet_uploaded: {
            if (syncDialog.visible) {
                messageError(error)
                syncDialog.close()
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
                syncManager.abort()
                syncDialog.close()
            }
        }
    }
}
