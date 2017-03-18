file(GLOB_RECURSE SOURCES *.cpp *.hpp asdf.qrc "qml/*.qml")

add_executable(asdf ${SOURCES} ActionHandler.cpp ActionHandler.hpp)
target_link_libraries(asdf
        Qt5::Core
        Qt5::Qml
        Qt5::Quick
        Qt5::Widgets
        Qt5::QuickControls2)