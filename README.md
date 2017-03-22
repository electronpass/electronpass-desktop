# ElectronPass
[![Build Status](https://travis-ci.org/electronpass/electronpass-desktop.svg?branch=master)](https://travis-ci.org/electronpass/electronpass-desktop)

Desktop client written in qml.

## Dependencies
Qt >= 5.8.0 with at least the following modules is required:
- [qtbase](http://code.qt.io/cgit/qt/qtbase.git)
- [qtdeclarative](http://code.qt.io/cgit/qt/qtdeclarative.git)
- [qtquickcontrols2](http://code.qt.io/cgit/qt/qtquickcontrols2.git)
- [qttools](http://code.qt.io/cgit/qt/qttools.git/)

[Extra CMake modules (>=1.7.0)](https://github.com/KDE/extra-cmake-modules) is required for building the project.

To install all dependencies on Arch Linux:

    sudo pacman -S qt5-base qt5-declarative qt5-quickcontrols2

Installation on Ubuntu is harder, since it doesn't have Qt 5.8 in its repos.

1. Download and install Qt from their [downloads page](https://www.qt.io/download/).
2. Add to your ```PATH``` ```bin``` folder of your installation. For instance if you have Qt installed in ```/opt/Qt``` you should add to your ```PATH``` the following: ```/opt/Qt/5.8/clang_64/bin``` where ```clang_64``` might be something else.

## Building

    mkdir build; cd build
    cmake ..
    make electronpass -j8
    # optionally install electronpass
    sudo make install
 
Additional Ubuntu note: You might have to execute the binary from terminal.

## License
Code in this project is licensed under [GNU GPLv3 license](https://github.com/electronpass/electronpass-desktop/blob/master/LICENSE). Some third party files are subjective to their respective license.
