import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

Pane {
    anchors.verticalCenter: parent.verticalCenter
    Layout.leftMargin: 16
    Layout.rightMargin: 16
    Layout.topMargin: 16
    Layout.bottomMargin: 16
    padding: 0
    leftPadding: 8
    Material.elevation: 1
    Material.background: (settings.theme == 1) ? Material.color(Material.Grey, Material.Shade800) : Material.color(Material.Grey, Material.Shade100)

    id: itemDetails
    property color greyTextColor: (settings.theme == 1) ? Material.color(Material.Grey, Material.Shade400) : Material.color(Material.Grey, Material.Shade700)

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        id: rootColumnLayout

        RowLayout {
            Layout.fillWidth: true
            Layout.bottomMargin: 16
            Label {
                text: "Github"
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

        RowLayout {
            Layout.topMargin: -24
            Item {
                width: 108
                Label {
                    text: "Username: "
                    font.pixelSize: 14
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignRight
                }
            }
            Label {
                Layout.fillWidth: true
                text: "zigapk"
                color: itemDetails.greyTextColor
                font.pixelSize: 14
            }
            ToolButton {
                font.pixelSize: 14
                text: qsTr("\uE14D")
                font.family: materialIconsFont.name
                Material.foreground: itemDetails.greyTextColor
                onClicked: snackbar.open("Username copied to clipboard.")
            }
        }

        RowLayout {
            Layout.topMargin: -24
            Item {
                width: 108
                Label {
                    text: "Password: "
                    font.pixelSize: 14
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignRight
                }
            }
            Label {
                Layout.fillWidth: true
                text: "\u2022\u2022\u2022\u2022\u2022\u2022\u2022"
                font.pixelSize: 18
            }
            ToolButton {
                font.pixelSize: 14
                text: qsTr("\uE417")
                font.family: materialIconsFont.name
                Material.foreground: itemDetails.greyTextColor
            }
            ToolButton {
                font.pixelSize: 14
                text: qsTr("\uE14D")
                font.family: materialIconsFont.name
                Material.foreground: itemDetails.greyTextColor
                onClicked: snackbar.open("Password copied to clipboard.")
            }
        }
    }
}