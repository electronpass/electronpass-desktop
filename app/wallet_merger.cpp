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

#include "wallet_merger.hpp"

int WalletMerger::merge(const std::string& online_string) {
    std::cout << "<wallet_merger.cpp> [Log] Merging wallets." << std::endl;

    need_decrypt = false;

    int error = -1;
    electronpass::Wallet online_wallet = electronpass::serialization::load(online_string,
                                                        *globals::data_holder.crypto, error);

    if (error != 0) {
        if (error == 2) std::cout << "<wallet_merger.cpp> [Warning] Wallet json online is invalid." << std::endl;
        if (error == 1) std::cout << "<wallet_merger.cpp> [Log] Online wallet is not encrypted with same password." << std::endl;

        need_decrypt = true;
        online_json = online_string;
        return error;
    }

    globals::data_holder.wallet = electronpass::Wallet::merge(globals::data_holder.wallet, online_wallet);
    error = globals::data_holder.save();
    if (error != 0) return 3;
    return 0;
}

int WalletMerger::decrypt_online_wallet(const QString& password) {
    std::string password_str = password.toStdString();

    electronpass::Crypto crypto(password_str);

    int error = -1;
    electronpass::Wallet online_wallet = electronpass::serialization::load(online_json, crypto, error);
    if (error != 0) return error;

    globals::data_holder.wallet = electronpass::Wallet::merge(globals::data_holder.wallet, online_wallet);

    // TODO: If online wallet is newer, globals::data_holder.crypto object

    error = globals::data_holder.save();
    if (error != 0) return 3;

    need_decrypt = false;
    return 0;
}

bool WalletMerger::need_decrypt_online_wallet() const {
    return need_decrypt;
}
