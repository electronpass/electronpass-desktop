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

#ifndef FILE_STREAM_HPP
#define FILE_STREAM_HPP

#include <QString>
#include <string>
#include <iostream>
#include "globals.hpp"

namespace file_stream {

    // Reads first line of encrypted file.
    // Location of encrypted file is stored in settings.
    std::string read_file(bool& success);

    // Writes single-line string to file.
    // If path is not given, file is read from data location stored in settings.
    bool write_file(const std::string& data, std::string path = "");

    // Copies content from file at old_location to new location.
    // If new_location is not given, then file is copied to location saved in settings as `data_location`.
    bool copy_file(std::string old_location, std::string new_location = "");

}

#endif //FILE_STREAM_HPP
