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

import QtQuick 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1

Dialog {
    id: resetDialog
    title: qsTr("Warning: This will delete all saved data!")

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: 450

    Label {
        width: parent.width
        text: qsTr("This operation will delete your current wallet with all saved passwords, " +
                    "data saved on online servers will stay untouched.")
        wrapMode: "WordWrap"
    }

    footer: DialogButtonBox {
        Button {
            text: qsTr("I understand, delete my wallet")
            flat: true
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            onClicked: {
                resetDialog.close()
                var success = setup.reset()
                if (success) {
                    setupView.visible = true
                } else {
                    toolTip.text = "Reset failed."
                    toolTip.show()
                }
            }
        }
        Button {
            text: qsTr("Cancel")
            flat: true
            DialogButtonBox.buttonRole: DialogButtonBox.DestructiveRole
            onClicked: resetDialog.close();
        }
    }
}
