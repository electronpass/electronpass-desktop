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

#include "file_dialog.hpp"

#include <iostream>

QUrl FileDialog::save(QString filename) {

    QWidget *parent = 0;
    QFileDialog dialog(parent);

    dialog.setAcceptMode(QFileDialog::AcceptSave);
    dialog.setDirectory(QDir::homePath());
    dialog.setFileMode(QFileDialog::AnyFile);
    dialog.setDefaultSuffix(".wallet");
    dialog.selectFile(filename);

    if (dialog.exec() && dialog.selectedFiles().size() > 0) {
        QUrl selected_file = dialog.selectedFiles()[0];

        std::cout << "<file_dialog.cpp> Selected file: " << selected_file.toString().toStdString() << std::endl;
        return selected_file;
    }

    std::cout << "<file_dialog.cpp> Saving canceled." << std::endl;
    return QString("");
}

QUrl FileDialog::open_file() {

    QWidget *parent = 0;
    QFileDialog dialog(parent);

    dialog.setAcceptMode(QFileDialog::AcceptOpen);
    dialog.setDirectory(QDir::homePath());
    dialog.setFileMode(QFileDialog::ExistingFile);
    dialog.setWindowTitle(QString("Select wallet file"));

    if (dialog.exec() && dialog.selectedFiles().size() > 0) {
        QUrl selected_file = dialog.selectedFiles()[0];

        std::cout << "<file_dialog.cpp> Selected file: " << selected_file.toString().toStdString() << std::endl;
        return selected_file;
    }

    std::cout << "<file_dialog.cpp> Importing canceled." << std::endl;
    return QString("");
}
