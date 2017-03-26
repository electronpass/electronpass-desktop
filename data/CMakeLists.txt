install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/electronpass.desktop"
        DESTINATION ${XDG_APPS_INSTALL_DIR})
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/electronpass.svg"
        DESTINATION share/icons/hicolor/scalable/apps/)
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/electronpass.appdata.xml"
        DESTINATION ${DATA_INSTALL_DIR}/appdata)