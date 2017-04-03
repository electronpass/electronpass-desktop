import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1

Rectangle {
    width: window.width
    height: window.height

    // color has to be set manualy, because layouts are transparent and rectangle doesn't respect material theme
    color: (settings.theme == 1) ? Material.color(Material.Grey, Material.Shade900) : Material.color(Material.Grey, Material.Shade100)

    GridLayout {
        anchors.centerIn: parent
        rows: 1
        columnSpacing: 0

        Text {
            anchors.centerIn: parent
            text: "ElectronPass"
        }
    }
}