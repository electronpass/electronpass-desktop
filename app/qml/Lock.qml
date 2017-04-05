import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1

Rectangle {
    width: window.width
    height: window.height

    // color has to be set manualy, because layouts are transparent and rectangle doesn't respect material theme
    color: (settings.theme == 1) ? Material.color(Material.Grey, Material.Shade900) : Material.color(Material.Grey, Material.Shade100)

    GridLayout {
        anchors.centerIn: parent
        columns: 1
        rowSpacing: 64

        Image {
            anchors.centerIn: parent
            mipmap: true
            source: (settings.theme == 1) ? "qrc:/res/logo_transparent_64.png" : "qrc:/res/logo_transparent_dark_64.png"
        }

        TextField {
            id: passInput
            focus: true
            placeholderText: qsTr("Type password to unlock")
            echoMode: TextInput.Password
            horizontalAlignment: TextInput.AlignHCenter
            Keys.onReturnPressed: {
                // TODO: validate password
                lock.visible = false;
                toolbar.visible = true;
                passInput.clear();
            }
        }
    }

    function setFocus(a) {
        passInput.forceActiveFocus();
    }

}