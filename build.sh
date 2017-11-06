#!/bin/bash
./install-dependencies.sh
mkdir build
cd build
cmake ..
make electronpass
