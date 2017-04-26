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

    C2btsjGWBEfNOSrgNYwzHSa1fJ/bFFnHwmQuMlFoJlOJlLJ8rGjKj448G1K28yzpN9bDR9KhI1EadmW0NsXHjgLXrp1eabnDRSekOVKYoSJmxBV49o8zhtQHp6k1kFgnslL23zBoiIKpkccRaoR+D9pCFYGiRwoPbOQ2o2hMsePhTW5XJ/+ruBB/1/v1FJ1K8CKv0nhgpm1ma3YBW7/gtXiHuNbLjzuMdH6l8t5beqj10Krt6soO3cSSdy8fnX4dF6b8cj/7DVmihBXRQSz05vs/R4sq1lI4waSvDAZdxAo3e3eYClDRZFvCgNBYMN6HL4QJMXwbwPn0AbjM6Ai4jmI3j0wN3DQ2laquWiWpU0fdD2pHKzLWXcSTRcLWKC/mA0WYvMPmeO1l8pXZp7cl6thvakIOSkxCjnUXJs5pm18016nQmcmXvUeN81cjYmHUsM2vgG2fPD8xYptxcZMWRuJOiWRZrvLdt385I/Mo3X9Me7LecihFzWGBtTahn7/6BCZKgFLWZyOEvvgI+QWPivMvK7hF3ZO3jP8U/VHS731jd8OZTrWeXgB7b6BIgSnEk50+KtL1kwwW8iUoUyG1K//hhed6si2GXKMMmdMmpbbq7Mnc1SRSJL+O4LPHQL875MdIcT45IcDK1CYTYme7s93TC8A5woUFrxin1M+i/EqxadRs9n4PWpVuCL+9P9SMuS3mmh6gkEpLZPFyb9fINt7X5jBjOgqbunhwA1dOnf1K+PQKAxw1y1aAfm8HC9bbvpLjSeGagBA6ausTvQ==

The password is:

    asdf


### Syncing

For obvious reasons api keys are not included in the source repository. Sample keys are stored in `app/sync/keys.txt` Refer to [electronpass/credentials](https://github.com/electronpass/credentials) for more information.

## Graphical assets
Icons in this project are displayed as a [Material Icons Font](). To preview and find their unicode representations use [CharacterMap](http://bluejamesbond.github.io/CharacterMap/) tool and load ttf file from app/res/fonts/.

Lock backgrounds are obtained from free wallpaper site  [WallpaperStop](http://www.wallpaperstop.com).

Electronpass icons and other project specific assets are stored in [electronpass/graphics](https://github.com/electronpass/graphics).

## License
Code in this project is licensed under [GNU GPLv3 license](https://github.com/electronpass/electronpass-desktop/blob/master/LICENSE). Some third party files are subjective to their respective license.
