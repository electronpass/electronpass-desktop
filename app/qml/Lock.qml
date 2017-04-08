import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

Image {
    source: "qrc:/res/img/lock_background.jpg"
    fillMode: Image.PreserveAspectCrop

    width: window.width
    height: window.height

    Material.theme: Material.Dark

    Rectangle {
        width: window.width
        height: window.height
        color: "black"
        opacity: 0.85

        GridLayout {
            anchors.centerIn: parent
            columns: 1
            rowSpacing: 64

            Image {
                anchors.centerIn: parent
                mipmap: true
                source: "qrc:/res/img/logo_transparent.png"
            }

            TextField {
                id: passInput
                focus: true
                placeholderText: qsTr("      Type password to unlock      ") // 6 spaces on each side to make textfield wider (if it's stupid but it works it ain't stupid)
                echoMode: TextInput.Password
                horizontalAlignment: TextInput.AlignHCenter
                Keys.onReturnPressed: {
                    // TODO: validate password

                    // passInput.clear();

                    if(dataHolder.unlock(passInput.text)) {
                        unlockGUI();
                    }
                    passInput.clear();

                }
            }
        }
    }

    function setFocus(a) {
        passInput.forceActiveFocus();
    }

}
