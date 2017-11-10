set(SOURCES
        main.cpp
        settings.cpp
        passwords.cpp
        globals.cpp
        clipboard.cpp
        setup.cpp
        wallet_merger.cpp
        data_holder.cpp
        search.cpp
        convert_field.cpp
        file_stream.cpp
        item_template.cpp

        sync/gdrive.cpp
        sync/auth_server.cpp
        sync/sync_manager.cpp
        sync/dropbox.cpp

        electronpass.qrc
        res/fonts/fonts.qrc
        res/img/img.qrc
        )

add_executable(electronpass ${SOURCES})

target_link_libraries(electronpass
        ${CMAKE_SOURCE_DIR}/dependencies/libelectronpass.a
        ${CMAKE_SOURCE_DIR}/dependencies/libcryptopp.a
        Qt5::Core
        Qt5::Qml
        Qt5::Quick
        Qt5::Widgets
        Qt5::QuickControls2
        )
