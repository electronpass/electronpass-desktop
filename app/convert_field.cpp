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

#define kFieldTypeUsername "username"
#define kFieldTypePassword "password"
#define kFieldTypeEmail "email"
#define kFieldTypeUrl "url"
#define kFieldTypePin "pin"
#define kFieldTypeDate "date"
#define kFieldTypeOther "other"
#define kFieldTypeUndefined "undefined";

QMap<QString, QVariant> DataHolder::convert_field(const electronpass::Wallet::Field& field) {
    QMap<QString, QVariant> new_field;

    new_field["name"] = QString::fromStdString(field.name);
    new_field["value"] = QString::fromStdString(field.value);
    new_field["sensitive"] = field.sensitive ? "true" : "false";

    QString type;
    switch (field.field_type) {
        case electronpass::Wallet::FieldType::USERNAME:
            type = kFieldTypeUsername;
            break;
        case electronpass::Wallet::FieldType::PASSWORD:
            type = kFieldTypePassword;
            break;
        case electronpass::Wallet::FieldType::EMAIL:
            type = kFieldTypeEmail;
            break;
        case electronpass::Wallet::FieldType::URL:
            type = kFieldTypeUrl;
            break;
        case electronpass::Wallet::FieldType::PIN:
            type = kFieldTypePin;
            break;
        case electronpass::Wallet::FieldType::DATE:
            type = kFieldTypeDate;
            break;
        case electronpass::Wallet::FieldType::OTHER:
            type = kFieldTypeOther;
        case electronpass::Wallet::FieldType::UNDEFINED:
        default:
            type = kFieldTypeUndefined;
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

    if (type == kFieldTypeUsername) field.field_type = electronpass::Wallet::FieldType::USERNAME;
    else if (type == kFieldTypePassword) field.field_type = electronpass::Wallet::FieldType::PASSWORD;
    else if (type == kFieldTypeEmail) field.field_type = electronpass::Wallet::FieldType::EMAIL;
    else if (type == kFieldTypeUrl) field.field_type = electronpass::Wallet::FieldType::URL;
    else if (type == kFieldTypePin) field.field_type = electronpass::Wallet::FieldType::PIN;
    else if (type == kFieldTypeDate) field.field_type = electronpass::Wallet::FieldType::DATE;
    else if (type == kFieldTypeOther) field.field_type = electronpass::Wallet::FieldType::OTHER;
    else field.field_type = electronpass::Wallet::FieldType::UNDEFINED;

    return field;
}
