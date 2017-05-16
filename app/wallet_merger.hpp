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

#ifndef WALLET_MERGER_HPP
#define WALLET_MERGER_HPP

#include <QObject>
#include <QString>
#include <string>
#include <cassert>
#include <iostream>
#include <electronpass/wallet.hpp>
#include <electronpass/crypto.hpp>
#include "globals.hpp"

class WalletMerger : public QObject {
    Q_OBJECT
    std::string online_json = "";
    bool need_decrypt = false;

public:
    // Returns:
    // - 0 everything was ok. Merged wallet can be get with get_wallet function
    // - 1 online wallet is decrypted with different passowrd. Call function decrypt_online_wallet
    //      with correct online password.
    // - 2 given string is not a valid json object.
    // - 3 saving new merged wallet failed. For more deailed error call globals::data_holder.get_saving_error
    // This could happen when user has changed his master password and online wallet was not updated yet,
    // or if user has updated his password on other device.
    int merge(const std::string& online_string);

    // Tries to decrypt online_json string given in merge function.
    // Returns:
    // - 0 Decryption was successful
    // - 1 Wrong password
    // - 2 Invalid json
    // - 3 saving error
    // If wallet was already decrypted also returns false.
    Q_INVOKABLE int decrypt_online_wallet(const QString& password);

    Q_INVOKABLE bool need_decrypt_online_wallet() const;
};

#endif // WALLET_MERGER_HPP
