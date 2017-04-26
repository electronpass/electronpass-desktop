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

#include "data_holder.hpp"

QMap<QString, QVariant> DataHolder::convert_field(const electronpass::Wallet::Field& field) {
    QMap<QString, QVariant> new_field;

    new_field["name"] = QString::fromStdString(field.name);
    new_field["value"] = QString::fromStdString(field.value);
    new_field["sensitive"] = field.sensitive ? "true" : "false";

    QString type;
    switch (field.field_type) {
        case electronpass::Wallet::FieldType::USERNAME:
            type = "username";
            break;
        case electronpass::Wallet::FieldType::PASSWORD:
            type = "password";
            break;
        case electronpass::Wallet::FieldType::EMAIL:
            type = "email";
            break;
        case electronpass::Wallet::FieldType::URL:
            type = "url";
            break;
        case electronpass::Wallet::FieldType::PIN:
            type = "pin";
            break;
        case electronpass::Wallet::FieldType::UNDEFINED:
        default:
            type = "undefinded";
            break;
    }
    new_field["type"] = type;

    return new_field;
}

electronpass::Wallet::Field DataHolder::convert_field(const QMap<QString, QVariant>& field_list) {
    electronpass::Wallet::Field field;

    field.name = field_list["name"].toString().toStdString();
    field.value = field_list["value"].toString().toStdString();
    field.sensitive = field_list["sensitive"].toString().toStdString() != "false" ? true : false;

    std::string type = field_list["type"].toString().toStdString();

    if (type == "username") field.field_type = electronpass::Wallet::FieldType::USERNAME;
    else if (type == "password") field.field_type = electronpass::Wallet::FieldType::PASSWORD;
    else if (type == "email") field.field_type = electronpass::Wallet::FieldType::EMAIL;
    else if (type == "url") field.field_type = electronpass::Wallet::FieldType::URL;
    else if (type == "pin") field.field_type = electronpass::Wallet::FieldType::PIN;
    else field.field_type = electronpass::Wallet::FieldType::UNDEFINED;

    return field;
}
