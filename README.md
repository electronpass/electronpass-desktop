# ElectronPass
[![Build Status](https://travis-ci.org/electronpass/electronpass-desktop.svg?branch=develop)](https://travis-ci.org/electronpass/electronpass-desktop)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/electronpass/electronpass-desktop)](https://ci.appveyor.com/project/electronpass/electronpass-desktop)

Desktop client written in qml.

# Dependencies

- [libelectronpass-cpp](https://github.com/electronpass/libelectronpass) Library for working with data
- [jsoncpp v1.8.0](https://github.com/open-source-parsers/jsoncpp) JSON library, already included in libelectronpass-cpp
- [crypto++](https://www.cryptopp.com/) Crypto library, dependency of libelectronpass-cpp
- Qt >= 5.8.0 with at least the following modules is required:
    - [qtbase](http://code.qt.io/cgit/qt/qtbase.git)
    - [qtdeclarative](http://code.qt.io/cgit/qt/qtdeclarative.git)
    - [qtquickcontrols2](http://code.qt.io/cgit/qt/qtquickcontrols2.git)
    - [qtquickcontrols](http://code.qt.io/cgit/qt/qtquickcontrols.git)
    - [qttools](http://code.qt.io/cgit/qt/qttools.git/)

To install all dependencies on Arch Linux:
```
sudo pacman -S qt5-base qt5-declarative qt5-quickcontrols qt5-quickcontrols2
```
Installation on Ubuntu is harder, since it doesn't have Qt 5.8 in its repos (yet).

1. Download and install Qt from their [downloads page](https://www.qt.io/download/).
2. Add to your ```PATH``` ```bin``` folder of your installation. For instance if you have Qt installed in ```/opt/Qt``` you should add to your ```PATH``` the following: ```/opt/Qt/5.8/clang_64/bin``` where ```clang_64``` might be something else.

# Downloading binaries

## Note
Binaries are not working.That's because travis does not like us... We are trying to fix it...

### Releases

You can download pre-build binaries from [releases](https://github.com/electronpass/electronpass-desktop/releases) page of this repository.

There is also a **Arch Linux repository** along with instructions for using it available [here](https://github.com/electronpass/arch-packages).

### Development

If you want to try latest features, you can download the current AppImage from continuous release build.

# Building
The following instructions are for Unix/Linux systems. If you want to build on Windows look at [Building for Windows](https://github.com/electronpass/electronpass-desktop/blob/develop/Build-Win.md)

Before building you need to configure dependencies and fill out the api keys for syncing. Look at the syncing section for more information.

You can build the app the hard way or the easy way. For Unix/Linux systems we have provided a build script `build.sh`. This is the easy way that outputs executable in `bin/electronpass`.

The hard way is building it manually. You first need to download and build `libelectronpass-cpp` and `crypto++` as described in the next section. Then setup the api keys for syncing and finally build it with cmake or qmake (prefered), described in the Compiling section.

For linux we also provide `create-linux-appimage.sh` script, that will create an AppImage after you have build electronpass.

On mac you can create .app file with all the dependencies bundled with it, so you can redistribute it to your friends. Read more on it in Deploying section

## Configure dependencies
You can download, compile and move dependencies to correct directories with a `install-dependencies.sh` script, or you can do it by hand.

### Crypto++
Crypto library needed for libelectronpass-cpp. Build script for it is provided in libelectronpass-cpp [repository](https://github.com/electronpass/libelectronpass-cpp/tree/develop). You can build it manually and put the headers in ```dependencies/cryptopp``` and static library to ```dependencies/libcryptopp.a```.

### Libelectronpass-cpp
Libelectronpass is required for this application to work. It will be statically linked. You can build it manually, by going to [its repository](https://github.com/electronpass/libelectronpass-cpp/) and following the build instructions (be careful to use develop branch). Then copy the header from libelectronpass files to ```libelectronpass/electronpass/```, and the static library to ```libelectronpass/libelectronpass.a```.

## Configre syncing
For obvious reasons api keys for google drive and dropbox are not included in the source repository. Copy `app/sync/keys.default.hpp` to `app/sync/keys.hpp` and change the keys inside the file. Refer to [electronpass/credentials](https://github.com/electronpass/credentials) for more information.

## Compiling
After you have configured the api keys, and compiled and moved the dependencies in the correct directories you can build the app with qmake with the following commands.

```bash
mkdir build; cd build
qmake -makefile ../electronpass.pro
make -j8
```

You can also use `cmake`, which is now deprecated, but if qmake doesn't work, try with cmake. Cmake doesn't have install command and is here primarily for development purposes (we are using CLion).
```bash
mkdir build; cd build
cmake ..
make electronpass -j8
```

## Deploying

You can deploy the built binary on the mac and linux. We are still working on the building for windows, so we are quite far away from windows deployment (if you know have experience on windows we would appreciate your help).

### Linux
For linux you can package the application into an AppImage. If you don't know what those are, you can read more on them [here](https://appimage.org/). To build it run the `create-linux-appimage.sh` script. This will create appimage with the help of [`linuxdeployqt`](https://github.com/probonopd/linuxdeployqt), which is a really cool tool that a really cool guy has made. `ElectronPass-x86_64.AppImage` will be built in the `appdir` directory (the script will make it automatically), and than copied to `electronpass-desktop` directory. `linuxdeployqt` will be downloaded automatically.

### Mac
Qt already provides deploy tool for mac. To create self contained .app run:
```bash
cd bin
macdeployqt electronpass.app/ -qmldir=../app/qml/
```
`bin/electronpass.app` now has all the needed dependencies in it, so you can run it on any mac.

# Graphical assets
Icons in this project are displayed as a [Material Icons Font](). To preview and find their unicode representations use [CharacterMap](http://bluejamesbond.github.io/CharacterMap/) tool and load ttf file from app/res/fonts/.

Lock backgrounds are obtained from free wallpaper site  [WallpaperStop](http://www.wallpaperstop.com).

Electronpass icons and other project specific assets are stored in [electronpass/graphics](https://github.com/electronpass/graphics).

# License
Code in this project is licensed under [GNU GPLv3 license](https://github.com/electronpass/electronpass-desktop/blob/master/LICENSE). Some third party files are subjective to their respective license.
