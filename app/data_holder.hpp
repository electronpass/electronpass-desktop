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

#ifndef DATA_HOLDER_HPP
#define DATA_HOLDER_HPP

#include <QObject>
#include <QString>
#include <QList>
#include <string>
#include <fstream>
#include <vector>
#include <iostream>
#include <algorithm>
#include <limits>

#include <electronpass/crypto.hpp>
#include <electronpass/serialization.hpp>
#include <electronpass/passwords.hpp>
#include "globals.hpp"


class DataHolder: public QObject {
    Q_OBJECT

    bool unlocked = false;

    electronpass::Crypto* crypto = 0;
    electronpass::Wallet wallet;

    std::vector<std::string> item_ids;

    std::vector<QString> item_names;
    std::vector<QString> item_subnames;

    // Items order is changed, because displayed items should be sorted in alphabetical order.
    std::vector<int> permutation_vector;
    std::vector<int> inverse_permutation_vector;

    // This is where indices of found items are stored.
    std::vector<int> search_results;
    std::vector<int> inverse_search_results;

    std::vector<QString> search_strings;
    bool searching = false;

    std::string new_item_id = "";

    // Reads first line of encrypted file.
    // Location of encrypted file is stored in settings.
    static std::string read_file(bool& success);

    // Writes single-line string to file.
    static bool write_file(const std::string& data);

    // Functions to convert from QMap to Field object and reverse.
    static QMap<QString, QVariant> convert_field(const electronpass::Wallet::Field& field);
    static electronpass::Wallet::Field convert_field(const QMap<QString, QVariant>& field);

    // Fills new item with template value.
    static void fill_item_template(electronpass::Wallet::Item& item, const std::string& item_template);

    // Returns uuid of item at index. Empty string if index is too large or if locked.
    std::string index_to_id(int index) const;
    // Returns index where item with given id should be located.
    int id_to_index(const std::string& id) const;

    // Items need to be sorted in alphabetical order. Instead of actually sorting them,
    // only a permutation vector is created.
    void sort_items();

    // Returns position of item in item_names, item_subnames, item_id...
    int permute(int index) const;
    int permute_back(int index) const;

    // Encrypts wallet and saves it. Should be already called by other functions.
    // Also updates names in side bar and search strings.
    // Returns:
    //      0 - OK
    //     -1 - Nothing to save, app is locked.
    //      1 - Encryption failed.
    //      2 - File write failed.
    // Result is saved in saving_error variable.
    int save();

    // -1 means that saving was not performed yet.
    // See also: save
    int saving_error = -1;

    // Updates item_names, search_strings...
    void update();

public:
    DataHolder() {}

    // Opens file and tries do decrypt it with password.
    // Also converts decrypted file (json string) to electronpass::Wallet object.
    // Returns:
    //     0 - success.
    //     1 - electronpass::Crypto initialization was not successful
    //     2 - can't open file at globals::settings.get_data_location()
    //     3 - decryption was not succuessful (probably wrong password)
    Q_INVOKABLE int unlock(const QString& password);

    // Deletes all decrypted data and electronpass::Crypto object used for decryption.
    Q_INVOKABLE void lock();

    Q_INVOKABLE int get_number_of_items() const;
    Q_INVOKABLE QString get_item_name(int index) const;
    Q_INVOKABLE QString get_item_subname(int index) const;

    Q_INVOKABLE int get_number_of_item_fields(int index) const;
    Q_INVOKABLE QMap<QString, QVariant> get_item_field(int item_index, int field_index) const;

    // Returns index of first found item which contains string.
    Q_INVOKABLE int search(const QString& s);
    Q_INVOKABLE void stop_search();

    // Deletes item at index. Function save must be called afterwards to apply changes.
    // Returns 0 if everything was OK and 1 if not.
    Q_INVOKABLE int delete_item(int index);

    // Replaces past item with new item and saves it.
    // Returns pair new index of element.
    // get_saving_error() should be called afterwards to check if saving was sucessful.
    Q_INVOKABLE int change_item(int index, const QString& name, const QVariantList& fields);

    // Creates new item with given template.
    // Returns index of new item. Does not save the wallet.
    Q_INVOKABLE int add_item(const QString& item_template);

    // Deletes not saved items. Should be called after `add_item` if item is not saved.
    Q_INVOKABLE void cancel_edit();

    // Returns last save() call's return value.
    Q_INVOKABLE int get_saving_error();

    // Saves wallet with new password.
    // Retuns true if password was successfully changed and false if not.
    // If not, error code can be retrieved by calling get_saving_error().
    Q_INVOKABLE bool change_password(const QString& old_password, const QString& new_password);

};

#endif // DATA_HOLDER_HPP
