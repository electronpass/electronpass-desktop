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

using namespace electronpass;

void DataHolder::fill_item_template(electronpass::Wallet::Item& item, const std::string& item_template) {
    if (item_template == "login") {
        item.name = "Login";

        Wallet::Field username("Username", "electron", Wallet::FieldType::USERNAME, false);
        Wallet::Field password("Password", passwords::generate_random_pass(16), Wallet::FieldType::PASSWORD, true);
        Wallet::Field website("Website", "github.com/electronpass", Wallet::FieldType::URL, false);

        item.fields = {username, password, website};

    } else if (item_template == "credit_card") {

    } else {
        item.name = "New Item";
        item.fields.push_back(electronpass::Wallet::Field());
    }
}
