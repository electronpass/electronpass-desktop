import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1

ColumnLayout {
    anchors.left: viewDivider.right
    anchors.right: window.right
    Text {
        anchors.centerIn: parent
        text: "DETAILS\n" + parent.width + "x" + parent.height
    }
}