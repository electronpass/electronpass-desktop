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
    Material.elevation: 1
    Material.background: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade800) : "white"

    property color greyTextColor: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade400) : Material.color(Material.Grey, Material.Shade700)

    function setTitle(title) {
        detailsTitleLabel.text = title;
    }

    function addDetail(obj){
        var component = Qt.createComponent("Components/ItemDetail.qml");
        component.createObject(detailsContainer, {"title": obj.title, "content": obj.content, "secure": obj.secure, "url": obj.url});
    }

    function destroyDetails(){
        detailsTitleLabel.text = "";
        for(var i = detailsContainer.children.length; i > 0 ; i--) {
            detailsContainer.children[i-1].destroy()
        }
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        id: rootColumnLayout

        RowLayout {
            Layout.fillWidth: true
            Layout.bottomMargin: 16
            Label {
                id: detailsTitleLabel
                font.pixelSize: 20
                Layout.fillWidth: true
            }
            ToolButton {
                font.family: materialIconsFont.name
                font.pixelSize: 18
                text: qsTr("\uE150")
            }
            ToolButton {
                font.family: materialIconsFont.name
                font.pixelSize: 18
                text: qsTr("\uE872")
                onClicked: deleteConfirmationDialog.open()
            }
        }
        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            id: detailsContainer
        }
    }
}