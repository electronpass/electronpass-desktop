file(GLOB_RECURSE SOURCES *.cpp *.hpp electronpass.qrc "qml/*.qml")

add_executable(electronpass ${SOURCES})
target_link_libraries(electronpass
        Qt5::Core
        Qt5::Qml
        Qt5::Quick
        Qt5::Widgets
        Qt5::QuickControls2)