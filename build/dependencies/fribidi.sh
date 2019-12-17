#!/bin/sh

fetchSource fribidi https://github.com/fribidi/fribidi/archive/v${VERSION_FRIBIDI}.tar.gz
export JSON_VERSIONS="${JSON_VERSIONS}, \"${DEP_NAME}\": \"${VERSION_FRIBIDI}\""

if [ ! -f "configured.sts" ]; then
    printf "\tConfiguring\n"
	autoreconf -fiv >> ${BUILD_LOGS}/${DEP_NAME}.autoreconf.log 2>&1
    ./configure  \
        --prefix=${TARGET} \
        --enable-shared \
        --disable-static >> ${BUILD_LOGS}/${DEP_NAME}.config.log 2>&1
    touch configured.sts
else
    printf "\tAlready Configured\n"
fi
if [ ! -f "made.sts" ]; then
    printf "\tBuilding\n"
    make install   >> ${BUILD_LOGS}/${DEP_NAME}.make.log 2>&1
    touch made.sts
else
	printf "\tAlready Built\n"
fi
