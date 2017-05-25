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

Pane {
    property string syncIcon: "cloud"
    property string doneIcon: "cloud_done"
    property string errorIcon: "cloud_off"

    background: Rectangle { opacity: 0 }

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    width: height

    function sync() {
        syncAnimate()
        syncManager.download_wallet()
    }
    function syncAnimate() {
        statusIcon.text = syncIcon
        syncAnimationTimer.start()
    }
    function syncUpload() {
        refreshUI()
        syncManager.upload_wallet()
    }
    function getErrorText(error) {
        var msg
        switch (error) {
            case 1:
                msg = "Syncing already in progress"
                break
            case 2:
                msg = "Connection error, network server is unreachable"
                break
            case 3:
                msg = "Could not login to network server"
                break
            case 4:
                msg = "Sync aborted"
                break
            case 5:
                msg = "No sync service selected"
                break
            case 6:
            default:
                msg = "Unknown error"
                break
        }
        return msg
    }

    Connections {
        target: syncManager

        onStatusMessageChanged: {
            syncDetailsDialog.setText(syncManager.statusMessage)
        }
        onWallet_downloaded: {
            if (error == 0) {
                if (walletMerger.need_decrypt_online_wallet()) {
                    syncOnlinePasswordDialog.open()
                } else {
                    if (walletMerger.is_corrupted()) {
                        messageDialog.openWithMsg("Online wallet appears to be corrupted",
                                              "It will be overwridden with current offline wallet.")
                    }
                    syncUpload()
                }
            } else {
                statusIcon.text = errorIcon
                syncAnimationTimer.stop()
                syncDetailsDialog.setText(getErrorText(error))
            }
        }
        onWallet_uploaded: {
            syncAnimationTimer.stop()
            if (error == 0) {
                statusIcon.text = doneIcon
                syncDetailsDialog.setText("All edits synced to server")
            } else {
                statusIcon.text = errorIcon
                syncDetailsDialog.setText(getErrorText(error))
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            syncDetailsDialog.x = mouseX
            syncDetailsDialog.y = mouseY
            syncDetailsDialog.visible = true
        }
        onExited: {
            syncDetailsDialog.visible = false
        }
    }

    Timer {
        id: syncAnimationTimer
        interval: 1200
        repeat: true
        triggeredOnStart: true
        onTriggered: statusIcon.blink()
    }

    Text {
        id: statusIcon
        font.family: materialIconsFont.name
        text: errorIcon
        font.pointSize: 18
        color: Material.color(Material.Grey, Material.Shade100)

        function blink() {
            animation.running = true
        }
        SequentialAnimation {
            id: animation
            PropertyAnimation { target: statusIcon; property: "opacity"; to: 0.1;
                                duration: 500; easing.type: Easing.InOutQuad }
            PropertyAnimation { target: statusIcon; property: "opacity"; to: 1;
                                duration: 500; easing.type: Easing.InOutQuad }
        }
    }

    Dialog {
        id: syncDetailsDialog
        modal: false
        visible: false
        function setText(text) {
            textLabel.text = text
        }
        Label {
            id: textLabel
            text: ""
        }
    }
}
