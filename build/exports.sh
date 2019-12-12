#!/bin/sh

export LOCAL_MOUNTS="/packaging"
export BUILD_LOGS="/packaging/logs"
export DEPS="${LOCAL_MOUNTS}/deps"
export TARGET="${LOCAL_MOUNTS}/var/task"

mkdir -p ${DEPS}
mkdir -p ${TARGET}
mkdir -p ${BUILD_LOGS}

# Common build paths and flags
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:${TARGET}/lib/pkgconfig"
export PKG_CONFIG=/usr/bin/pkg-config

export PATH="${TARGET}/bin:${PATH}"

export CPPFLAGS="-I${TARGET}/include"
export LDFLAGS="-L${TARGET}/lib"

export CFLAGS="${FLAGS}"
export CXXFLAGS="${FLAGS}"

export LD_LIBRARY_PATH=${TARGET}/lib

export JSON_VERSIONS="\"name\": \"version\""

# add cargo stuff...
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
