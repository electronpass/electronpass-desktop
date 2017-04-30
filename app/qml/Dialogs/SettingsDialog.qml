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
            Switch {
                id: themeSwitch
                text: qsTr("Dark theme (restart application to apply)")
                checked: settings.theme
            }
        }

        Page {
            Label {
                text: qsTr("Second page")
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


    Component.onDestruction: {
        settings.theme = themeSwitch.checked
    }

}
