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
    property color contentColor: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade400) : Material.color(Material.Grey, Material.Shade700)
    property string title
    property string type
    property string content
    property string titlePostfix: ": "
    property color greyTextColor: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade300) : Material.color(Material.Grey, Material.Shade800)

    RegExpValidator {
      id: digitsOnlyRegex
      regExp: /[0-9]+\.[0-9]+/
    }

    Layout.topMargin: -18
    anchors.right: parent.right
    anchors.left: parent.left

    Item {
        width: 108
        TextField {
            id: titleLabel
            text: editItemDetail.title
            selectByMouse: true
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
                editDetailsModel.setProperty(model.index, "titlevar", text);
            }
        }
    }
    Label {
        font.pixelSize: 14
        id: separator
        text: editItemDetail.titlePostfix
    }
    Item {
      id: editItemDetailContentHolder
      Layout.fillWidth: true
      EditItemDetailContentTextField {
        id: editItemDetailContent
      }
      anchors.top: parent.top
      anchors.topMargin: 4
    }
    ToolButton {
        font.pixelSize: 18
        Layout.rightMargin: -16
        visible: editItemDetail.secure
        text: qsTr("\uE8B9")
        font.family: materialIconsFont.name
        Material.foreground: editItemDetail.contentColor
        onClicked: {
          passGenerator.toFill = editItemDetailContent;
          passGenerator.numbersOnly = (editItemDetail.type == "pin");
          passGenerator.open();
        }
    }
    ToolButton {
        font.pixelSize: 14
        Layout.rightMargin: -16
        text: (editItemDetail.secure) ? qsTr("\uE897") : qsTr("\uE898")
        font.family: materialIconsFont.name
        Material.foreground: editItemDetail.contentColor
        onClicked: {
          editItemDetail.secure = !editItemDetail.secure;
          editDetailsModel.setProperty(model.index, "securevar", editItemDetail.secure);
          for(var i = editItemDetailContentHolder.children.length; i > 0 ; i--) {
              editItemDetailContentHolder.children[i-1].destroy()
          }
          var component = Qt.createComponent("EditItemDetailContentTextField.qml");
          component.createObject(editItemDetailContentHolder, {"id": "editItemDetailContent"});
        }
    }
    ToolButton {
        font.pixelSize: 14
        Layout.rightMargin: -16
        text: qsTr("\uE872")
        font.family: materialIconsFont.name
        Material.foreground: editItemDetail.contentColor
        onClicked: editDetailsModel.remove(model.index)
    }
}
