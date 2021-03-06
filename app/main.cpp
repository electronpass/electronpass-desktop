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

#include <iostream>

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QSettings>

#include "globals.hpp"
#include "data_holder.hpp"
#include "settings.hpp"
#include "clipboard.hpp"
#include "passwords.hpp"
#include "setup.hpp"
#include "wallet_merger.hpp"
#include "sync/sync_manager.hpp"
#include "file_dialog.hpp"

const char *ORGANIZATION_NAME = "ElectronPass";
const char *APPLICATION_NAME = "ElectronPass";
const char *DOMAIN_NAME = "electronpass.github.io";
const char *DESKTOP_FILE_NAME = "electronpass.desktop";

#ifdef Q_WS_MAC
    delete ORGANIZATION_NAME[];
    ORGANIZATION_NAME = DOMAIN_NAME;
#endif

int main(int argc, char *argv[]) {
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    app.setOrganizationName(QLatin1String(ORGANIZATION_NAME));
    app.setOrganizationDomain(QLatin1String(DOMAIN_NAME));
    app.setApplicationName(QLatin1String(APPLICATION_NAME));

    app.setDesktopFileName(QLatin1String(DESKTOP_FILE_NAME));

    // Set the X11 WML_CLASS so X11 desktops can find the desktop file
    qputenv("RESOURCE_NAME", DESKTOP_FILE_NAME);

    if (QQuickStyle::name().isEmpty()) QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    QSettings qsettings(ORGANIZATION_NAME, APPLICATION_NAME);

    // init global objects
    globals::settings.init(qsettings);
    globals::sync_manager.init();
    globals::clipboard.init();

    FileDialog file_dialog;
    Passwords passwords;
    Setup setup;
    engine.rootContext()->setContextProperty("clipboard", &globals::clipboard);
    engine.rootContext()->setContextProperty("passwordManager", &passwords);
    engine.rootContext()->setContextProperty("setup", &setup);
    engine.rootContext()->setContextProperty("dataHolder", &globals::data_holder);
    engine.rootContext()->setContextProperty("syncManager", &globals::sync_manager);
    engine.rootContext()->setContextProperty("walletMerger", &globals::wallet_merger);
    engine.rootContext()->setContextProperty("fileDialog", &file_dialog);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    // Print location, for testing only.
    std::cout << "<main.cpp> [Log] Data location: " << globals::settings.get_data_location().toStdString() << std::endl;

    return app.exec();
}
