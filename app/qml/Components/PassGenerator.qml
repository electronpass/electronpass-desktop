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

Popup {
  id: passwordGenerator
  property string generatedPassword: ""
  property int passLength: settings.defaultPassLength

  function generateRandomPass(){
    generatedPassword = passwordManager.generateRandomPassWithRecipe(passLength, 4, 4, 4)
  }

  onOpened: generateRandomPass()

  ColumnLayout {
    Label {
      text: "Password generator"
      Material.foreground: Material.accent
      font.pointSize: 12
      Layout.fillWidth: true
      horizontalAlignment: Text.AlignHCenter
    }
    RowLayout {
      width: 30
      Button {
        text: "Refresh"
        flat: true
        font.pointSize: 10
        Layout.fillWidth: true
        onClicked: passwordGenerator.generateRandomPass()
      }
      Button {
        text: "Save"
        flat: true
        font.pointSize: 10
        Layout.fillWidth: true
        onClicked: {
          editItemDetailContent.text = generatedPassword;
          passwordGenerator.close();
        }
      }
    }
    Label {
        id: generatedPasswordField
        Layout.fillWidth: true
        Layout.maximumWidth: parent.width
        text: generatedPassword
        font.pixelSize: 14
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAnywhere
        font.family: robotoMonoFont.name;

        background: PassStrengthIndicator {
            height: generatedPasswordField.height+4
            password: generatedPassword
            anchors.centerIn: parent
        }
    }
    RowLayout {
      Label {
        text: "Length:"
        font.pointSize: 10
        width: 48
        id: lengthLabel
      }
      SpinBox {
        id: passwordLengthInput
        from: 1
        to: 128
        value: passwordGenerator.passLength
        scale: 0.75 //bad solution
        editable: true
        Layout.maximumWidth: 132
        Layout.leftMargin: -20
        Layout.rightMargin: -26
        onValueChanged: {
          settings.defaultPassLength = value;
          passwordGenerator.passLength = value;
          passwordGenerator.generateRandomPass();
        }
      }
    }
  }
}
