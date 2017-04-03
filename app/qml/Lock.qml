import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1

Rectangle {
    width: window.width
    height: window.height

    color: (settings.theme == 1) ? Material.color(Material.Grey, Material.Shade800): Material.color(Material.Grey, Material.Shade100)
}