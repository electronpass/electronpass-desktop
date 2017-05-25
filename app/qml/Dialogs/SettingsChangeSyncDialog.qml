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
    id: settingsChangeSyncDialog
    modal: true

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    function openWithMsg(title, message) {
        settingsChangeSyncDialog.title = title
        messageLabel.text = message
        open()
    }

    onOpened: messageLabel.forceActiveFocus()

    onAccepted: {
        setup.set_sync_service(settingsDialog.getSyncServiceFromIndex())

        if (settingsDialog.getSyncServiceFromIndex() != "none") {
            syncDialog.open()
        }
        syncDialog.sync()
    }
    onRejected: {
        console.log("Changing sync provider canceled.")
        // set sync service to current sync service
        settingsDialog.setSyncServiceIndex()
    }

    ColumnLayout {
        Keys.onReturnPressed: messageDialog.accept()
        anchors.fill: parent
        visible: messageLabel.text != ""
        Label {
            id: messageLabel
            wrapMode: Text.WordWrap
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Message")
        }
    }

    standardButtons: Dialog.Ok | Dialog.Cancel
}
