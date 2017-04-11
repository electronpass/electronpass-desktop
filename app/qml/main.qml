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
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.1
import "Dialogs"

ApplicationWindow {
    visible: true
    width: 680
    height: 480
    title: qsTr("ElectronPass")
    id: window

    // load icon font
    FontLoader { id: materialIconsFont; source: "qrc:/res/fonts/MaterialIcons-Regular.ttf"}
    FontLoader { id: robotoMonoFont; source: "qrc:/res/fonts/RobotoMono-Regular.ttf"}

    Material.theme: (settings.theme == 1) ? Material.Dark : Material.Light
    Material.accent: Material.Cyan
    Material.primary: (Material.theme == Material.Dark) ? Material.color(Material.Blue, Material.Shade900) : Material.color(Material.Blue, Material.Shade800)
    Material.background: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade900) : Material.color(Material.Grey, Material.Shade100)

    // define shortcuts
    Shortcut {
        sequence: "Ctrl+F"
        onActivated: {
            if(!lock.visible){
                searchInput.forceActiveFocus();
                searchInput.selectAll();
            }
        }
    }
    Shortcut {
        sequence: "Ctrl+W"
        onActivated: {
            //TODO: save work and lock before exiting
            dataHolder.lock()
            Qt.quit()
        }
    }
    Shortcut {
        sequence: "Ctrl+D"
        onActivated: {
            if (!lock.visible && itemsList.currentIndex >= 0){
                //TODO: tell cpp part to copy password
                onClicked: snackbar.open("Password copied to clipboard.")
            }
        }
    }
    Shortcut {
        sequence: "Ctrl+S"
        onActivated: {
            if(!lock.visible) settingsDialog.open()
        }
    }
    Shortcut {
        sequence: "Ctrl+L"
        onActivated: {
            if(!lock.visible) {
                dataHolder.lock()
                lockGUI()
            }
        }
    }
    function handleKeys(event) {
        if (event.key == Qt.Key_Down) {
            itemsList.nextItem()
            event.accepted = true
        } else if (event.key == Qt.Key_Up) {
            itemsList.previousItem()
            event.accepted = true
        }
    }

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
                    Keys.onPressed: handleKeys(event)
                    onTextChanged: {
                        if (text != "") itemsList.setItemInxed(0);
                        else itemsList.setItemInxed(-1);
                    }
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
                                dataHolder.lock()
                                lockGUI()
                            }
                        }
                        MenuItem {
                            text: "Sync now"
                            onTriggered: {
                                gdrive.get_wallet();
                            }
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
        id: mainLayout
        anchors.fill: parent
        spacing: 0

        function onItemSelected(index) {
            if (index < 0) {
                detailsPane.hideDetails();
            }else {
                detailsPane.showDetails(index);
            }
        }

        ItemsList {
            id: itemsList
            Layout.fillWidth: true
            Layout.minimumWidth: 220
            Layout.preferredWidth: 250
            Layout.maximumWidth: 250
        }

        Pane {
            id: detailsPane
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 220
            Layout.preferredWidth: 280
            Layout.topMargin: 16
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            Layout.bottomMargin: 16
            Keys.onPressed: handleKeys(event)

            property int opacityAnimationDuration: 100

            Details {
                id: details
            }

            function showDetails(index){
                noItemSelectedLabel.opened = false;
                details.destroyDetails();
                details.opened = true;
                details.setTitle("Github " + index);
                details.addDetail({title: "Username", content: "zigapk", secure: false, url: false});
                details.addDetail({title: "Url", content: "https://github.com/login", secure: false, url: true});
                details.addDetail({title: "Password", content: passwordManager.generateRandomPass(Math.floor((Math.random() * (25 - 5)) + 5)), secure: true, url: false});
            }

            function hideDetails(){
                details.opened = false;
                noItemSelectedLabel.opened = true;
                // details get destroyed when animation is finished (otherwise it looks wierd)
                details.destroyDetailsWithDelay(detailsPane.opacityAnimationDuration);
            }

            Label {
                id: noItemSelectedLabel
                property bool opened: true
                text: "No item selected."
                anchors.centerIn: parent
                opacity: opened ? 1 : 0
                Behavior on opacity {
                    NumberAnimation { duration: detailsPane.opacityAnimationDuration }
                }
            }
        }
    }

    Lock {
        id: lock
    }

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

    Snackbar{
        id: snackbar
        fullWidth: true
    }

    function lockGUI(){
        details.destroyDetails()
        itemsList.setItemIndex(-1)
        itemsList.model = 0
        lock.visible = true
        toolbar.visible = false
        lock.setFocus()
    }

    function unlockGUI(){
        lock.visible = false
        toolbar.visible = true
        searchInput.forceActiveFocus()
        searchInput.selectAll()
        itemsList.model = dataHolder.get_number_of_items()
    }
}
