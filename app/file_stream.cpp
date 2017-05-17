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

std::string file_stream::read_file(bool& success, std::string path_) {
    std::string path = path_ == "" ? globals::settings.get_data_location().toStdString() : path_;
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

// bool file_stream::write_file(const std::string& data) {
//     std::string path = globals::settings.get_data_location().toStdString();
//     return file_stream::write_file(data, path);
// }

bool file_stream::write_file(const std::string& data, std::string path /* = "" */) {
    if (path == "") {
        path = globals::settings.get_data_location().toStdString();
    }

    // Create new directories if necessary.
    QDir qdir;
    bool success = qdir.mkpath(globals::settings.get_data_folder());

    std::ofstream file(path);

    if (!file.is_open() || !success) {
        std::cout << "<file_stream.cpp> [Error] Could not open file." << std::endl;
        std::cout << "File path: " << path << '\n';
        return false;
    }

    file << data << '\n';

    file.close();
    return true;
}

bool file_stream::copy_file(std::string old_location, std::string new_location /* = "" */) {
    if (new_location == "") new_location = globals::settings.get_data_location().toStdString();

    QDir qdir;
    bool success = qdir.mkpath(globals::settings.get_data_folder());

    std::ifstream in_file(old_location, std::ios::binary);
    std::ofstream out_file(new_location, std::ios::binary);

    // Could not open file at old_location.
    if (!in_file.is_open() || !out_file.is_open() || !success) {
        std::cout << "<file_stream.cpp> [Error] Could not open file." << std::endl;
        std::cout << "File locatons: " << old_location << " " << new_location << std::endl;
        return false;
    }

    out_file << in_file.rdbuf();
    return true;
}
