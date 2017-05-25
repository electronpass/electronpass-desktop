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
import "Components"

ApplicationWindow {
    visible: true
    width: 680
    height: 480
    title: qsTr("ElectronPass")
    id: window

    // load icon font
    FontLoader { id: materialIconsFont; source: "qrc:/res/fonts/MaterialIcons-Regular.ttf" }
    FontLoader { id: robotoMonoFont; source: "qrc:/res/fonts/RobotoMono-Regular.ttf" }

    Material.theme: (settings.theme == 1) ? Material.Dark : Material.Light
    Material.accent: Material.Cyan
    Material.primary: (Material.theme == Material.Dark) ?
                            Material.color(Material.Blue, Material.Shade900) :
                            Material.color(Material.Blue, Material.Shade800)
    Material.background: (Material.theme == Material.Dark) ?
                            Material.color(Material.Grey, Material.Shade900) :
                            Material.color(Material.Grey, Material.Shade100)

    Component.onDestruction: {
        dataHolder.lock()
        lockGUI()
    }

    Timer {
        id: lockTimer
        interval: settings.lockDelay != -1 ? settings.lockDelay * 1000 : 0
        onTriggered: {
            if (interval != 0) {
                console.log("Locked after", interval / 1000, " seconds.")
                dataHolder.lock()
                lockGUI()
            }
        }
    }
    // define shortcuts
    Shortcut {
        sequence: "Ctrl+F"
        onActivated: {
            if(!lock.visible){
                searchInput.forceActiveFocus()
                searchInput.selectAll()
            }
        }
    }
    Shortcut {
        sequence: "Ctrl+W"
        onActivated: {
            dataHolder.lock()
            lockGUI()
            Qt.quit()
        }
    }
    Shortcut {
        sequence: "Ctrl+D"
        onActivated: {
            if (!lock.visible && itemsList.currentIndex >= 0) {
                var copied = false
                var item = itemsList.currentIndex
                var size = dataHolder.get_number_of_item_fields(item)
                for (var i = 0; i < size; ++i) {
                    var field = dataHolder.get_item_field(item, i)
                    if (field["sensitive"] == "true") {
                        copied = true
                        clipboard.set_text(field["value"])
                        break
                    }
                }
                if (copied) snackbar.open("Password copied to clipboard.")
                else snackbar.open("Could not copy password.")
            }
        }
    }
    Shortcut {
        sequence: "Ctrl+S"
        onActivated: if(!lock.visible) {
            syncDialog.open()
            syncDialog.sync()
        }
    }
    Shortcut {
        sequence: "Ctrl+L"
        onActivated: {
            if(!lock.visible && !setupView.visible) {
                dataHolder.lock()
                lockGUI()
            }
        }
    }
    Shortcut {
        sequence: "Ctrl+E"
        onActivated: {
            if(!lock.visible && details.opened) details.openEditDialog()
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

            SyncIndicator {
                id: syncIndicator
            }
            Label {
                text: "ElectronPass"
                leftPadding: 24
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHLeft
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            TextField {
                id: searchInput
                inputMethodHints: Qt.ImhSensitiveData
                selectByMouse: true
                font.pixelSize: 14
                placeholderText: qsTr(" Search")
                Keys.onPressed: handleKeys(event)
                onTextChanged: {
                    if (text != "") {
                        // returns -1 if nothing found
                        var search_results = dataHolder.search(text)
                        // first change model, then update index
                        itemsList.model = dataHolder.get_number_of_items()
                        itemsList.setItemIndex(search_results)
                    } else {
                        dataHolder.stop_search()
                        refreshUI()
                        itemsList.setItemIndex(-1)
                    }
                }
            }
            ToolButton {
                id: newButton
                font.family: materialIconsFont.name
                font.pixelSize: 22
                text: qsTr("\uE145")
                onClicked: newItemMenu.open()

                Menu {
                    id: newItemMenu
                    y: parent.height
                    x: - width + parent.width

                    function addItem(template) {
                        var newItemIndex = dataHolder.add_item(template)
                        itemsList.model = dataHolder.get_number_of_items()
                        itemsList.setItemIndex(newItemIndex)
                        details.openEditDialog()
                    }

                    MenuItem {
                        text: "Login"
                        onClicked: newItemMenu.addItem("login")
                    }
                    MenuItem {
                        text: "Credit card"
                        onClicked: newItemMenu.addItem("credit_card")
                    }
                    MenuItem {
                        text: "Custom"
                        onClicked: newItemMenu.addItem("")
                    }
                }
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
                            syncDialog.open()
                            syncDialog.sync()
                        }
                    }
                    MenuItem {
                        text: "Settings"
                        onTriggered: settingsDialog.open()
                    }
                }
            }
        }
    }

    // basic divider
    RowLayout {
        id: mainLayout
        anchors.fill: parent
        spacing: 0

        function handleDetails(index) {
            if (index < 0) detailsPane.hideDetails()
            else detailsPane.showDetails(index)
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
                noItemSelectedLabel.opened = false
                details.destroyDetails()
                details.opened = true
                details.setTitle(dataHolder.get_item_name(index))
                for (var i = 0; i < dataHolder.get_number_of_item_fields(index); ++i) {
                    var field = dataHolder.get_item_field(index, i)

                    details.addDetail({ title: field["name"],
                                        content: field["value"],
                                        secure: field["sensitive"] != "false",
                                        type: field["type"]
                                    })
                }
            }

            function hideDetails(){
                details.opened = false
                noItemSelectedLabel.opened = true
                // details get destroyed when animation is finished (otherwise it looks wierd)
                details.destroyDetailsWithDelay(detailsPane.opacityAnimationDuration)
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
    Setup {
        id: setupView
    }

    Settings {
        id: settings
        property int theme: 0 // 1 for dark theme, anything else for light
        // number of seconds after lock, if -1 lock never
        property int lockDelay: -1

        // passwordGenerator needs to remember password length and settings
        property int defaultPassLength: 16
        property int numberOfDigitsInPassword: 3
        property int numberOfSymbolsInPassword: 5
        property int numberOfUppercaseLettersInPassword: 5
    }

    SettingsDialog {
        id: settingsDialog
    }
    MessageDialog {
        id: messageDialog
    }
    SyncDialog {
        id: syncDialog
    }
    SyncOnlinePasswordDialog {
        id: syncOnlinePasswordDialog
    }
    DeleteConfirmationDialog {
        id: deleteConfirmationDialog
    }
    SettingsChangeSyncDialog {
        id: settingsChangeSyncDialog
    }
    EditItemDialog {
        id: editItemDialog
    }
    SetupFromSyncServiceDialog {
        id: setupFromSyncServiceDialog
    }

    Snackbar {
        id: snackbar
        fullWidth: true
    }

    function refreshUI() {
        var index = itemsList.currentIndex
        itemsList.model = -1
        itemsList.model = dataHolder.get_number_of_items()
        if (index < dataHolder.get_number_of_items()) itemsList.setItemIndex(index)
        else itemsList.setItemIndex(-1)
    }

    function lockGUI() {
        messageDialog.close()
        settingsDialog.close()
        details.destroyDetails()
        itemsList.setItemIndex(-1)
        itemsList.model = 0
        lock.visible = true
        lock.wrongPassCounter = 0
        toolbar.visible = false
        lock.setFocus()
        clipboard.clear()
    }

    function unlockGUI() {
        lock.visible = false
        toolbar.visible = true
        searchInput.forceActiveFocus()
        searchInput.selectAll()
        itemsList.model = dataHolder.get_number_of_items()
        itemsList.setItemIndex(-1)
        lockTimer.start()
        syncIndicator.sync()
    }
}
