#!/bin/bash
./install-dependencies.sh
if [ ! -e "build" ]
then
    mkdir build
fi

cd build
qmake -makefile ../electronpass.pro
make -j4
