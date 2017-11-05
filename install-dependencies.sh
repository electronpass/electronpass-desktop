#!/bin/bash

git clone -b develop --depth=1 https://github.com/electronpass/libelectronpass-cpp.git libelectronpass-build
cd libelectronpass-build
chmod +x install-cryptopp.sh
./install-cryptopp.sh
mkdir build
cd build
cmake ..
make electronpass -j4
cd ../..

mkdir dependencies
mkdir -p dependencies/electronpass
mkdir -p dependencies/cryptopp
mv libelectronpass-build/include/* dependencies/electronpass/
mv libelectronpass-build/cryptopp/cryptopp/* dependencies/cryptopp/
mv libelectronpass-build/lib/libelectronpass.a dependencies/libelectronpass.a
mv libelectronpass-build/cryptopp/libcryptopp.a dependencies/libcryptopp.a

rm -rf libelectronpass-build
