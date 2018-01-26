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

TextField {
    id: editItemDetailContent
    selectByMouse: true
    inputMethodHints: Qt.ImhSensitiveData
    Layout.fillWidth: true
    text: content
    property bool secureTextVisible: false
    font.pixelSize: 14
    color: greyTextColor
    property string content: editItemDetail.content
    property string type: editItemDetail.type
    background.opacity: bcgOpacity
    placeholderText: "Content"
    validator: (editItemDetail.type == "pin") ? digitsOnlyRegex : titleLabel.validator
    echoMode: TextInput.Password

    function toggleVisibility() {
        if (editItemDetail.secure && secureTextVisible) {
            echoMode = TextInput.Password
            secureTextVisible = false;
        } else if (editItemDetail.secure) {
            echoMode = TextInput.Normal
            secureTextVisible = true;
        }
    }

    onActiveFocusChanged: {
        if (activeFocus) {
            editDetailsList.currentIndex = model.index
            editItemDetailContent.forceActiveFocus()
        }
    }

    property real bcgOpacity: (activeFocus || editItemDetail.secure) ? 1 : 0

    Behavior on bcgOpacity {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutCubic
        }
    }

    onTextChanged: {
        editItemDetail.content = text;
        editDetailsModel.setProperty(model.index, "contentvar", text);
    }

    Component.onCompleted: {
        if (editItemDetail.secure) {
            font.family = robotoMonoFont.name;

            var component = Qt.createComponent("PassStrengthIndicator.qml");
            var width = editItemDetailContent.width
            background = component.createObject(null, {"visible": editItemDetail.secure, "height": editItemDetailContent.height-12, "width": width});
            editItemDetailContent.width = width;
        } else {
            echoMode = TextInput.Normal
        }
    }
}
