# file(GLOB_RECURSE SOURCES *.cpp *.hpp electronpass.qrc "qml/*.qml")
set(SOURCES
        main.cpp
        action_handler.cpp
        electronpass.qrc
        qml/ItemDetails.qml
        qml/ItemsList.qml
        qml/main.qml)

add_executable(electronpass ${SOURCES})
target_link_libraries(electronpass
        Qt5::Core
        Qt5::Qml
        Qt5::Quick
        Qt5::Widgets
        Qt5::QuickControls2)

install(TARGETS electronpass
        DESTINATION ${BIN_INSTALL_DIR})