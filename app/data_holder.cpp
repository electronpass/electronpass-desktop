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

int DataHolder::permute(int index) const {
    if (searching) {
        if (index >= static_cast<int>(search_results.size())) index = -1;
        else index = search_results[index];
    }
    if (index >= static_cast<int>(permutation_vector.size()) || index == -1) return -1;
    return permutation_vector[index];
}

int DataHolder::permute_back(int index) const {
    if (searching) {
        if (index >= static_cast<int>(inverse_search_results.size())) index = -1;
        else index = inverse_search_results[index];
    }
    if (index >= static_cast<int>(inverse_permutation_vector.size()) || index == -1) return -1;
    return inverse_permutation_vector[index];
}

std::string DataHolder::index_to_id(int index) const {
    index = permute(index);
    if (index >= static_cast<int>(item_ids.size()) || index == -1) return "";
    return item_ids[index];
}

int DataHolder::id_to_index(const std::string &id) const {
    int index = std::find(item_ids.begin(), item_ids.end(), id) - item_ids.begin();
    if (index >= static_cast<int>(item_ids.size())) return -1;
    return permute_back(index);
}

void DataHolder::update() {
    item_ids = wallet.get_ids();
    item_names = {};
    item_subnames = {};

    search_strings = {};

    new_item_id = "";

    for (const std::string &id : item_ids) {
        const electronpass::Wallet::Item item = wallet[id];

        item_names.push_back(QString::fromStdString(item.name));
        std::string subname = "";
        std::string search_string = item.name + " ";
        bool subname_found = false;

        for (unsigned int i = 0; i < item.size(); ++i) {
            if (!item[i].sensitive) {
                if (!subname_found) {
                    subname = item[i].value;
                    subname_found = true;
                }
                search_string += item[i].value;
            }
        }
        item_subnames.push_back(QString::fromStdString(subname));
        search_strings.push_back(QString::fromStdString(search_string));
    }
    sort_items();
}

int DataHolder::unlock(const QString &password) {
    std::string password_string = password.toStdString();

    crypto = new electronpass::Crypto(password_string);

    bool success = false;
    std::string text = file_stream::read_file(success);
    if (!success) return 2;

    int error = -1;
    wallet = electronpass::serialization::load(text, *crypto, error);
    if (error == 1) return 3;
    if (error == 2) return 4;

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

    permutation_vector = {};
    inverse_permutation_vector = {};

    search_strings = {};
    search_results = {};
    inverse_search_results = {};
    searching = false;

    saving_error = -1;
}

int DataHolder::save() {
    int error = 0;
    std::string text = electronpass::serialization::save(wallet, *crypto, error);

    if (error != 0) {
        saving_error = 1;
        return 1;
    }
    bool success = file_stream::write_file(text);
    if (!success) {
        saving_error = 2;
        return 2;
    }
    update();

    saving_error = 0;
    return 0;
}

int DataHolder::delete_item(int index) {
    std::string id = index_to_id(index);

    wallet.delete_item(id);

    int error = save();
    return error != 0;
}

int DataHolder::change_item(int index, const QString &name_, const QVariantList &fields) {
    std::string name = name_.toStdString();
    std::string id = index_to_id(index);

    std::vector<electronpass::Wallet::Field> wallet_fields;
    for (const QVariant &v : fields) {
        QMap<QString, QVariant> field = v.toMap();
        wallet_fields.push_back(convert_field(field));
    }

    wallet.edit_item(id, name, wallet_fields);

    save();
    return id_to_index(id);
}

int DataHolder::add_item(const QString &item_template_) {
    electronpass::Wallet::Item item;
    std::string item_template = item_template_.toStdString();

    fill_item_template(item, item_template);

    bool success = wallet.add_item(item);
    if (!success) return -1;

    update();

    new_item_id = item.get_id();

    return id_to_index(new_item_id);
}

void DataHolder::cancel_edit() {
    if (new_item_id != "") {
        wallet.delete_item(new_item_id);
        new_item_id = "";
    }
    update();
}

int DataHolder::get_number_of_items() const {
    if (searching) return search_results.size();
    return wallet.size();
}

QString DataHolder::get_item_name(int index) const {
    index = permute(index);
    if (index >= static_cast<int>(item_names.size()) || index == -1) return "";
    return item_names[index];
}

QString DataHolder::get_item_subname(int index) const {
    index = permute(index);
    if (index >= static_cast<int>(item_subnames.size()) || index == -1) return "";
    return item_subnames[index];
}

int DataHolder::get_number_of_item_fields(int index) const {
    std::string id = index_to_id(index);
    return wallet[id].size();
}

QMap<QString, QVariant> DataHolder::get_item_field(int item_index, int field_index) const {
    std::string item_id = index_to_id(item_index);
    if (static_cast<int>(wallet[item_id].size()) <= field_index) return QMap<QString, QVariant>();
    return convert_field(wallet[item_id][field_index]);
}

int DataHolder::get_saving_error() {
    return saving_error;
}

bool DataHolder::change_password(const QString &old_password, const QString &new_password) {
    std::string old_password_string = old_password.toStdString();
    std::string new_password_string = new_password.toStdString();

    // Check if old_password is correct
    bool success = false;
    std::string text = file_stream::read_file(success);
    if (!success) return false;

    // We use authenticated encryption. That means that if decryption was successful, the password
    // is correct.
    electronpass::Crypto c(old_password_string);

    int error = -1;
    electronpass::serialization::load(text, c, error);
    if (error != 0) return false;

    // Now finally change password. Now we are changing crypto pointer because we need could need
    // to encrypt some further changes with same password.
    delete crypto;
    crypto = new electronpass::Crypto(new_password_string);

    error = save();
    return error == 0;
}

bool DataHolder::new_wallet(const QString &password) {
    std::string password_string = password.toStdString();

    crypto = new electronpass::Crypto(password_string);

    wallet = electronpass::Wallet();

    int error = save();
    return error == 0;
}


void DataHolder::open_url(const QString &url) {
    QDesktopServices::openUrl(QUrl::fromUserInput(url));
}

bool DataHolder::backup_wallet(const QString &filename) const {

    std::string current_path = globals::settings.get_data_location().toStdString();

    bool success = file_stream::copy_file(current_path, filename.toStdString());
    return success;
}

int DataHolder::restore_wallet(const QString &filename, QString password) {
    std::string path = filename.toStdString();

    bool read_success;
    std::string data = file_stream::read_file(read_success, path);
    if (!read_success) return 3;

    electronpass::Crypto new_crypto(password.toStdString());
    int load_error;
    electronpass::Wallet new_wallet = electronpass::serialization::load(data, new_crypto, load_error);

    if (!load_error) {
        bool copy_success = file_stream::copy_file(path);
        if (!copy_success) return 4;

        wallet = new_wallet;
        if (crypto != 0) delete crypto;
        crypto = new electronpass::Crypto(password.toStdString());

        update();
        unlocked = true;
    }

    return load_error;
}

bool DataHolder::export_to_csv(const QString &filename) const {

    std::string export_string = electronpass::serialization::csv_export(wallet);

    return file_stream::write_file(export_string, filename.toStdString());
}
