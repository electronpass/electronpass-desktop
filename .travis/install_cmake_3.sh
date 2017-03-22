#!/usr/bin/env bash
DEPS_DIR="${TRAVIS_BUILD_DIR}/deps"
mkdir -p ${DEPS_DIR} && cd ${DEPS_DIR}

if [[ "${TRAVIS_OS_NAME}" == "linux" ]]; then
    CMAKE_URL="https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz"
    mkdir cmake && wget --no-check-certificate --quiet -O - ${CMAKE_URL} | tar --strip-components=1 -xz -C cmake
    export PATH=${DEPS_DIR}/cmake/bin:${PATH}
else
    brew upgrade cmake || brew install cmake
fi