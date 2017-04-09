/*
This file is part of ElectronPass.

ElectronPass is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ElectronPass is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with ElectronPass. If not, see <http://www.gnu.org/licenses/>.
*/

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
                property int unlocked: 4  // not unlocked
                focus: true
                Layout.topMargin: 48
                placeholderText: qsTr("      Type password to unlock      ") // 6 spaces on each side to make textfield wider (if it's stupid but it works it ain't stupid)
                echoMode: TextInput.Password
                horizontalAlignment: TextInput.AlignHCenter
                Keys.onReturnPressed: {
                    passInput.unlocked = dataHolder.unlock(passInput.text)
                    switch (passInput.unlocked) {
                        case 0:
                            unlockGUI();
                            passInput.clear();
                            toolTip.visible = false;
                            break;
                        case 1:
                            // Should not happen (only on random unsafe systems).
                            toolTip.text = "Crypto initialization was not successful."
                            break
                        case 2:
                            toolTip.text = "Couldn't open data file."
                            break
                        case 3:
                            toolTip.text = "Wrong password."
                            break
                    }
                    if (passInput.unlocked != 0) {
                        toolTip.show()
                        passInput.selectAll()
                    }
                }
            }

            RowLayout {
               ToolTip {
                   id: toolTip
                   text: "Locked."
                   timeout: 2000
                   visible: false

                   function show() {
                       timer.restart();
                       visible = true;
                   }

                   Behavior on opacity {
                       NumberAnimation { duration: 300 }
                   }

                   Timer {
                       id: timer

                       interval: toolTip.timeout

                       onTriggered: {
                           if (!running) {
                               toolTip.visible = false;
                           }
                       }
                   }
               }
            }
        }
    }

    function setFocus(a) {
        passInput.forceActiveFocus();
    }

}
