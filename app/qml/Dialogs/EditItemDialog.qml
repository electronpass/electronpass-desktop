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
import "../Components"

Dialog {

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    modal: true
    standardButtons: Dialog.Save | Dialog.Cancel

    onAccepted: {
      saveEditDetails();
      destroyEditDetails();
    }
    onRejected: destroyEditDetails()

    width: Math.min(parent.width * 0.9, 420)
    height: Math.min(parent.height * 0.9, 600)

    //timer for destruction
    Timer {
        id: timer
        interval: 0

        onTriggered: {
            if (!running) {
                details.destroyEditDetails()
            }
        }
    }

    function setTitle(title) {
        detailsTitleLabel.text = title;
    }

    function addEditDetail(obj){
        editDetailsModel.append({titlevar: obj.titlevar, contentvar: obj.contentvar, securevar: obj.securevar, urlvar: obj.urlvar});
    }

    function destroyEditDetails(){
        detailsTitleLabel.text = "";
        editDetailsModel.clear();
    }

    function destroyEditDetailsWithDelay(delay){
        timer.interval = delay;
        timer.restart();
    }

    function saveEditDetails(){
        var field = new Array(editDetailsModel.count);
        for (var i = 0; i < editDetailsModel.count; ++i) {
            var line = {
                name: editDetailsModel.get(i)["titlevar"],
                value: editDetailsModel.get(i)["contentvar"],
                sensitive: editDetailsModel.get(i)["securevar"],
                type: editDetailsModel.get(i)["typevar"]
            };
            field[i] = line;
        }
        dataHolder.change_item(itemsList.currentIndex, detailsTitleLabel.text, field);
    }

    Pane {
        width: parent.width
        height: parent.height
        padding: 0

        ColumnLayout {
            width: parent.width
            height: parent.height
            id: rootColumnLayout

            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: 16
                id: detailsTitleContainer
                TextField {
                    id: detailsTitleLabel
                    font.pixelSize: 20
                    Layout.fillWidth: true
                    background.opacity: bcgOpacity

                    property real bcgOpacity: activeFocus ? 1 : 0

                    Behavior on bcgOpacity {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutCubic
                        }
                    }
                }
                ToolButton {
                    font.family: materialIconsFont.name
                    font.pixelSize: 24
                    text: qsTr("\uE145")
                    onClicked: {
                      editDetailsModel.append({ titlevar: "Email", contentvar: "some.mail@protonmail.com", securevar: false, typevar: "email" })
                    }
                }
            }

            //model to hold details
            ListModel {
              id: editDetailsModel
            }

            ListView {
                anchors.left: parent.left
                anchors.right: parent.right
                Layout.fillHeight: true
                model: editDetailsModel

                add: Transition {
                    NumberAnimation { properties: "opacity"; from: 0.0; to: 1.0; duration: 200; easing.type: Easing.InOutCubic }
                }

                displaced: Transition {
                    NumberAnimation { properties: "y"; duration: 200; easing.type: Easing.InOutCubic }
                }

                delegate: EditItemDetail {
                  title: titlevar
                  content: contentvar
                  secure: securevar
                }
            }
        }
    }
}
