# Building on Windows

This instructions will help you build electronpass-desktop on Windows. If you have any issues, feel free to submit an issue, but it is not likely we will be able to help, since we don't use Windows regularly.

NOTE: This is currently a work in progress.

We will be building using:
- Qt Creator (everything will be compiled using Qt Creator for consistency)
- mingw 32-bit
- CMake

After each step, close and open Qt Creator, to have a clean environment.

### Installing Qt
First, head over to [qt.io](https://www.qt.io/download-open-source/) and download the latest Qt installer. Launch it and install whatever you want, but the setup we will use is:
- Tools > Qt Creator
- Tools > Mingw 5.3 (any other version should be OK too)
- Tools > Qt Installer Framework
- Qt 5.8 > all relevant 32-bit environments
- Qt 5.8 > Mingw 5.3
- Qt 5.8 > basic Qt packages (you can remove QtWebKit, Charts, etc.)
- maybe something obvious I forgot to add

Then launch Qt Creator and try to build any qtquickcontrols2 example. This should work out of the box, but just to be sure.

### Installing CMake
Go to the [CMake website](https://cmake.org/download/), download (.msi installer is a good choice) and install CMake. Then go to `Qt Creator > Options > Kits > Mingw something whatever 32-bit > CMake` and set path to your CMake installation.

### Installing ECM
ECM or extra-cmake-modules is a set of CMake modules that electronpass-desktop uses to find packages and install itself. We will compile it from source:
- clone [KDE/extra-cmake-modules](https://github.com/KDE/extra-cmake-modules)
- run Qt Creator as administrator (it needs permissions for installing ECM)
- Qt Creator > Open > `<ECM_dir>/CMakeLists.txt`
- Qt Creator > Projects > Build & Run > Desktop Qt 5.8 MinGW 32-bit > Run > Add Deploy Step > `mingw32-make.exe install` (you might need to specify the ful `mingw32-make.exe` path which is `<your_qt_home>/Tools/mingw530_32/bin/mingw32-make.exe`)
- right click on your project under Edit tab > Run CMake
- click the run button in the left bottom corner

This should leave you with properly installed ECM, but of course keep track of the CMake, build, and install logs. ECM should be installed at `C:/Program Files (x86)/ECM`.

### Installing libsodium
We don't actually have to install libsodium, just download the right binaries and remember where we put them. Go to [libsodium](https://download.libsodium.org/libsodium/releases/) website and download the latest `libsodium-<version>-mingw.tar.gz`. You will then need [7zip](http://www.7-zip.org) or any other such tool to unzip it and untar it (yes, it takes 7zip 2 steps to do that).

### Installing libelectronpass (can also be downloaded from libelectronpass releases on GitHub)
- clone [electronpass/libelectronpass](https://github.com/electronpass/libelectronpass)
- Qt Creator > Open > `<libelectronpass_dir>/CMakeLists.txt`
- edit CMakeLists.txt as follows:
  - comment out lines:

        # find_package(sodium REQUIRED)
        # include_directories(include jsoncpp ${sodium_INCLUDE_DIR})

  - add the following lines:

        include_directories(include jsoncpp)
        include_directories(<path_to_libsodium>\\libsodium-win32\\include)
        link_directories(<path_to_libsodium>\\libsodium-win32\\lib)

      This will help CMake find sodium, as Findsodium.cmake doesn't work just as it should even when providing sodium_DIR variable. (And I have no intention to fix it.)
  - Qt Creator > Projects > Build & Run > Desktop Qt 5.8 MinGW 32-bit > Build > add CMake variable `CMAKE_INSTALL_PREFIX` and set it to wherever you want to install it. Later on we will reffer to this location as `<libelectronpass_install_dir>`
  - Qt Creator > Projects > Build & Run > Desktop Qt 5.8 MinGW 32-bit > Run > Add Deploy Step > Custom Deploy Step > `mingw32-make.exe install` (you might need to specify the ful `mingw32-make.exe` path which is `<your_qt_home>/Tools/mingw530_32/bin/mingw32-make.exe`)
  - right click on your project under Edit tab > Run CMake
  - Qt Creator > Projects > Build & Run > Desktop Qt 5.8 MinGW 32-bit > Build > Add Build Step > Build > check crypto_example (and no other target. Also don't try to do everything in one build step, because Qt Creator GUI is dumb.)
  - click the run button in the left bottom corner

Now we should have:
  - `bin/libelectronpass.dll`
  - `bin/crypto_example.exe`
  - `lib/libelectronpass.dll.a`

Open bin folder in explorer and try to run crypto_example. This shouldn't work because of the missing dlls. Go to <your_qt_installation>, search for each one, and copy-paste it in the bin folder (windeployqt.exe should do something like that but I haven't tested it yet.). Now the example should work.

### Building electronpass-desktop
- clone [electronpass/electronpass-desktop](https://github.com/electronpass/electronpass-desktop)
- Qt Creator > Open > `<electronpass-desktop_dir>/CMakeLists.txt`
- CMake should find ECM right away, the problem is libelectronpass. Change lines directly under `#find libelectronpass` comment to:

        SET(CMAKE_FIND_LIBRARY_SUFFIXES ".dll")
        find_library(ELECTRONPASS_LIB electronpass PATHS <libelectronpass_install_dir>/bin)
        find_path(ELECTRONPASS_INCLUDE electronpass)
        include_directories(<libelectronpass_install_dir>/include)
        include_directories(<path_to_libsodium>/libsodium-win32/include)

    This should do the trick. Enjoy!

### Steps to follow:
- running windeployqt to copy all the libs
- creating an installer either using Qt Installer Framework, InnoSetup, or writing our own installer
