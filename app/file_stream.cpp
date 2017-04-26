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

    if (!file.is_open()) {
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

    if (!file.is_open()) {
        std::cout << "<data_holder.cpp> [Error] Could not open file." << std::endl;
        std::cout << "File path: " << path << '\n';
        return false;
    }

    file << data << '\n';

    file.close();
    return true;
}
