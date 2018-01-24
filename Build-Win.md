# Building on Windows
## Disclaimer
Building for Windows is a lot of work. This will look like the ninth circle of Dante's Inferno. In fact, this is so bodged together, that I wouldn't want to use programs compiled this way on my electric toothbrush. But Windows users are already using Windows, so how much worse can it get? If you know a better way to compile this **please** create a pull request.

## Dependencies
Before we get started we need to have some things installed. Two main things are:
- [Visual studio with c++ support](https://www.visualstudio.com/)
- [Qt](https://www1.qt.io/download-open-source/) **Note:** when installing you have to select `msvc2015 32bit`. Other packages are optional and you can leave the default selected.
- [CMake](https://cmake.org/)
- [git](https://git-scm.com/)

If you are thinking to yourself: Why 32bit? Because literally no-one compiles 64bit for windows. If you think that this is barbaric: you are right.

## Crypto++
First download cyrpto++ from [their website](https://www.cryptopp.com/#download). After that unzip it, and then also unzip `vs2005.zip`. Open `cryptest.sln` with visual studio. Before building select `Release` configuration on top and select `Win32` option if not already selected (in the middle of second toolbar, left of the run button).

Right click on `cryptest` in solution explorer and select properties. Be careful that you are in Release configuration, then under C/C++ > Code Generation change runtime library from `/MT` to `/MD`. You can now close the properties window.

Right click on `cryptlib`, select properties and change the runtime library to `MD` like you did for the cyrptest.

Now you can right click on the `cryptest` and select build. If you had some luck, you have successfully build crypto++ library. It is located in `cryptopp_folder/Win32/Output/Release/cryptlib.lib`.

If build was not successful, you may need to retarget project to installed Windows SDK (or manually download additional SDKs). Right click on `cryptest` and select retarget projects. Select installed SDK and confirm. Repeat the same for `cryptlib` and try building again.

## libelectronpass
Download libelectronpass-cpp from [github](https://github.com/electronpass/libelectronpass-cpp/tree/develop) (be sure you are on develop branch). Inside the libelectronpass folder create a new folder called `cryptopp`. Inside this folder create a folder called `cryptopp` and copy all the header files (`*.h`) from cryptopp folder to this folder. Then you can copy the cryptlib.lib to the first cryptopp folder if you want to build the tests. We won't cover that however. You should have something like this:
- `libelectronpass-cpp/cryptopp/cryptlib.lib` (optional)
- `libelectronpass-cpp/cryptopp/cryptopp/*cryptoppp_headers*`

Now you can create a build folder `libelectronpass-cpp/build`. The easiest way to run cmake is using git shell. Move to build directory and execute `cmake ..`. Keep your fingers crossed for cmake. Hopefully you will find Visual Studio solution file in your build folder. Open it. Or not. You can still rage quit. Make sure you are using release configuration, then right click on `electronpass` and press build. With some luck you should have `libelectronpass-cpp/lib/Release/electronpass.lib` library.

## The Desktop Application
First I have to congratulate you for coming this far. Now that is out of the way, lets begin by downloading electronpass-desktop from [github](https://github.com/electronpass/electronpass-desktop/tree/develop) (again make sure you are on develop branch). Inside `electronpass-desktop` create new folder called `dependencies`. Copy cryptlib.lib and electronpass.lib in here. Then create two additional folders in dependencies folder: `cryptopp` and `electronpass`. Inside cryptopp copy the crypto++ header files (like you did for libelectronpass). Inside electronpass copy the libelectronpass header files located in `libelectronpass-cpp/include`. While you are at it, also create a `build` folder (you will need it later). You should have the following folders and files:
- `electronpass-desktop/dependencies/cryptopp`
- `electronpass-desktop/dependencies/electronpass`
- `electronpass-desktop/dependencies/electronpass.lib`
- `electronpass-desktop/dependencies/cryplib.lib`
- `electronpass-desktop/build` (we will need it later)

Change the build configuration in `electronpass.pro` file a little bit (open it with notepad). At the end of the file change the `LIBS` parameter to use `cryplib.lib` and `electronpass.lib` instead of `libcryptopp.a` and `libelectronpass.a`.

Now we have to configre the PATH so that it has Qt tools in it. Open the system setting in control panel > System and security > System and clik on `Advanced system settings`. Under the advanced tab click `Environment variables`. Select `PATH` and click `Edit`. Click `New` and paste in the path to your qt installation. It should look something like this `C:\Qt\5.9.2\msvc2015\bin`. `5.9.2` is the Qt version and yours can be different. Help yourself with the file explorer. You can now click OK and close the control panel.

Next we need to setup command line tools for the console. Visual studio comes with a script that does that for us, however it only works for that console. That means that when we close the console window, everything that the script has set up is reverted and you have to run it again. Open CMD (PowerShell won't work) and with command `cd` navigate to `C:\Program Files (x86)\ Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build` and run `vcvarsall.bat x86`. Navigate to the build folder you created earlier **from the same console window**. Write the command `qmake -tp vc ../electronpass.pro`.

Open the visual studio files the command has produced. Change your configuration to release, right click on the electronpass and click build. If you get errors about windows sdk right click on the `Solution 'electronpass'` and select `retarget solution`. Click ok, and try building electronpass again. Executable should be located in `electronpass-desktop/bin/release/electronpass`. If it's not try `electronpass/build/release`.

You can now create a new folder that is going to have electronpass executable and all the qt libraries that it depends on. You can share this folder to anyone, even if he doesn't have Qt installed. We are going to name this folder `electronpass-distributable`. Copy `electronpass.exe` into `electronpass-distributable`. Open CMD or PowerShell and navigate to this directory. the type in `windeployqt electronpass.exe -qmldir app/qml`. You should now have all the qt dlls necessary to run electronpass anywhere.
