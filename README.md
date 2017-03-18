# ElectronPass
Desktop client written in qml.

## Dependencies
Qt >= 5.8.0 with at least the following modules is required:
- [qtbase](http://code.qt.io/cgit/qt/qtbase.git)
- [qtdeclarative](http://code.qt.io/cgit/qt/qtdeclarative.git)
- [qtquickcontrols2](http://code.qt.io/cgit/qt/qtquickcontrols2.git)
- [qttools](http://code.qt.io/cgit/qt/qttools.git/)

To install all dependencies:
- on Arch Linux:
```sudo pacman -S qt5-default qt5-declarative qt5-quickcontrols2```
- on Ubuntu: 
```sudo apt-get install qt5-default```

## Building

    mkdir build; cd build
    cmake ..
    make electronpass -j8


## License
Code in this project is licensed under [GNU GPLv3 license](https://github.com/electronpass/electronpass-desktop/blob/master/LICENSE). Some third party files are subjective to their respective license.