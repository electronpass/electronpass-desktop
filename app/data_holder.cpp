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

unsigned int DataHolder::id_to_index(const std::string& id) const {
    unsigned int index = std::find(item_ids.begin(), item_ids.end(), id) - item_ids.begin();
    if (index >= item_ids.size()) return -1;
    return index;
}

void DataHolder::update() {
    item_ids = wallet.get_ids();
    item_names = {};
    item_subnames = {};

    for (const std::string& id : item_ids) {
        const electronpass::Wallet::Item item = wallet.items[id];

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

    item_ids = {};
    new_item_id = "";
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

    wallet.edit_item(id, name, wallet_fields);

    int error = save();
    return error != 0;
}

int DataHolder::add_item(const QString& item_template_) {
    electronpass::Wallet::Item item;
    std::string item_template = item_template_.toStdString();

    fill_item_template(item, item_template);

    wallet.add_item(item);

    update();

    new_item_id = item.get_id();

    return id_to_index(new_item_id);
}

void DataHolder::cancel_edit() {
    wallet.items.erase(new_item_id);
    update();
}

int DataHolder::get_number_of_items() const {
    return wallet.items.size();
}

QString DataHolder::get_item_name(unsigned int index) const {
    if (index >= item_names.size()) return "";
    return item_names[index];
}

QString DataHolder::get_item_subname(unsigned int index) const {
    if (index >= item_subnames.size()) return "";
    return item_subnames[index];
}

int DataHolder::get_number_of_item_fields(unsigned int index) {
    std::string id = index_to_id(index);
    return wallet.items[id].size();
}

QMap<QString, QVariant> DataHolder::get_item_field(unsigned int item_index, unsigned int field_index) {
    std::string item_id = index_to_id(item_index);
    if (wallet.items[item_id].size() <= field_index) return QMap<QString, QVariant>();
    return convert_field(wallet.items[item_id][field_index]);
}
