import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1

ColumnLayout {
    anchors.left: viewDivider.right
    anchors.right: window.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom

    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.topMargin: 16
        Layout.bottomMargin: 16
        Label {
            text: "Github"
            font.pixelSize: 20
            Layout.fillWidth: true
        }
        ToolButton {
            Image {
                anchors.centerIn: parent
                source: (settings.theme == 1) ? "qrc:/res/ic_action_edit_dark.png" : "qrc:/res/ic_action_edit.png"
                mipmap: true
            }
        }
        ToolButton {
            Image {
                anchors.centerIn: parent
                source: (settings.theme == 1) ? "qrc:/res/ic_action_delete_dark.png" : "qrc:/res/ic_action_delete.png"
                mipmap: true
            }
            onClicked: deleteConfirmationDialog.open()
        }
    }

    DeleteConfirmationDialog{
        id: deleteConfirmationDialog
    }
}