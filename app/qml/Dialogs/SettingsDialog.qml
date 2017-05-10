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
                    text: "Backup"
                    font.weight: Font.Bold
                }
                Button {
                    id: backupButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    Layout.leftMargin: 8
                    text: qsTr("Create encrypted backup file")
                    font.pointSize: 8
                    onClicked: backupFileDialog.open()
                }
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: backupButton.width
                    Layout.leftMargin: 8
                    Layout.topMargin: -8
                    text: qsTr("Export to csv")
                    font.pointSize: 8
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
                          width: 156
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
                          width: 156
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
                          width: 156
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
            }
        }

        Page {
            Label {
                text: qsTr("Sync settings")
                anchors.centerIn: parent
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
