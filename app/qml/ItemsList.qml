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
import "Components"

ListView {
    id: listView
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.top: parent.top
    highlight: Rectangle {
        color: (Material.theme == Material.Dark) ?
                    Material.color(Material.Grey, Material.Shade800) :
                    Material.color(Material.Grey, Material.Shade300)
    }
    highlightMoveDuration: 0
    currentIndex: -1
    onCurrentItemChanged: mainLayout.onItemSelected(listView.currentIndex)

    ScrollIndicator.vertical: ScrollIndicator {
        id: scrollIndicator
        active: true

        anchors.bottom: parent.bottom
        anchors.top: parent.top
    }

    model: 0

    delegate: listDelegate

    Component {
        id: listDelegate
        ListItem {}
    }

    function nextItem() {
        listView.incrementCurrentIndex()
    }

    function previousItem() {
        listView.decrementCurrentIndex()
    }

    function setItemIndex(index) {
        listView.currentIndex = index
        mainLayout.handleDetails(index)
    }
}
