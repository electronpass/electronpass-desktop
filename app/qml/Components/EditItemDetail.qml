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

RowLayout {
    id: editItemDetail
    property bool secure: false
    property bool url: false
    property color contentColor: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade400) : Material.color(Material.Grey, Material.Shade700)
    property string title
    property string content
    property string titlePostfix: ": "
    property color greyTextColor: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade300) : Material.color(Material.Grey, Material.Shade800)

    Layout.topMargin: -18
    anchors.right: parent.right
    anchors.left: parent.left

    Item {
        width: 108
        TextField {
            id: titleLabel
            text: editItemDetail.title
            font.pixelSize: 14
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignRight
            background.opacity: bcgOpacity
            placeholderText: "Title"

            property real bcgOpacity: activeFocus ? 1 : 0

            Behavior on bcgOpacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutCubic
                }
            }

            onTextChanged: {
                editItemDetail.title = text;
            }
        }
    }
    Label {
        font.pixelSize: 14
        text: editItemDetail.titlePostfix
    }
    TextField {
        id: editItemDetailContent
        Layout.fillWidth: true
        text: content
        font.pixelSize: 14
        color: greyTextColor
        property string content: editItemDetail.content
        background.opacity: bcgOpacity
        placeholderText: "Content"

        property real bcgOpacity: (activeFocus || editItemDetail.secure) ? 1 : 0

        Behavior on bcgOpacity {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutCubic
            }
        }

        onTextChanged: {
            editItemDetail.content = text;
        }

        Component.onCompleted: {
            if (editItemDetail.secure) {
              font.family = robotoMonoFont.name;

              var component = Qt.createComponent("PassStrengthIndicator.qml");
              background = component.createObject(null, {"visible": editItemDetail.secure, "height": editItemDetailContent.height-8});
            }
        }
    }
    ToolButton {
        font.pixelSize: 14
        visible: editItemDetail.secure
        text: qsTr("\uE899")
        font.family: materialIconsFont.name
        Material.foreground: editItemDetail.contentColor
    }
    ToolButton {
        font.pixelSize: 14
        text: qsTr("\uE872")
        font.family: materialIconsFont.name
        Material.foreground: editItemDetail.contentColor
        onClicked: editDetailsModel.remove(model.index)
    }
}
