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
import "Components"

Pane {
    width: Math.min(420, parent.width)
    padding: 0
    leftPadding: 8
    bottomPadding: 8
    height: detailsList.height + 16
    anchors.horizontalCenter: parent.horizontalCenter
    Material.elevation: 1
    Material.background: (Material.theme == Material.Dark) ?
                         Material.color(Material.Grey, Material.Shade800) : "white"
    opacity: opened ? 1 : 0
    property string title
    Behavior on opacity {
        NumberAnimation { duration: detailsPane.opacityAnimationDuration }
    }

    //timer for destruction
    Timer {
        id: timer
        interval: 0
        onTriggered: {
            if (!running) details.destroyDetails()
        }
    }

    property bool opened: false
    property string currentTitle: ""

    function setTitle(title) {
        currentTitle = title
    }

    function addDetail(obj){
        detailsModel.append({titlevar: obj.title, contentvar: obj.content,
                            securevar: obj.secure, typevar: obj.type})
    }

    function destroyDetails(){
        currentTitle = ""
        detailsModel.clear()
    }

    function destroyDetailsWithDelay(delay){
        timer.interval = delay
        timer.restart()
    }

    function openEditDialog(){
        editItemDialog.open()
        editItemDialog.index = itemsList.currentIndex
        editItemDialog.setTitle(currentTitle)
        for (var i = 0; i < detailsModel.count; i++) {
            editItemDialog.addEditDetail(detailsModel.get(i))
        }
    }

    ListModel {
        id: detailsModel
    }

    ListView {
        header: RowLayout {
            width: parent.width
            Layout.bottomMargin: 16
            // Ugly solution
            Rectangle { anchors.fill: parent }
            z: 2

            Label {
                text: currentTitle
                font.pixelSize: 20
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            ToolButton {
                font.family: materialIconsFont.name
                font.pixelSize: 18
                text: qsTr("\uE150")
                onClicked: details.openEditDialog()
            }
            ToolButton {
                font.family: materialIconsFont.name
                font.pixelSize: 18
                text: qsTr("\uE872")
                onClicked: deleteConfirmationDialog.open()
            }
        }
        anchors.left: parent.left
        anchors.right: parent.right
        headerPositioning: ListView.OverlayHeader
        height: Math.min(contentHeight, window.height - toolbar.height - 64)
        spacing: -12
        clip: true  // Clip is not optimal solution.

        id: detailsList
        model: detailsModel

        add: Transition {
            NumberAnimation { properties: "opacity"; from: 0.0; to: 1.0;
                              duration: 200; easing.type: Easing.InOutCubic }
        }
        displaced: Transition {
            NumberAnimation { properties: "y"; duration: 200; easing.type: Easing.InOutCubic }
        }

        delegate: ItemDetail {
            title: titlevar
            content: contentvar
            secure: securevar
            type: typevar
        }
    }
}
