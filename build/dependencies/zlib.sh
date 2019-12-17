#!/bin/sh

fetchSource zlib https://github.com/madler/zlib/archive/v${VERSION_ZLIB}.tar.gz
export JSON_VERSIONS="${JSON_VERSIONS}, \"${DEP_NAME}\": \"${VERSION_ZLIB}\""

if [ ! -f "configured.sts" ]; then
    printf "\tConfiguring\n"
    ./configure \
        --prefix=${TARGET} \
        --uname=linux >> ${BUILD_LOGS}/${DEP_NAME}.config.log 2>&1
    touch configured.sts
else
    printf "\tAlready Configured\n"
fi

if [ ! -f "made.sts" ]; then
    printf "\tBuilding\n"
    make install    >> ${BUILD_LOGS}/${DEP_NAME}.make.log 2>&1
    rm ${TARGET}/lib/libz.a
    touch made.sts
else
	printf "\tAlready Built\n"
fi
