TARGET = electronpass
QT += qml quick widgets quickcontrols2
RESOURCES += app/electronpass.qrc \
             app/res/fonts/fonts.qrc \
             app/res/img/img.qrc

HEADERS = app/clipboard.hpp \
          app/data_holder.hpp \
          app/file_stream.hpp \
          app/globals.hpp \
          app/passwords.hpp \
          app/settings.hpp \
          app/setup.hpp \
          app/wallet_merger.hpp \
          app/file_dialog.hpp \
          app/sync/auth_server.hpp \
          app/sync/dropbox.hpp \
          app/sync/gdrive.hpp \
          app/sync/keys.hpp \
          app/sync/sync_base.hpp \
          app/sync/sync_manager.hpp

SOURCES = app/clipboard.cpp \
          app/convert_field.cpp \
          app/data_holder.cpp \
          app/file_stream.cpp \
          app/globals.cpp \
          app/item_template.cpp \
          app/main.cpp \
          app/passwords.cpp \
          app/search.cpp \
          app/settings.cpp \
          app/setup.cpp \
          app/wallet_merger.cpp \
          app/file_dialog.cpp \
          app/sync/auth_server.cpp \
          app/sync/dropbox.cpp \
          app/sync/gdrive.cpp \
          app/sync/sync_manager.cpp

INCLUDEPATH += dependencies \
               app \
               app/sync
LIBS += $$PWD/dependencies/electronpass.lib \
        $$PWD/dependencies/cryptlib.lib

DESTDIR = $$PWD/bin

target.path = $${PREFIX}/usr/local/bin/
INSTALLS += target


desktopfile.path = $${PREFIX}/usr/local/share/applications/
desktopfile.files = data/electronpass.desktop
INSTALLS += desktopfile

icon.path = $${PREFIX}/usr/share/icons/hicolor/scalable/apps/
icon.files = data/electronpass.svg
INSTALLS += icon

appdata.path = $${PREFIX}/usr/share/metainfo/
appdata.files = data/electronpass.appdata.xml
INSTALLS += appdata
