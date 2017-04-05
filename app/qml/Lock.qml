import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.0
import QtQuick.Controls.Material 2.1

Image {
    source: "qrc:/res/lock_background_dark.jpg"
    fillMode: Image.PreserveAspectCrop

    width: window.width
    height: window.height

    Material.theme: Material.Dark

    Rectangle {
        width: window.width
        height: window.height
        color: "black"
        opacity: 0.9

        GridLayout {
            anchors.centerIn: parent
            columns: 1
            rowSpacing: 64

            Image {
                anchors.centerIn: parent
                mipmap: true
                source: "qrc:/res/logo_transparent_64.png"
            }

            TextField {
                id: passInput
                focus: true
                placeholderText: qsTr("      Type password to unlock      ") // 6 spaces on each side to make textfield wider (if it's stupid but it works it ain't stupid)
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

}