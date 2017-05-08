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

    width: Math.min(parent.width * 0.8, 600)
    height: Math.min(parent.height * 0.8, 400)

    header: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Interface")
        }
        TabButton {
            text: qsTr("Security")
        }
        TabButton {
            text: qsTr("Sync")
        }
        TabButton {
            text: qsTr("Backup")
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
            Switch {
                id: themeSwitch
                text: qsTr("Dark theme (restart application to apply)")
                checked: settings.theme
            }
        }

        Page {

            GridLayout {
                anchors.fill: parent

                Label {
                    text: qsTr("Change master password")
                    font.bold: true
                    Layout.row: 0
                    Layout.column: 0
                }
                Label {
                    text: qsTr("Current master password:")
                    Layout.row: 1
                    Layout.column: 0
                }
                TextField {
                    id: curr_password
                    Layout.row: 1
                    Layout.column: 1
                    placeholderText: qsTr(" Enter password. ")
                    echoMode: TextInput.Password
                }
                Label {
                    text: qsTr("New master password:")
                    Layout.row: 2
                    Layout.column: 0
                }
                TextField {
                    id: new_password
                    Layout.row: 2
                    Layout.column: 1
                    placeholderText: qsTr("  New password.  ")
                    echoMode: TextInput.Password

                    background: PassStrengthIndicator {
                        height: new_password.height - 16
                        password: new_password.text
                        type: "password"
                        anchors.centerIn: parent
                        width: parent.width
                    }

                }
                Label {
                    text: qsTr("Confirm master password:")
                    Layout.row: 3
                    Layout.column: 0
                }
                TextField {
                    id: confirm_password
                    Layout.row: 3
                    Layout.column: 1
                    placeholderText: qsTr("Confirm password.")
                    echoMode: TextInput.Password

                    background: ConfirmPassIndicator {
                        height: confirm_password.height-16
                        valid: (confirm_password.text == new_password.text)
                        anchors.centerIn: parent
                        width: parent.width
                    }
                }
                Button {
                    text: qsTr("Change password")
                    Layout.row: 4
                    Layout.column: 1
                    enabled: {
                        var empty = curr_password.text == "" || new_password.text == ""
                        var match = confirm_password.text == new_password.text
                        return !empty && match
                    }
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
        }

        Page {
            Label {
                text: qsTr("Sync settings")
                anchors.centerIn: parent
            }
        }

        Page {
            ColumnLayout {
                Label {
                    text: qsTr("Backup all your passwords to encrypted file")
                }
                Button {
                    text: qsTr("Backup")
                    onClicked: {
                        console.log("Open file dialog mabye?")
                        backupFileDialog.open()
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

    FileDialog {
        id: backupFileDialog
        title: "Please choose a backup location."
        folder: shortcuts.home
        selectMultiple: false
        selectExisting: false
        onAccepted: {
            var success = dataHolder.backup_wallet(Qt.resolvedUrl(backupFileDialog.fileUrl));
            if (success) {
                toolTip.text = "Backup file created successfully."
            } else {
                toolTip.text = "Backup failed"
            }
            toolTip.show()
        }
        onRejected: {}
    }


    Component.onDestruction: {
        settings.theme = themeSwitch.checked
    }

}
