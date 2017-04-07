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

ListView {
    id: listView
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.top: parent.top
    highlight: Rectangle { color: Material.color(Material.Grey, Material.Shade300)}
    highlightMoveDuration: 0
    currentIndex: -1

    ScrollIndicator.vertical: ScrollIndicator {
        id: scrollIndicator
        active: true

        anchors.bottom: parent.bottom
        anchors.top: parent.top
    }

    model: 20

    delegate: ItemDelegate {
        text: "neki: " + modelData
        width: listView.width - scrollIndicator.width
        onClicked: {
            listView.currentIndex = modelData;
            console.log("finished" + modelData);
        }
    }

    function nextItem() {
        listView.incrementCurrentIndex();
    }

    function previousItem() {
        listView.decrementCurrentIndex();
    }

    function setItemInxed(index) {
        listView.currentIndex = index;
    }
}
