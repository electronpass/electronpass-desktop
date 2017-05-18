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
import "../Components"

Dialog {
    title: qsTr("Settings")

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    modal: true

    width: Math.min(parent.width * 0.9, 700)
    height: Math.min(parent.height * 0.9, 500)

    function setSyncServiceIndex() {
        var service = setup.get_sync_service();

        if (service == "gdrive") syncDropdownMenu.currentIndex = 1;
        else if (service == "dropbox") syncDropdownMenu.currentIndex = 2;
        else syncDropdownMenu.currentIndex = 0;
    }
    function getSyncServiceFromIndex() {
        if (syncDropdownMenu.currentIndex == 0) return "none";
        if (syncDropdownMenu.currentIndex == 1) return "gdrive";
        if (syncDropdownMenu.currentIndex == 2) return "dropbox";
        return "none";
    }

    header: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("General")
        }
        TabButton {
            text: qsTr("Security")
        }
        TabButton {
            text: qsTr("Sync")
        }
        TabButton {
            text: qsTr("Shortcuts")
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        clip: true
        currentIndex: tabBar.currentIndex

        Page {
            ColumnLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                Label {
                    text: "Backup and Restore"
                    font.weight: Font.Bold
                }
                Label {
                    text: "After restore you need to lock and unlock your wallet manually"
                }
                RowLayout{
                    anchors.left: parent.left
                    anchors.right: parent.right
                    Button {
                        anchors.right: parent.horizontalCenter
                        text: qsTr("Export to backup file")
                        font.pointSize: 10
                        flat: true
                        highlighted: true
                        onClicked: {
                            setFileDialog(0);
                            fileDialog.open();
                        }
                    }
                    Button {
                        anchors.left: parent.horizontalCenter
                        text: qsTr("Import from backup file")
                        font.pointSize: 10
                        flat: true
                        highlighted: true
                        onClicked: {
                            setFileDialog(2)
                            fileDialog.open()
                        }
                    }
                }

                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Layout.leftMargin: 8
                    Layout.topMargin: -8
                    text: qsTr("Export to csv")
                    font.pointSize: 8
                    flat: true

                    highlighted: true
                    onClicked: {
                        setFileDialog(1);
                        fileDialog.open();
                    }
                }

                Label {
                    text: "Interface"
                    font.weight: Font.Bold
                    Layout.topMargin: 8
                }
                Switch {
                    Layout.leftMargin: 8
                    id: themeSwitch
                    text: qsTr("Dark theme (restart application to apply)")
                    checked: settings.theme
                }
            }
        }

        Page {
            ColumnLayout {
                Label {
                    text: "Change master password"
                    font.weight: Font.Bold
                }
                ColumnLayout {
                    Layout.leftMargin: 8
                    RowLayout {
                        Item {
                          width: 170
                          Label {
                            text: qsTr("Current master password:")
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                          }
                        }
                        TextField {
                            id: curr_password
                            Layout.leftMargin: 8
                            font.pointSize: 10
                            echoMode: TextInput.Password
                            font.family: robotoMonoFont.name
                        }
                    }

                    RowLayout {
                      Layout.topMargin: -8
                        Item {
                          width: 170
                          Label {
                            text: qsTr("New master password:")
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                          }
                        }
                        TextField {
                            id: new_password
                            Layout.leftMargin: 8
                            font.pointSize: 10
                            echoMode: TextInput.Password
                            font.family: robotoMonoFont.name
                            width: curr_password.width

                            background: PassStrengthIndicator {
                                height: new_password.height-22
                                password: new_password.text
                                type: "password"
                                anchors.centerIn: parent
                                width: parent.width
                            }
                        }
                    }

                    RowLayout {
                      Layout.topMargin: -8
                        Item {
                          width: 170
                          Label {
                            text: qsTr("Confirm password:")
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                          }
                        }
                        TextField {
                            id: confirm_password
                            Layout.leftMargin: 8
                            font.pointSize: 10
                            echoMode: TextInput.Password
                            font.family: robotoMonoFont.name
                            width: curr_password.width

                            background: ConfirmPassIndicator {
                                height: confirm_password.height-22
                                valid: (confirm_password.text == new_password.text)
                                anchors.centerIn: parent
                                width: parent.width
                            }
                        }
                    }

                    Button {
                        text: qsTr("Change password")
                        Layout.topMargin: -8
                        enabled: !(curr_password.text == "" || new_password.text == "") && (confirm_password.text == new_password.text)
                        onClicked: {
                            if (dataHolder.change_password(curr_password.text, new_password.text)) {
                                toolTip.text = "Password changed successfully."
                                curr_password.text = ""
                                new_password.text = ""
                                confirm_password.text = ""
                            } else {
                                toolTip.text = "Incorrect master password."
                                curr_password.forceActiveFocus();
                                curr_password.selectAll();
                            }
                            toolTip.show()
                        }
                    }

                }

                Label {
                    text: "Lock app after idle for:"
                    font.weight: Font.Bold
                }
                ComboBox {
                    id: autoLockSettings
                    property int lockDelay: settings.lockDelay
                    width: 200
                    Layout.leftMargin: 15
                    model: ["30 seconds", "1 minute", "2 minutes", "5 minutes", "10 minutes", "never"]

                    Component.onCompleted: {
                        switch (lockDelay) {
                            case 30:
                                currentIndex = 0;
                                break;
                            case 60:
                                currentIndex = 1;
                                break;
                            case 120:
                                currentIndex = 2;
                                break;
                            case 300:
                                currentIndex = 3;
                                break;
                            case 600:
                                currentIndex = 4;
                                break;
                            default:
                                currentIndex = 5;
                                break;
                        }
                    }
                    onActivated: {
                        switch (currentIndex) {
                            case 0:
                                lockDelay = 30;
                                break;
                            case 1:
                                lockDelay = 60;
                                break;
                            case 2:
                                lockDelay = 120;
                                break;
                            case 3:
                                lockDelay = 300;
                                break;
                            case 4:
                                lockDelay = 600;
                                break;
                            case 5:
                            default:
                                lockDelay = -1;
                                break;
                        }
                        settings.lockDelay = lockDelay;
                    }
                }

            }
        }

        Page {
            ColumnLayout {
                anchors.left: parent.left
                anchors.right: parent.right

                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Label {
                        text: "Select sync service:"
                        font.weight: Font.Bold
                    }

                    ComboBox {
                        id: syncDropdownMenu

                        width: 200
                        Layout.leftMargin: 15
                        model: ["No sync service", "Google Drive", "Dropbox"]

                        Component.onCompleted: {
                            settingsDialog.setSyncServiceIndex();
                        }
                        onActivated: {
                            if (settingsDialog.getSyncServiceFromIndex() == "none") {
                                settingsChangeSyncDialog.changeMessage("Your wallet will not be synced to cloud services anymore.\n" +
                                                                    "Are you sure that to unset your sync provider?\n" +
                                                                    "Your data on current sync service will not be changed.")
                            } else {
                                settingsChangeSyncDialog.changeMessage("Are you sure that you want to change your sync service\n" +
                                            "provider? Your data on current sync service will not\nbe changed.")
                            }
                            settingsChangeSyncDialog.open();
                        }
                    }
                }
            }
        }
        Page {
          ListModel {
            id: shortcutsModel

            ListElement {
              text: qsTr("\u2191 and \u2193")
              desc: "Move through items"
            }
            ListElement {
              text: qsTr("Ctrl+L")
              desc: "Lock wallet"
            }
            ListElement {
              text: qsTr("Ctrl+E")
              desc: "Edit currently selected item"
            }
            ListElement {
              text: qsTr("Ctrl+S")
              desc: "Sync now"
            }
            ListElement {
              text:qsTr("Ctrl+F")
              desc: "Search"
            }
            ListElement {
              text: qsTr("Ctrl+D")
              desc: "Copy the first password from the selected item"
            }
            ListElement {
              text: qsTr("Ctrl+W")
              desc: "Close application"
            }
          }
          ListView {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            spacing: 32
            topMargin: 8
            bottomMargin: 22
            interactive: (contentHeight + 8 > height)

            model: shortcutsModel

            delegate: ShortcutItem {
              shortcut: text
              description: desc
            }
          }
        }
    }

    // Exact copy from Lock.qml
    ToolTip {
        id: toolTip
        text: "Unknown error."
        timeout: 2000
        visible: false
        y: parent.height - 32

        function show() {
            timer.restart();
            visible = true;
        }
        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }
        Timer {
            id: timer
            interval: toolTip.timeout
            onTriggered: {
                if (!running) { toolTip.visible = false; }
            }
        }
    }

    function setFileDialog(exportType) {
        fileDialog.selectMultiple = false;
        fileDialog.selectExisting = false;
        if (exportType == 0) {
            fileDialog.exportType = 0;
            fileDialog.title = "Please choose a backup location.";
        } else if (exportType == 1) {
            fileDialog.exportType = 1;
            fileDialog.title = "Please choose a csv export location.";
        } else if (exportType == 2) {
            fileDialog.exportType = 2
            fileDialog.title = "Please choose a backup file."
            fileDialog.selectExisting = true
        }
    }

    FileDialog {
        id: fileDialog
        title: "This title should be set from setFileDialog function."
        folder: shortcuts.home
        selectMultiple: false
        selectExisting: false
        property int exportType: 0
        // Backup types:
        //  0 - create a backup file
        //  1 - export to csv
        //  2 - import from backup file
        onAccepted: {
            var url = Qt.resolvedUrl(fileDialog.fileUrl);
            if (exportType == 0) {
                var success = dataHolder.backup_wallet(url);
                if (success) {
                    toolTip.text = "Backup file created successfully."
                } else {
                    toolTip.text = "Backup failed"
                }
            } else if (exportType == 1) {
                var success = dataHolder.export_to_csv(url);
                if (success) {
                    toolTip.text = "Exported to csv successfully."
                } else {
                    toolTip.text = "Export to csv failed"
                }
            } else if (exportType == 2) {
                var success = setup.restore_data_from_file(url)
                if (success) {
                    toolTip.text = "Import successful."
                    dataHolder.lock()
                    lockGUI()
                } else {
                    toolTip.text = "Import failed."
                }
            }
            toolTip.show()
        }
        onRejected: {}
    }


    Component.onDestruction: {
        settings.theme = themeSwitch.checked
    }

}
