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
    id: editItemDialog
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    modal: true
    standardButtons: Dialog.Save | Dialog.Cancel
    property int index: -1

    onAccepted: {
        saveEditDetails()
        destroyEditDetails()
        syncIndicator.sync()
    }
    onRejected: {
        destroyEditDetails()
        dataHolder.cancel_edit()
        itemsList.model = dataHolder.get_number_of_items()
    }
    width: Math.min(parent.width * 0.9, 420)
    height: Math.min(parent.height * 0.9, 600)

    //timer for destruction
    Timer {
        id: timer
        interval: 0
        onTriggered: {
            if (!running) details.destroyEditDetails()
        }
    }

    function setTitle(title) {
        detailsTitleLabel.text = title
    }

    function addEditDetail(obj){
        editDetailsModel.append({titlevar: obj.titlevar, contentvar: obj.contentvar,
                                 securevar: obj.securevar, typevar: obj.typevar})
    }

    function destroyEditDetails(){
        detailsTitleLabel.text = ""
        editDetailsModel.clear()
    }

    function destroyEditDetailsWithDelay(delay){
        timer.interval = delay
        timer.restart()
    }

    function saveEditDetails(){
        var field = new Array(editDetailsModel.count)
        for (var i = 0; i < editDetailsModel.count; ++i) {
            var line = {
                name: editDetailsModel.get(i)["titlevar"],
                value: editDetailsModel.get(i)["contentvar"],
                sensitive: editDetailsModel.get(i)["securevar"],
                type: editDetailsModel.get(i)["typevar"]
            }
            field[i] = line
        }
        var new_index = dataHolder.change_item(index, detailsTitleLabel.text, field)

        refreshUI()
        itemsList.setItemIndex(new_index)

        if (dataHolder.get_saving_error() != 0) {
            // TODO: report error
            console.log("[Error] Could not save wallet.")
        }
    }

    Pane {
        width: parent.width
        height: parent.height
        padding: 0

        ColumnLayout {
            width: parent.width
            height: parent.height
            id: rootColumnLayout
            Keys.onReturnPressed: editItemDialog.accept()

            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: 16
                id: detailsTitleContainer
                TextField {
                    id: detailsTitleLabel
                    inputMethodHints: Qt.ImhSensitiveData
                    selectByMouse: true
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
                    onClicked: newDetailMenu.open()
                    Menu {
                        id: newDetailMenu
                        y: parent.height
                        x: - width + parent.width
                        MenuItem {
                            text: "Username"
                            onTriggered: editDetailsModel.append({ titlevar: "Username",
                                                                   contentvar: "",
                                                                   typevar: "username" })
                        }
                        MenuItem {
                            text: "Email"
                            onTriggered: editDetailsModel.append({ titlevar: "Email",
                                                                   contentvar: "",
                                                                   typevar: "email" })
                        }
                        MenuItem {
                            text: "Url"
                            onTriggered: editDetailsModel.append({ titlevar: "Url",
                                                                   contentvar: "",
                                                                   typevar: "url" })
                        }
                        MenuItem {
                            text: "Password"
                            onTriggered: editDetailsModel.append({ titlevar: "Password",
                                                                   contentvar: "",
                                                                   securevar: true,
                                                                   typevar: "password" })
                        }
                        MenuItem {
                            text: "PIN"
                            onTriggered: editDetailsModel.append({ titlevar: "PIN", contentvar: "",
                                                                   securevar: true, typevar: "pin" })
                        }
                        MenuItem {
                            text: "Other text"
                            onTriggered: editDetailsModel.append({ titlevar: "", contentvar: "",
                                                                   typevar: "undefined" })
                        }
                    }
                }
            }

            //model to hold details
            ListModel {
              id: editDetailsModel
            }

            ListView {
                id: editDetailsList
                anchors.left: parent.left
                anchors.right: parent.right
                Layout.fillHeight: true
                model: editDetailsModel
                currentIndex: -1

                add: Transition {
                    NumberAnimation { properties: "opacity"; from: 0.0; to: 1.0; duration: 200;
                                      easing.type: Easing.InOutCubic }
                }

                displaced: Transition {
                    NumberAnimation { properties: "y"; duration: 200; easing.type: Easing.InOutCubic }
                }

                delegate: EditItemDetail {
                    title: titlevar
                    content: contentvar
                    secure: securevar
                    type: typevar
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.bottomMargin: -28
                Layout.topMargin: 8
                Label {
                    text: "Move item: "
                    font.weight: Font.Light
                }
                ToolButton {
                    font.pixelSize: 18
                    text: qsTr("\uE316")
                    font.family: materialIconsFont.name
                    Layout.leftMargin: -16
                    enabled: editDetailsList.currentIndex > 0
                    onClicked: editDetailsModel.move(editDetailsList.currentIndex,
                                                     editDetailsList.currentIndex - 1, 1)
                }
                ToolButton {
                    font.pixelSize: 18
                    text: qsTr("\uE313")
                    font.family: materialIconsFont.name
                    Layout.leftMargin: -22
                    enabled: (editDetailsList.currentIndex >= 0 &&
                              editDetailsList.currentIndex < editDetailsModel.count - 1)
                    onClicked: editDetailsModel.move(editDetailsList.currentIndex,
                                                     editDetailsList.currentIndex + 1, 1)
                }
            }
        }
    }

    PassGenerator {
        id: passGenerator
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
    }
}
