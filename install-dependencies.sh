#!/bin/bash

if [ -e "dependencies" ]
then
    echo "Dependencies directory already exists. Do you want to rebuild them? (y/n)"
    result=false
    while [ true ]
    do
        read answer
        if [ $answer == 'y' ]
        then
            result=true
            break
        elif [ $answer == 'n' ]
        then
            result=false
            break
        else
            echo "Answer not one of the options y/n."
        fi
    done

    if [ $result == true ]
    then
        rm -r dependencies
    else
        exit 0
    fi
fi


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
