cd electronpass-desktop/build
set currPath=%cd%
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
cd %currPath%
qmake -tp vc ../electronpass-win.pro
