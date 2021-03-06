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

#include "auth_server.hpp"

AuthServer::AuthServer(QObject *parent): QObject(parent) {
    server = new QTcpServer(this);
    connect(server, SIGNAL(newConnection()), this, SLOT(new_connection()));
}

bool AuthServer::init() {
    if (!server->listen(QHostAddress::Any, 5160)) {
        std::cout << "mami" << std::endl;
        std::cout << "<auth_server.cpp> [Error] Server could not start!" << std::endl;
        delete server;
        delete this;
        emit did_delete();
        return false;
    }
    return true;
}

void AuthServer::new_connection() {
    QTcpSocket *socket = server->nextPendingConnection();

    if (!socket->waitForReadyRead(-1)) {
        socket->write("HTTP/1.0 200 No Error\nContent-Type: text/html; charset=UTF-8\n\n");
        // TODO: Move html to separate file.
        socket->write("<!DOCTYPE html><html lang=en><meta charset=UTF-8><title>Error!</title><meta content=\"width=device-width,initial-scale=1\"name=viewport><link href=\"https://fonts.googleapis.com/css?family=Roboto\"rel=stylesheet><link href=https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.1/css/materialize.min.css rel=stylesheet><script src=https://code.jquery.com/jquery-2.1.1.min.js></script><script src=https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.1/js/materialize.min.js></script><body class=\"darken-4 grey\"><div class=valign-wrapper style=height:100vh><div class=valign style=width:100%><h2 class=red-text style=width:100%;text-align:center;font-family:Roboto,sans-serif>Unknown Error Occurred!</h2><h6 class=white-text style=width:100%;text-align:center;margin-top:-16px>Please return to ElectronPass.</h6></div></div>");
        socket->flush();

        socket->close();
        server->close();
        socket->deleteLater();
        server->deleteLater();

        emit auth_success("");
        this->deleteLater();

        return;
    }

    QByteArray data = socket->readAll();

    socket->write("HTTP/1.0 200 No Error\nContent-Type: text/html; charset=UTF-8\n\n");

    // TODO: Move html to separate file.
    std::string str(data.data());
    if (str.find("error") != std::string::npos) {
        socket->write("<!DOCTYPE html><html lang=en><meta charset=UTF-8><title>Could not Authorize!</title><meta content=\"width=device-width,initial-scale=1\"name=viewport><link href=\"https://fonts.googleapis.com/css?family=Roboto\"rel=stylesheet><link href=https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.1/css/materialize.min.css rel=stylesheet><script src=https://code.jquery.com/jquery-2.1.1.min.js></script><script src=https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.1/js/materialize.min.js></script><body class=\"darken-4 grey\"><div class=valign-wrapper style=height:100vh><div class=valign style=width:100%><h2 class=red-text style=width:100%;text-align:center;font-family:Roboto,sans-serif>Could not Authorize!</h2><h6 class=white-text style=width:100%;text-align:center;margin-top:-16px>Please return to ElectronPass.</h6></div></div>");
    } else {
        socket->write("<!DOCTYPE html><html lang=en><meta charset=UTF-8><title>Success!</title><meta content=\"width=device-width,initial-scale=1\"name=viewport><link href=\"https://fonts.googleapis.com/css?family=Roboto\"rel=stylesheet><link href=https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.1/css/materialize.min.css rel=stylesheet><script src=https://code.jquery.com/jquery-2.1.1.min.js></script><script src=https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.1/js/materialize.min.js></script><body class=\"darken-4 grey\"><div class=valign-wrapper style=height:100vh><div class=valign style=width:100%><h2 class=cyan-text style=width:100%;text-align:center;font-family:Roboto,sans-serif>Success!</h2><h6 class=white-text style=width:100%;text-align:center;margin-top:-16px>Please return to ElectronPass.</h6></div></div>");
    }

    socket->flush();
    socket->close();
    server->close();
    socket->deleteLater();
    server->deleteLater();

    emit did_delete();
    emit auth_success(str);

    this->deleteLater();
}
