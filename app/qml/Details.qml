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
    height: detailsList.contentHeight + detailsTitleLabel.height + 32
    anchors.horizontalCenter: parent.horizontalCenter
    Material.elevation: 1
    Material.background: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade800) : "white"
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
            if (!running) {
                details.destroyDetails()
            }
        }
    }

    property bool opened: false

    function setTitle(title) {
        detailsTitleLabel.text = title;
    }

    function addDetail(obj){
        detailsModel.append({titlevar: obj.title, contentvar: obj.content, securevar: obj.secure, typevar: obj.type})
    }

    function destroyDetails(){
        detailsTitleLabel.text = "";
        detailsModel.clear();
    }

    function destroyDetailsWithDelay(delay){
        timer.interval = delay;
        timer.restart();
    }

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        id: rootColumnLayout
        height: parent.height - 32
        width: parent.width

        RowLayout {
            Layout.fillWidth: true
            Layout.bottomMargin: 16
            Label {
                id: detailsTitleLabel
                font.pixelSize: 20
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
            ToolButton {
                font.family: materialIconsFont.name
                font.pixelSize: 18
                text: qsTr("\uE150")
                onClicked: {
                  editItemDialog.open();
                  editItemDialog.setTitle(detailsTitleLabel.text);
                  for (var i = 0; i < detailsModel.count; i++){
                    editItemDialog.addEditDetail(detailsModel.get(i));
                  }
                }
            }
            ToolButton {
                font.family: materialIconsFont.name
                font.pixelSize: 18
                text: qsTr("\uE872")
                onClicked: deleteConfirmationDialog.open()
            }
        }

        //model to hold details
        ListModel {
          id: detailsModel
        }

        ListView {
            anchors.left: parent.left
            anchors.right: parent.right
            Layout.fillHeight: true
            Layout.topMargin: -22
            interactive: false
            spacing: -12
            id: detailsList
            model: detailsModel

            add: Transition {
                NumberAnimation { properties: "opacity"; from: 0.0; to: 1.0; duration: 200; easing.type: Easing.InOutCubic }
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
}
