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
    property string text
    property string icon: "\uE001"

    background: Rectangle {
        color: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade800) : Material.color(Material.Grey, Material.Shade300)
        radius: 2
    }

    RowLayout {
      width: parent.width
      Label {
          font.family: materialIconsFont.name
          text: snackbar.icon
          font.pointSize: 24
          Layout.margins: -6
          Layout.rightMargin: 6
          Layout.leftMargin: 0
          color: Material.color(Material.Grey, Material.Shade300)
      }
      Label {
          text: snackbar.text
          Layout.fillWidth: true
          color: Material.color(Material.Grey, Material.Shade400)
          wrapMode: Text.WordWrap
      }
    }
}
