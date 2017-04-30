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
  property bool numbersOnly: false
  property int passLength: settings.defaultPassLength
  property int pinLength: 4
  property int numberOfDigitsInPassword: settings.numberOfDigitsInPassword
  property int numberOfSymbolsInPassword: settings.numberOfSymbolsInPassword
  property int numberOfUppercaseLettersInPassword: settings.numberOfUppercaseLettersInPassword
  property var toFill: undefined
  Material.background: (Material.theme == Material.Dark) ? Material.color(Material.Grey, Material.Shade800) : Material.color(Material.Grey, Material.Shade100)

  function generateRandomPass(){
    if (passwordGenerator.numbersOnly)
      generatedPassword = passwordManager.generateRandomPassWithRecipe(pinLength, pinLength, 0, 0)
    else generatedPassword = passwordManager.generateRandomPassWithRecipe(passLength, numberOfDigitsInPassword, numberOfSymbolsInPassword, numberOfUppercaseLettersInPassword);
  }

  onOpened: generateRandomPass()

  ColumnLayout {
    Label {
      text: "    Password generator    "
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
          try{
            passwordGenerator.toFill.text = generatedPassword;
          }catch (e){
            console.log("[Warning] No item to fill by passwordGenerator!")
          }
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
      visible: !passwordGenerator.numbersOnly
      Item {
        Layout.topMargin: -16
        Layout.fillWidth: true
        Label {
          text: "Lenght:"
          font.pointSize: 10
        }
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
          numberOfDigitsInput.increase();
          numberOfDigitsInput.decrease();
        }
      }
    }
    RowLayout {
      visible: passwordGenerator.numbersOnly
      Item {
        Layout.topMargin: -16
        Layout.fillWidth: true
        Label {
          text: "Lenght:"
          font.pointSize: 10
        }
      }
      SpinBox {
        id: pinLengthInput
        from: 1
        to: 128
        value: passwordGenerator.pinLength
        scale: 0.75 //bad solution
        editable: true
        Layout.maximumWidth: 132
        Layout.leftMargin: -20
        Layout.rightMargin: -26
        onValueChanged: {
          passwordGenerator.pinLength = value;
          passwordGenerator.generateRandomPass();
        }
      }
    }
    RowLayout {
      Layout.topMargin: -24
      visible: !passwordGenerator.numbersOnly
      Item {
        Layout.fillWidth: true
        Layout.topMargin: -16
        Label {
          text: "Digits:"
          font.pointSize: 10
          font.weight: Font.Light
        }
      }
      SpinBox {
        id: numberOfDigitsInput
        from: 0
        to: passwordGenerator.passLength
        value: passwordGenerator.numberOfDigitsInPassword
        scale: 0.75 //bad solution
        editable: true
        Layout.maximumWidth: 132
        Layout.leftMargin: -22
        Layout.rightMargin: -26
        onValueChanged: {
          settings.numberOfDigitsInPassword = value;
          passwordGenerator.numberOfDigitsInPassword = value;
          passwordGenerator.generateRandomPass();
          numberOfSymbolsInput.increase();
          numberOfSymbolsInput.decrease();
        }
      }
    }
    RowLayout {
      Layout.topMargin: -24
      visible: !passwordGenerator.numbersOnly
      Item {
        Layout.fillWidth: true
        Layout.topMargin: -16
        Label {
          text: "Symbols:"
          font.pointSize: 10
          font.weight: Font.Light
        }
      }
      SpinBox {
        id: numberOfSymbolsInput
        from: 0
        to: passwordGenerator.passLength
        value: passwordGenerator.numberOfSymbolsInPassword
        scale: 0.75 //bad solution
        editable: true
        Layout.maximumWidth: 132
        Layout.leftMargin: -22
        Layout.rightMargin: -26
        onValueChanged: {
          settings.numberOfSymbolsInPassword = value;
          passwordGenerator.numberOfSymbolsInPassword = value;
          passwordGenerator.generateRandomPass();
          numberofUppercaseInput.increase();
          numberofUppercaseInput.decrease();
        }
      }
    }
    RowLayout {
      Layout.topMargin: -24
      visible: !passwordGenerator.numbersOnly
      Item {
        Layout.fillWidth: true
        Layout.topMargin: -16
        Label {
          text: "Uppercase:"
          font.pointSize: 10
          font.weight: Font.Light
        }
      }
      SpinBox {
        id: numberofUppercaseInput
        from: 0
        to: passwordGenerator.passLength
        value: passwordGenerator.numberOfUppercaseLettersInPassword
        scale: 0.75 //bad solution
        editable: true
        Layout.maximumWidth: 132
        Layout.leftMargin: -22
        Layout.rightMargin: -26
        onValueChanged: {
          settings.numberOfUppercaseLettersInPassword = value;
          passwordGenerator.numberOfUppercaseLettersInPassword = value;
          passwordGenerator.generateRandomPass();
        }
      }
    }
  }
}
