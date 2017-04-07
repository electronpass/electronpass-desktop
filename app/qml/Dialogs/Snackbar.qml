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
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.1

Pane {
    id: snackbar

    property string buttonText: "ok"
    property color buttonColor: Material.accent
    property string text
    property bool opened
    property int duration: 2000
    property bool fullWidth

    signal clicked

    function open(text) {
        snackbar.text = text
        snackbar.buttonText = ""
        opened = true;
        timer.restart();
    }

    function openWithButton(text, buttonText) {
        snackbar.text = text
        snackbar.buttonText = buttonText
        opened = true;
        timer.restart();
    }

    anchors {
        left: fullWidth ? parent.left : undefined
        right: fullWidth ? parent.right : undefined
        bottom: parent.bottom
        bottomMargin: opened ? 0 :  -snackbar.height
        horizontalCenter: fullWidth ? undefined : parent.horizontalCenter

        Behavior on bottomMargin {
            NumberAnimation { duration: 300 }
        }
    }

    background: Rectangle {
        color: Material.color(Material.Grey, Material.Shade800)
    }
    height: snackLayout.height
    width: fullWidth ? undefined : snackLayout.width
    opacity: opened ? 1 : 0

    Timer {
        id: timer

        interval: snackbar.duration

        onTriggered: {
            if (!running) {
                snackbar.opened = false;
            }
        }
    }

    RowLayout {
        id: snackLayout

        anchors {
            verticalCenter: parent.verticalCenter
            left: snackbar.fullWidth ? parent.left : undefined
            right: snackbar.fullWidth ? parent.right : undefined
        }

        spacing: 0

        Item {
            width: 24
        }

        Label {
            id: snackText
            Layout.fillWidth: true
            Layout.minimumWidth: snackbar.fullWidth ? -1 : 216 - snackButton.width
            Layout.maximumWidth: snackbar.fullWidth ? -1 :
                Math.min(496 - snackButton.width - middleSpacer.width - 48,
                         snackbar.parent.width - snackButton.width - middleSpacer.width - 48)

            Layout.preferredHeight: lineCount == 2 ? 80 : 42
            verticalAlignment: Text.AlignVCenter
            maximumLineCount: 2
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            text: snackbar.text
            color: "white"
        }

        Item {
            id: middleSpacer
            width: snackbar.buttonText == "" ? 0 : snackbar.fullWidth ? 24 : 48
        }

        Button {
            id: snackButton
            flat: true
            highlighted: true
            visible: snackbar.buttonText != ""
            text: snackbar.buttonText
            width: visible ? implicitWidth : 0
            onClicked: snackbar.clicked()
        }

        Item {
            width: 24
        }
    }

    Behavior on opacity {
        NumberAnimation { duration: 300 }
    }
}
