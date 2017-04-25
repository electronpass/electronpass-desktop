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
#include "globals.hpp"


class DataHolder: public QObject {
    Q_OBJECT

    bool unlocked = false;

    electronpass::Crypto* crypto = 0;
    electronpass::Wallet wallet;

    std::vector<QString> item_names;
    std::vector<QString> item_subnames;
    std::vector<int> item_numbers;

    std::vector<QString> search_strings;
    std::vector<int> found_indices;
    bool search_in_progress = false;

    std::vector<electronpass::Wallet::Field> current_item;
    int current_item_index = -1;

    // Reads first line of encrypted file.
    // Location of encrypted file is stored in settings.
    std::string read_file(bool& success);

    // Writes single-line string to file.
    bool write_file(const std::string& data);

    QList<QString> convert_field(const electronpass::Wallet::Field& field);
    electronpass::Wallet::Field convert_field(const QList<QString>& field);

    // Encrypts wallet and saves it. Should be already called by other functions.
    // Also updates names in side bar and search strings.
    // Returns:
    //      0 - OK
    //     -1 - Nothing to save, app is locked.
    //      1 - Encryption failed.
    //      2 - File write failed.
    Q_INVOKABLE int save();

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

    Q_INVOKABLE int get_number_of_items();
    Q_INVOKABLE QString get_item_name(int id);
    Q_INVOKABLE QString get_item_subname(int id);

    Q_INVOKABLE int get_number_of_item_fields(int id);
    Q_INVOKABLE QList<QString> get_item_field(int item_id, int field_id);

    // Returns index of first found item which contains string.
    Q_INVOKABLE int search(const QString& s);
    Q_INVOKABLE void stop_search();

    // Deletes item at index. Function save must be called afterwards to apply changes.
    // Returns 0 if everything was OK and 1 if not.
    Q_INVOKABLE int delete_item(int id);


    // Function that changes attribute of one of the items.
    // electronpass::Wallet object should be then deserialized to json, encrypted and saved.
    // Q_INVOKABLE void change(??);
};

#endif // DATA_HOLDER_HPP
