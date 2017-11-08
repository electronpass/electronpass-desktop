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
          app/sync/auth_server.cpp \
          app/sync/dropbox.cpp \
          app/sync/gdrive.cpp \
          app/sync/sync_manager.cpp

INCLUDEPATH += dependencies \
               app \
               app/sync
LIBS += $$PWD/dependencies/libelectronpass.a \
        $$PWD/dependencies/libcryptopp.a

DESTDIR = $$PWD/bin
