# ElectronPass
[![Build Status](https://travis-ci.org/electronpass/electronpass-desktop.svg?branch=develop)](https://travis-ci.org/electronpass/electronpass-desktop)

Desktop client written in qml.

## Dependencies

- [libelectronpass-cpp](https://github.com/electronpass/libelectronpass) Library for working with data
- [jsoncpp v1.8.0](https://github.com/open-source-parsers/jsoncpp) JSON library, already included in libelectronpass-cpp
- [crypto++](https://www.cryptopp.com/) Crypto library, dependency of libelectronpass-cpp
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

### Note
**Binaries are probably not working. We are trying to work on that when we have spare time.**

#### Releases

You can download pre-build binaries from [releases](https://github.com/electronpass/electronpass-desktop/releases) page of this repository.

There is also a **Arch Linux repository** along with instructions for using it available [here](https://github.com/electronpass/arch-packages).

#### Development

If you want to try latest features, you can go to the latest travis build and select one of the logs. At the bottom of the travis log, there is a curl command which uploads the binary to transfer.sh and outputs the download link. There are 3 different binaries (and 3 different links): AppImage, .deb and .rpm. All three have the needed qt dependencies and libelectronpass bundled in them.

## Building
The following instructions are for Unix/Linux systems. If you want to build on Windows look at [Building for Windows](https://github.com/electronpass/electronpass-desktop/blob/develop/Build-Win.md)

Before building you need to configure dependencies and fill out the api keys for syncing. Look at the syncing section for more information.

You can build the app the hard way or the easy way. For Unix/Linux systems we have provided a build script `build.sh`. This is the easy way that outputs executable in `bin/electronpass`. **Note:** api keys need to be configured before running the script.

The hard way is building it manually. You first need to download and build `libelectronpass-cpp` and `crypto++` as described in the next section. Than you build it with cmake, described in the Compiling section.

### Configure dependencies
You can download, compile and move dependencies to correct directories with a `install-dependencies.sh` script, or you can do it by hand.

#### Crypto++
Crypto library needed for libelectronpass-cpp. Build script for it is provided in libelectronpass-cpp [repository](https://github.com/electronpass/libelectronpass-cpp/tree/develop). You can build it manually and put the headers in ```dependencies/cryptopp``` and static library to ```dependencies/libcryptopp.a```.

#### Libelectronpass-cpp
Libelectronpass is required for this application to work. It will be statically linked. You can build it manually, by going to [its repository](https://github.com/electronpass/libelectronpass-cpp/) and following the build instructions (be careful to use develop branch). Then copy the header from libelectronpass files to ```libelectronpass/electronpass/```, and the static library to ```libelectronpass/libelectronpass.a```.

### Compiling
After you have configured the api keys, and compiled and moved the dependencies in the correct directories you can build the app with the following commands.

```bash
mkdir build; cd build
cmake ..
make electronpass -j8
```

You can also use `qmake` which is for now experimental and only recommended for windows. To build with qmake use the following commands
```bash
mkdir build; cd build
qmake -makefile ../electronpass.pro
make -j8
```

### Syncing
For obvious reasons api keys are not included in the source repository. Copy `app/sync/keys.default.hpp` to `app/sync/keys.hpp` and change the keys inside the file. Refer to [electronpass/credentials](https://github.com/electronpass/credentials) for more information.

## Graphical assets
Icons in this project are displayed as a [Material Icons Font](). To preview and find their unicode representations use [CharacterMap](http://bluejamesbond.github.io/CharacterMap/) tool and load ttf file from app/res/fonts/.

Lock backgrounds are obtained from free wallpaper site  [WallpaperStop](http://www.wallpaperstop.com).

Electronpass icons and other project specific assets are stored in [electronpass/graphics](https://github.com/electronpass/graphics).

## License
Code in this project is licensed under [GNU GPLv3 license](https://github.com/electronpass/electronpass-desktop/blob/master/LICENSE). Some third party files are subjective to their respective license.
