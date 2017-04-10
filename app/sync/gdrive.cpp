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

#include "gdrive.hpp"

void Gdrive::open_url() {
    QDesktopServices::openUrl(QUrl("http://github.com/electronpass"));
    AuthServer *server = new AuthServer();
    connect(server, SIGNAL(auth_success(std::string)), this, SLOT(auth_server_request(std::string)));
}

void Gdrive::auth_server_request(std::string request) {
    std::cout << request << std::endl;
}
