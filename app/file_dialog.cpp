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

    if (dialog.exec() && dialog.selectedFiles().size() > 0) {
        QUrl selected_file = dialog.selectedFiles()[0];

        std::cout << "<file_dialog.cpp> Selected file: " << selected_file.toString().toStdString() << std::endl;
        return selected_file;
    }

    std::cout << "<file_dialog.cpp> Importing canceled." << std::endl;
    return QString("");
}
