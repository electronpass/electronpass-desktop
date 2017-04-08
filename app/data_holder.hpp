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

#include <electronpass/crypto.hpp>
#include <electronpass/serialization.hpp>
#include "globals.hpp"

class DataHolder: public QObject{
    Q_OBJECT

    electronpass::Crypto* crypto = 0;
    electronpass::Wallet wallet;
    QList<QString> item_names;

    // Reads first line of encrypted file.
    // Location of encrypted files is
    std::string read_file(bool& success);

public:
    DataHolder() {}

    // Opens file and tries do decrypt it with password.
    // Returns true if decryption was successful and false otherwise.
    // Also converts decrypted file (json string) to electronpass::Wallet object.
    Q_INVOKABLE bool unlock(const QString& password);

    // Deletes all decrypted data and electronpass::Crypto object used for decryption.
    Q_INVOKABLE void lock();

    // Function that changes attribute of one of the items.
    // electronpass::Wallet object should be then deserialized to json, encrypted and saved.
    // Q_INVOKABLE void change(??);
};

#endif // DATA_HOLDER_HPP
