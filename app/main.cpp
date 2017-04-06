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

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>

#include "action_handler.hpp"

int main(int argc, char *argv[]) {
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    app.setOrganizationName(QLatin1String("ElectronPass"));
    app.setOrganizationDomain(QLatin1String("electronpass.github.io"));
    app.setApplicationName(QLatin1String("ElectronPass"));

    app.setDesktopFileName(QLatin1String("electronpass.desktop"));

    // Set the X11 WML_CLASS so X11 desktops can find the desktop file
    qputenv("RESOURCE_NAME", "electronpass.desktop");

    if (QQuickStyle::name().isEmpty()) QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    ActionHandler action_handler(argv[0]);

    QQmlContext *ctx = engine.rootContext();
    ctx->setContextProperty("actionHandler", &action_handler);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}
