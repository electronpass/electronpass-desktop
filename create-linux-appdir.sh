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
if [ ! -e "linuxdeployqt-continuous-x86_64.AppImage" ]
then
  wget "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
  chmod a+x linuxdeployqt-continuous-x86_64.AppImage
fi

unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
export VERSION=$(git rev-parse --short HEAD) # linuxdeployqt uses this for naming the file
./linuxdeployqt-continuous-x86_64.AppImage appdir/usr/local/share/applications/electronpass.desktop -bundle-non-qt-libs -qmldir=$root_path/app/qml/
