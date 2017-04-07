import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

RowLayout {
    id: itemDetail
    property bool secure: false
    property color contentColor: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade400) : Material.color(Material.Grey, Material.Shade700)
    property string title
    property string content
    property string titlePostfix: ": "
    property string secureMask: "\u2022\u2022\u2022\u2022\u2022\u2022\u2022"
    property bool secureTextVisible: false

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

    Layout.topMargin: -24
    Item {
        width: 108
        Label {
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
        text: itemDetail.secure ? itemDetail.secureMask : itemDetail.content
        font.pixelSize: secure ? 18 : 14
    }
    ToolButton {
        font.pixelSize: 14
        text: qsTr("\uE417")
        visible: parent.secure
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