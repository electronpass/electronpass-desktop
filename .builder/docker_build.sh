#!/bin/bash

# clone sources
git clone https://github.com/electronpass/electronpass-desktop.git
git clone https://github.com/electronpass/credentials.git

# setup API keys
cp electronpass-desktop/app/sync/keys.default.hpp electronpass-desktop/app/sync/keys.hpp
python3 credentials/configure.py credentials/keys.json.asc ${keys_encryption_password} electronpass-desktop/app/sync/keys.hpp

# chmod and build
cd electronpass-desktop
chmod +x install-dependencies.sh
chmod +x build.sh
./build.sh

# configure fuse
apt-get install -y fuse # if not yet installed
modprobe fuse
user="$(whoami)"
usermod -a -G fuse $user

# create package
chmod +x create-linux-appimage.sh
./create-linux-appimage.sh
mkdir upload
mv ElectronPass*.AppImage upload

# upload to github releases (many thanks to https://github.com/probonopd)
wget -c https://github.com/probonopd/uploadtool/raw/master/upload.sh
bash ./upload.sh upload/*
curl --upload-file ./upload/* https://transfer.sh
