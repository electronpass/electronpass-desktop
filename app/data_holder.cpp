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

std::string DataHolder::index_to_id(unsigned int index) const {
    if (index >= item_ids.size()) return "";
    return item_ids[index];
}

void DataHolder::update() {
    item_names = {};
    item_subnames = {};
    item_ids = {};

    for (const auto& pair : wallet.items) {
        electronpass::Wallet::Item item;
        std::string item_id;

        std::tie(item_id, item) = pair;

        item_ids.push_back(item_id);

        item_names.push_back(QString::fromStdString(item.name));
        std::string subname = "";

        for (unsigned int i = 0; i < item.size(); ++i) {
            if (!item[i].sensitive) {
                subname = item[i].value;
                break;
            }
        }
        item_subnames.push_back(QString::fromStdString(subname));
    }
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

    std::cout << "/* before serialization */" << std::endl;
    wallet = electronpass::serialization::deserialize(text);
    std::cout << "/* after serialization */" << std::endl;

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

    current_item_index = -1;

    item_ids = {};
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

int DataHolder::delete_item(int index) {
    std::string id = index_to_id(index);

    wallet.items.erase(id);

    current_item_index = -1;
    int error = save();

    return error != 0;
}

int DataHolder::change_item(int index, const QString& name_, const QVariantList& fields) {
    std::string name = name_.toStdString();
    std::string id = index_to_id(index);

    std::vector<electronpass::Wallet::Field> wallet_fields;
    for (const QVariant& v : fields) {
        QMap<QString, QVariant> field = v.toMap();
        wallet_fields.push_back(convert_field(field));
    }

    wallet.items[id] = electronpass::Wallet::Item(name, wallet_fields, id);

    int error = save();
    return error != 0;
}

int DataHolder::get_number_of_items() {
    return item_names.size();
}

QString DataHolder::get_item_name(int index) {
    return item_names[index];
}

QString DataHolder::get_item_subname(int index) {
    return item_subnames[index];
}

int DataHolder::get_number_of_item_fields(int index) {
    std::string id = index_to_id(index);
    return wallet.items[id].size();
}

QMap<QString, QVariant> DataHolder::get_item_field(int item_index, int field_index) {
    std::string item_id = index_to_id(item_index);

    current_item_index = item_index;
    return convert_field(wallet.items[item_id][field_index]);
}
