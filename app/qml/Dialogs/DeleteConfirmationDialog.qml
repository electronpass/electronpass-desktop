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
    title: "Are you sure you want to delete this item?"
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true

    x: (window.width - width) / 2
    y: (window.height - height) / 2

    width: Math.min(window.width * 0.9, 400)
    height: Math.min(parent.height * 0.4, 100)

    property int index_to_delete: 0

    onOpened: {
        index_to_delete = itemsList.currentIndex
    }

    onAccepted: {
        var success = dataHolder.delete_item(index_to_delete)
        if (success != 0) {
            // TODO: report error
            console.log("[Error] Could not save wallet.")
        }
        refreshUI()
        syncIndicator.sync()
    }
}
