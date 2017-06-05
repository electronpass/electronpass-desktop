# ElectronPass
[![Build Status](https://travis-ci.org/electronpass/electronpass-desktop.svg?branch=release)](https://travis-ci.org/electronpass/electronpass-desktop)

Desktop client written in qml.

## Dependencies

- [libelectronpass](https://github.com/electronpass/libelectronpass) - core library
- Qt >= 5.8.0 with at least the following modules is required:
    - [qtbase](http://code.qt.io/cgit/qt/qtbase.git)
    - [qtdeclarative](http://code.qt.io/cgit/qt/qtdeclarative.git)
    - [qtquickcontrols2](http://code.qt.io/cgit/qt/qtquickcontrols2.git)
    - [qtquickcontrols](http://code.qt.io/cgit/qt/qtquickcontrols.git)
    - [qttools](http://code.qt.io/cgit/qt/qttools.git/)
- [Extra CMake modules (>=1.7.0)](https://github.com/KDE/extra-cmake-modules) is required for building the project.

To install all dependencies on Arch Linux:

    sudo pacman -S qt5-base qt5-declarative qt5-quickcontrols qt5-quickcontrols2 extra-cmake-modules

Installation on Ubuntu is harder, since it doesn't have Qt 5.8 in its repos (yet).

1. Download and install Qt from their [downloads page](https://www.qt.io/download/).
2. Add to your ```PATH``` ```bin``` folder of your installation. For instance if you have Qt installed in ```/opt/Qt``` you should add to your ```PATH``` the following: ```/opt/Qt/5.8/clang_64/bin``` where ```clang_64``` might be something else.

## Downloading binaries

#### Releases

You can download pre-build binaries from [releases](https://github.com/electronpass/electronpass-desktop/releases) page of this repository.

#### Development

If you want to try latest features, you can go to the latest travis build and select one of the logs. At the bottom of the travis log, there is a curl command which uploads the binary to transfer.sh and outputs the download link. There are 3 different binaries (and 3 different links): AppImage, .deb and .rpm. All three have the needed qt dependencies and libelectronpass bundled in them.

## Building

#### Syncing

For obvious reasons api keys are not included in the source repository. Copy `app/sync/keys.default.txt` to `app/sync/keys.txt` and change the keys inside the file. Refer to [electronpass/credentials](https://github.com/electronpass/credentials) for more information.

    cp app/sync/keys.default.txt app/sync/keys.txt
    mkdir build; cd build
    cmake ..
    make electronpass -j8

Optionally install ElectronPass:

    sudo make install


## Graphical assets
Icons in this project are displayed as a [Material Icons Font](). To preview and find their unicode representations use [CharacterMap](http://bluejamesbond.github.io/CharacterMap/) tool and load ttf file from app/res/fonts/.

Lock backgrounds are obtained from free wallpaper site  [WallpaperStop](http://www.wallpaperstop.com).

Electronpass icons and other project specific assets are stored in [electronpass/graphics](https://github.com/electronpass/graphics).

## License
Code in this project is licensed under [GNU GPLv3 license](https://github.com/electronpass/electronpass-desktop/blob/release/LICENSE). Some third party files are subjective to their respective license.
