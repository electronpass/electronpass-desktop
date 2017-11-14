#!/bin/bash
file=appdir/usr/local
root_path=$(pwd)
if [ ! -e "$file" ]
then
  mkdir -p $file
  mkdir -p $file/share/applications
  mkdir -p $file/bin
fi

cp bin/electronpass $file/bin
cp data/electronpass.desktop $file/share/applications
cp data/electronpass.svg $file/share/applications
cd $file/bin
if [ ! -e "linuxdeployqt-continuous-x86_64.AppImage" ]
then
  wget "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
  chmod a+x linuxdeployqt-continuous-x86_64.AppImage
fi
unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
./linuxdeployqt-continuous-x86_64.AppImage ../share/applications/electronpass.desktop -bundle-non-qt-libs -qmldir=$root_path/app/qml/
./linuxdeployqt-continuous-x86_64.AppImage ../share/applications/electronpass.desktop -appimage -qmldir=$root_path/app/qml/
cp $root_path/$file/bin/ElectronPass-x86_64.AppImage $root_path
