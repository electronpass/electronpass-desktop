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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

Dialog {
    id: aboutDialog
    modal: true
    title: qsTr("About ElectronPass")
    standardButtons: Dialog.Close

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2

    ColumnLayout {
        Keys.onReturnPressed: aboutDialog.close()
        anchors.fill: parent
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.alignment: Qt.AlignHCenter
            mipmap: true
            source: (Material.theme == Material.Dark) ?
                            "qrc:/res/img/logo_transparent.png" :
                            "qrc:/res/img/logo.png"
        }
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "<b>" + qsTr("ElectronPass Desktop") + "</b>"
        }
        Label {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("0.1")
        }
        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 16
            text: qsTr("Open source password manager.")
        }
        Label {
            Layout.alignment: Qt.AlignHCenter
            property string electronpassGithub: qsTr("https://www.github.com/electronpass")
            text: "<a href=\"" + electronpassGithub + "\">github.com/electronpass</a>"
            onLinkActivated: dataHolder.open_url(electronpassGithub)
        }
        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 16
            text: qsTr("This application is licensed under <b>GNU GPLv3 license</b>")
        }
    }
}
