# file(GLOB_RECURSE SOURCES *.cpp *.hpp electronpass.qrc "qml/*.qml")
set(SOURCES
    main.cpp
    action_handler.cpp
    settings.cpp
    passwords.cpp
    data_holder.cpp
    globals.cpp
    electronpass.qrc
    res/fonts/fonts.qrc
    res/img/img.qrc
)

add_executable(electronpass ${SOURCES})

target_link_libraries(electronpass
        Qt5::Core
        Qt5::Qml
        Qt5::Quick
        Qt5::Widgets
        Qt5::QuickControls2
        ${ELECTRONPASS_LIB})

install(TARGETS electronpass
        DESTINATION ${BIN_INSTALL_DIR})
