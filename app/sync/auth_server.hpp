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

#ifndef ELECTRONPASS_AUTH_SERVER_HPP
#define ELECTRONPASS_AUTH_SERVER_HPP

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <iostream>
#include <string>

class AuthServer: public QObject {
    Q_OBJECT
public:
    explicit AuthServer(QObject *parent = 0);

public slots:
    void new_connection();
signals:
    void auth_success(std::string request);

private:
    QTcpServer *server;
};


#endif //ELECTRONPASS_AUTH_SERVER_HPP
