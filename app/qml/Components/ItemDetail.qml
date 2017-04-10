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
    id: itemDetail
    property bool secure: false
    property bool url: false
    property color contentColor: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade400) : Material.color(Material.Grey, Material.Shade700)
    property string title
    property string content
    property string titlePostfix: ": "
    property string secureMask: "\u2022\u2022\u2022\u2022\u2022\u2022\u2022"
    property bool secureTextVisible: false
    property color greyTextColor: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade300) : Material.color(Material.Grey, Material.Shade800)

    function toggleVisibility() {
        if (itemDetail.secure && itemDetail.secureTextVisible) {
            itemDetailContent.text = itemDetail.secureMask;
            itemDetailContent.font.pixelSize = 18;
            itemDetail.secureTextVisible = false;
        } else if (itemDetail.secure) {
            itemDetailContent.text = itemDetail.content;
            itemDetailContent.font.pixelSize = 14;
            itemDetail.secureTextVisible = true;
        }
    }

    // called when ItemDetail is created, won't work after toggleVisibility is called
    function getDisplayableContent(){
        if(itemDetail.secure) return itemDetail.secureMask;
        if(itemDetail.url) return "<a href='" + itemDetail.content + "'>" + itemDetail.content + "</a>";
        return itemDetail.content;
    }

    Layout.topMargin: -24
    Item {
        width: 108
        Label {
            id: titleLabel
            text: itemDetail.title + itemDetail.titlePostfix
            font.pixelSize: 14
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            wrapMode: Text.WrapAnywhere
            horizontalAlignment: Text.AlignRight
        }
    }
    Label {
        id: itemDetailContent
        Layout.fillWidth: true
        text: getDisplayableContent()
        textFormat: itemDetail.url ? Text.StyledText : Text.PlainText
        font.pixelSize: itemDetail.secure ? 18 : 14
        font.family: itemDetail.secure ? robotoMonoFont.name : font.family
        color: greyTextColor
        onLinkActivated: {
            Qt.openUrlExternally(link)
        }

        background: PassStrengthIndicator {
            visible: itemDetail.secure
            height: 22
            password: itemDetail.content
            anchors.centerIn: parent
        }
    }
    ToolButton {
        font.pixelSize: 14
        text: qsTr("\uE417")
        visible: itemDetail.secure
        font.family: materialIconsFont.name
        Material.foreground: itemDetail.contentColor
        onClicked: toggleVisibility()
    }
    ToolButton {
        font.pixelSize: 14
        text: qsTr("\uE14D")
        font.family: materialIconsFont.name
        Material.foreground: itemDetail.contentColor
        onClicked: snackbar.open(itemDetail.title + " copied to clipboard.")
    }
}