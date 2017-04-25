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

bool DataHolder::write_file(const std::string& data) {
    std::string path = globals::settings.get_data_location().toStdString();

    std::ofstream file(path);
    if (!file.good()) return false;

    file << data << std::endl;
    file.close();
    return true;
}

void DataHolder::update() {
    item_names = {};
    item_subnames = {};
    item_numbers = {};

    search_strings = {};
    current_item = {};

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
    return {name, value, sensitive, type};
}

electronpass::Wallet::Field DataHolder::convert_field(const QList<QString>& field_list) {
    electronpass::Wallet::Field field;

    field.name = field_list[0].toStdString();
    field.value = field_list[1].toStdString();
    field.sensitive = field_list[2].toStdString() != "false" ? true : false;

    std::string type = field_list[3].toStdString();

    if (type == "username") field.field_type = electronpass::Wallet::FieldType::USERNAME;
    else if (type == "password") field.field_type = electronpass::Wallet::FieldType::PASSWORD;
    else if (type == "email") field.field_type = electronpass::Wallet::FieldType::EMAIL;
    else if (type == "url") field.field_type = electronpass::Wallet::FieldType::URL;
    else if (type == "pin") field.field_type = electronpass::Wallet::FieldType::PIN;
    else field.field_type = electronpass::Wallet::FieldType::UNDEFINED;

    return field;
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

    update();

    unlocked = true;
    return 0;
}

void DataHolder::lock() {
    unlocked = false;
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

int DataHolder::save() {
    // If locked, there is nothing to save.
    if (!unlocked) return -1;

    std::string text = electronpass::serialization::serialize(wallet);

    if (!crypto->check()) return 1;

    bool success = false;
    text = crypto->encrypt(text, success);
    if (!success) return 1;

    success = write_file(text);
    if (!success) return 2;

    update();

    return 0;
}

int DataHolder::delete_item(int id) {
    if (search_in_progress) {
        id = found_indices[id];
    }
    int error = -1;
    wallet.delete_item(id, error);
    if (error != 0) return 1;

    current_item_index = -1;
    error = save();

    return error != 0;
}

int DataHolder::change_item(int id, const QString& name, const QVariantList& fields) {
    if (search_in_progress) {
        id = found_indices[id];
    }

    electronpass::Wallet::Item item;
    std::vector<electronpass::Wallet::Field> wallet_fields;

    item.name = name.toStdString();

    for (const QVariant& v : fields) {
        QMap<QString, QVariant> m = v.toMap();
        QList<QString> field = {m["name"].toString(), m["value"].toString(),
                                m["sensitive"].toString(), m["type"].toString()
                            };

        for (auto i : field) std::cout << i.toStdString() << " ";
        std::cout << std::endl;

        wallet_fields.push_back(convert_field(field));
    }
    item.set_fields(wallet_fields);

    int error = -1;
    wallet.set_item(id, item, error);

    if (error != 0) return 1;
    error = save();

    return error != 0;
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
