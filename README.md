# ElectronPass
[![Build Status](https://travis-ci.org/electronpass/electronpass-desktop.svg?branch=master)](https://travis-ci.org/electronpass/electronpass-desktop)

Desktop client written in qml.

## Dependencies

- [libelectronpass](https://github.com/electronpass/libelectronpass) - core library
- Qt >= 5.8.0 with at least the following modules is required:
    - [qtbase](http://code.qt.io/cgit/qt/qtbase.git)
    - [qtdeclarative](http://code.qt.io/cgit/qt/qtdeclarative.git)
    - [qtquickcontrols2](http://code.qt.io/cgit/qt/qtquickcontrols2.git)
    - [qttools](http://code.qt.io/cgit/qt/qttools.git/)
- [Extra CMake modules (>=1.7.0)](https://github.com/KDE/extra-cmake-modules) is required for building the project.

To install all dependencies on Arch Linux:

    sudo pacman -S qt5-base qt5-declarative qt5-quickcontrols2 extra-cmake-modules

Installation on Ubuntu is harder, since it doesn't have Qt 5.8 in its repos (yet).

1. Download and install Qt from their [downloads page](https://www.qt.io/download/).
2. Add to your ```PATH``` ```bin``` folder of your installation. For instance if you have Qt installed in ```/opt/Qt``` you should add to your ```PATH``` the following: ```/opt/Qt/5.8/clang_64/bin``` where ```clang_64``` might be something else.

## Building

    mkdir build; cd build
    cmake ..
    make electronpass -j8

Optionally install ElectronPass:

    sudo make install

## Testing

### Wallet

Currently it is still impossible to set your own password and file location. Also, new file, where passwords will be stored is not automatically generated.

For testing purposes create new file in `settings.data_location` folder, which is printed out when the app is launched. On linux it should look like this (you will probably have to make `ElectronPass` folders by yourself too):

    /home/{username}/.local/share/ElectronPass/ElectronPass/electronpass.wallet

And paste this string into file (one line only!):

    VRoAPCI+Pi9blUuBkJFY5CIhbpkSe3fPB6FpaLi1n0ojvtwkUKGWf4cCQPq7SvDfMwG31Tm8Nrl6Kr2gaWklKjzJaahar7MskHrApw9b347Q4uHmbnFDcK7+2X4ZfCzl22XzrqSnJedm/6PMcjLvjLLr4rlIO8pozNj3ZIO4TXSPuPjlO8fBaNoNE8sFbXrfRktaLaVtUzHTccCh+3cukQBDNbZ4McrJ9Hw6c4NqpVaJ8iyQrYcyGJJqRZ/GVYIVAJRAZfjTYyRcxxGy6/7hBVHwP6WKZt+UP99YcnyIoJgLfGL/bMw439xVIycxDD7brLrbooBdXQiSa459VwITPv+2gKkawphNLQKHFXzorLXm8GjxFug9iQDanz+oQ/xCMkcOtV2qzsa2XSjTYTmrRXGeAHQJYju1FU0Vo0q54OF6CfQRiPeC8lb4lF74CYnhI7zM46xAHygVspio2ZIjOYFeMTGsivMxKoKxqs/DIcOPqANknhiEgGRTqQlND8mbh2PkNWG8Pc3y1NSLcTnwsJxD5sW/MfdzZXgvyj9etFkSFA==

The password is:

    asdf


### Syncing

For obvious reasons api keys are not included in the source repository. Sample keys are stored in `app/sync/keys.txt` Refer to [electronpass/credentials](https://github.com/electronpass/credentials) for more information.

## Graphical assets
Icons in this project are displayed as a [Material Icons Font](). To preview and find their unicode representations use [CharacterMap](http://bluejamesbond.github.io/CharacterMap/) tool and load ttf file from app/res/fonts/.

Lock backgrounds are obtained from free wallpaper site  [WallpaperStop](http://www.wallpaperstop.com).

## License
Code in this project is licensed under [GNU GPLv3 license](https://github.com/electronpass/electronpass-desktop/blob/master/LICENSE). Some third party files are subjective to their respective license.
