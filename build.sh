#!/bin/bash
./install-dependencies.sh
if [ ! -e "build" ]
then
    mkdir build
fi

sync=true
if [ ! -e "app/sync/keys.hpp" ]
then
    echo "WARNING: app/sync/keys.hpp missing. Creating placeholder file with invalid api keys (syncing will not work). Read the Syncing section in README.md to learn how to provide valid api keys and make the syncing work."

     cp app/sync/keys.default.hpp app/sync/keys.hpp
     sync=false
fi

cd build
qmake -makefile ../electronpass.pro
make -j4

if [ $sync == false ]
then
    echo "WARNING: app/sync/keys.hpp missing. The script has created a placeholder file with invalid api keys (syncing will not work). Read the Syncing section in README.md to learn how to provide valid api keys and make the syncing work."
fi
