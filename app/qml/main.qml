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
import QtQuick.Layouts 1.0
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.1

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("ElectronPass")
    id: window

    // load icon font
    FontLoader { id: materialIconsFont; source: "qrc:/res/fonts/MaterialIcons-Regular.ttf"}

    Material.theme: (settings.theme == 1) ? Material.Dark : Material.Light
    Material.accent: Material.Cyan
    Material.primary: (settings.theme == 1) ? Material.color(Material.Blue, Material.Shade900) : Material.color(Material.Blue, Material.Shade800)


    header: ToolBar {
            id: toolbar
            visible: false
            Material.theme: Material.Dark

            RowLayout {
                anchors.fill: parent
                Label {
                    text: "ElectronPass"
                    elide: Label.ElideRight
                    leftPadding: 16
                    horizontalAlignment: Qt.AlignHLeft
                    verticalAlignment: Qt.AlignVCenter
                    Layout.fillWidth: true
                }
                TextField {
                    id: searchInput
                    font.pixelSize: 14
                    placeholderText: qsTr(" Search")
                }
                ToolButton {
                    id: newButton
                    font.family: materialIconsFont.name
                    font.pixelSize: 22
                    text: qsTr("\uE145")
                }
                ToolButton {
                    id: menuButton
                    font.family: materialIconsFont.name
                    font.pixelSize: 22
                    text: qsTr("\uE5D4")
                    onClicked: menu.open()

                    //TODO: menu is probably too big, scale won't work and is a bad sollution anyway
                    Menu {
                        id: menu
                        y: parent.height
                        MenuItem {
                            text: "Lock"
                            onTriggered: {
                                lock.visible = true;
                                toolbar.visible = false;
                                lock.setFocus();
                            }
                        }
                        MenuItem {
                            text: "Sync now"
                        }
                        MenuItem {
                            text: "Settings"
                            onTriggered: settingsDialog.open();
                        }
                    }
                }
            }
        }

    // basic devider
    RowLayout {
        id: main_layout
        anchors.fill: parent
        spacing: 0
        ItemsList {
            Layout.fillWidth: true
            Layout.minimumWidth: 220
            Layout.preferredWidth: 250
            Layout.maximumWidth: 250
        }

        Rectangle {
            id: viewDivider
            color: Material.color(Material.Grey, Material.Shade400)
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 8
            anchors.bottomMargin: 8
            width: 1
            x: 100
        }

        ItemDetails {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            Layout.preferredWidth: 390
        }
    }

    Lock { id: lock}

    Settings {
        id: settings
        // 1 for dark theme, anything else for light
        property int theme: 0
    }

    SettingsDialog {
            id: settingsDialog
    }

    DeleteConfirmationDialog{
        id: deleteConfirmationDialog
    }
}
