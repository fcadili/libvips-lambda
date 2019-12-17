#!/bin/sh

fetchSource icu https://github.com/unicode-org/icu/releases/download/release-${VERSION_ICU//./-}/icu4c-${VERSION_ICU//./_}-src.tgz
export JSON_VERSIONS="${JSON_VERSIONS}, \"${DEP_NAME}\": \"${VERSION_ICU}\""

cd source
if [ ! -f "configured.sts" ]; then
    printf "\tConfiguring\n"
    ./runConfigureICU Linux \
		--prefix=${TARGET} \
		--enable-shared=yes \
		--with-library-bits=64 \
		--disable-static >> ${BUILD_LOGS}/${DEP_NAME}.config.log 2>&1
    touch configured.sts
else
    printf "\tAlready Configured\n"
fi
if [ ! -f "made.sts" ]; then
    printf "\tBuilding\n"
    if [ -f tools/gencolusb/Makefile ] ; then
		echo "Fixing tools/gencolusb/Makefile"
		sed -i -e 's/-licuuc -licui18n -licudata/-licudata -licuuc -licui18n/g' tools/gencolusb/Makefile
    fi
    make install   >> ${BUILD_LOGS}/${DEP_NAME}.make.log 2>&1
    touch made.sts
else
	printf "\tAlready Built\n"
fi
