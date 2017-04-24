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

#ifndef ELECTRONPASS_SYNC_MANAGER_HPP
#define ELECTRONPASS_SYNC_MANAGER_HPP


#include <string>

#include "globals.hpp"
#include "sync_base.hpp"


class SyncManager {
public:
    SyncManager();

    enum class Service {
        NONE, GDRIVE
    };

    static Service string_to_service(const std::string &);
    static std::string service_to_string(const Service &);

};



#endif //ELECTRONPASS_SYNC_MANAGER_HPP
