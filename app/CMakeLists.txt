# file(GLOB_RECURSE SOURCES *.cpp *.hpp electronpass.qrc "qml/*.qml")
set(SOURCES
    main.cpp
    settings.cpp
    passwords.cpp
    globals.cpp
    clipboard.cpp

    data_holder.cpp
    search.cpp
    convert_field.cpp
    file_stream.cpp
    item_template.cpp

    sync/gdrive.cpp
    sync/auth_server.cpp
    sync/sync_manager.cpp
    electronpass.qrc
    res/fonts/fonts.qrc
    res/img/img.qrc
    )

add_executable(electronpass ${SOURCES})

# read api keys from file and set them to variables
file(STRINGS sync/keys.txt KEYS_FILE)
foreach(name_and_value ${KEYS_FILE})
    # Strip leading spaces
    string(REGEX REPLACE "^[ ]+" "" name_and_value ${name_and_value})
    # Find variable name
    string(REGEX MATCH "^[^=]+" name ${name_and_value})
    # Find the value
    string(REPLACE "${name}=" "" value ${name_and_value})
    # Set the variable
    set(${name} "${value}")
endforeach()
configure_file(sync/keys.hpp.in sync/keys.hpp)

target_link_libraries(electronpass
        Qt5::Core
        Qt5::Qml
        Qt5::Quick
        Qt5::Widgets
        Qt5::QuickControls2
        ${ELECTRONPASS_LIB}
        ${CURL_LIB})

install(TARGETS electronpass
        DESTINATION ${BIN_INSTALL_DIR})
