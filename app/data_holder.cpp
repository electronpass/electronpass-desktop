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

std::string DataHolder::read_file(bool& success) {
    std::string path = globals::settings.get_data_location().toStdString();
    std::string data;

    std::ifstream file(path);

    if (!file.good()) {
        success = false;
        return "";
    }
    // Because data is encoded in Base64, it is only in one line.
    std::getline(file, data);

    success = true;
    return data;
}

QList<QString> DataHolder::convert_field(const electronpass::Wallet::Field& field) {
    QString name = QString::fromStdString(field.name);
    QString value = QString::fromStdString(field.value);
    QString sensitive = field.sensitive ? "true" : "false";

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
    return {name, value, sensitive};
}

int DataHolder::unlock(const QString& password) {
    std::string password_string = password.toStdString();

    crypto = new electronpass::Crypto(password_string);
    if (!crypto->check()) return 1;

    bool success = false;
    std::string text = read_file(success);
    if (!success) return 2;

    text = crypto->decrypt(text, success);
    if (!success) return 3;

    wallet = electronpass::serialization::deserialize(text);


    for (auto item : wallet.get_items()) {
        item_names.push_back(QString::fromStdString(item.name));

        std::string subname = "";
        std::string search_string = item.name + " ";
        bool got_subname = false;

        std::vector<electronpass::Wallet::Field> fields = item.get_fields();
        for (auto field : fields) {
            if (!field.sensitive) {
                if (!got_subname) {
                    subname = field.value;
                    got_subname = true;
                }
                search_string += field.value + " ";
            }
        }

        item_numbers.push_back(fields.size());
        item_subnames.push_back(QString::fromStdString(subname));

        QString search_qstring = QString::fromStdString(search_string);
        search_strings.push_back(search_qstring);
    }

    return 0;
}

void DataHolder::lock() {
    // Delete all decrypted data.
    delete crypto;
    crypto = 0;
    wallet = electronpass::Wallet();

    item_names = {};
    item_subnames = {};
    item_numbers = {};

    search_strings = {};
    search_in_progress = false;

    current_item = {};
    current_item_index = -1;
}

int DataHolder::get_number_of_items() {
    if (search_in_progress) {
        return found_indices.size();
    }
    return item_names.size();
}

QString DataHolder::get_item_name(int id) {
    if (search_in_progress) {
        id = found_indices[id];
    }
    return item_names[id];
}

QString DataHolder::get_item_subname(int id) {
    if (search_in_progress) {
        id = found_indices[id];
    }
    return item_subnames[id];
}

int DataHolder::get_number_of_item_fields(int id) {
    if (search_in_progress) {
        id = found_indices[id];
    }
    return item_numbers[id];
}

QList<QString> DataHolder::get_item_field(int item_id, int field_id) {
    if (search_in_progress) {
        item_id = found_indices[item_id];
    }

    if (item_id == current_item_index) {
        return convert_field(current_item[field_id]);
    }

    int error = -1;
    electronpass::Wallet::Item item = wallet.get_item(item_id, error);

    if (error != 0) {
        return {"", "", "", ""};
    }
    current_item_index = item_id;
    current_item = item.get_fields();
    return convert_field(current_item[field_id]);
}
