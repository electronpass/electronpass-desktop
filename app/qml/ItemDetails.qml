import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1

ColumnLayout {
    anchors.left: viewDivider.right
    anchors.right: window.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    ColumnLayout {
        anchors.left: viewDivider.right
        anchors.right: window.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.topMargin: 16
        Layout.bottomMargin: 16

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Label {
                text: "Github"
                font.pixelSize: 20
                Layout.fillWidth: true
            }
            ToolButton {
                font.family: materialIconsFont.name
                font.pixelSize: 22
                text: qsTr("\uE150")
            }
            ToolButton {
                font.family: materialIconsFont.name
                font.pixelSize: 22
                text: qsTr("\uE872")
                onClicked: deleteConfirmationDialog.open()
            }
        }
    }
}