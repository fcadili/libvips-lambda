#!/bin/sh

fetchSource glib https://github.com/GNOME/glib/archive/${VERSION_GLIB}.tar.gz
export JSON_VERSIONS="${JSON_VERSIONS}, \"${DEP_NAME}\": \"${VERSION_GLIB}\""

if [ ! -f "configured.sts" ]; then
    printf "\tConfiguring\n"

    echo glib_cv_stack_grows=no >>glib.cache
    echo glib_cv_uscore=no >>glib.cache
    cp /usr/share/gtk-doc/data/gtk-doc.make .
    autoreconf -fiv >> ${BUILD_LOGS}/${DEP_NAME}.autoreconf.log 2>&1
    ./configure \
        --cache-file=glib.cache  \
        --prefix=${TARGET} \
        --enable-shared \
        --disable-static \
        --disable-dependency-tracking \
        --with-pcre=system  >> ${BUILD_LOGS}/${DEP_NAME}.config.log 2>&1
    touch configured.sts
else
    printf "\tAlready Configured\n"
fi
if [ ! -f "made.sts" ]; then
    printf "\tBuilding\n"
    make install-strip   >> ${BUILD_LOGS}/${DEP_NAME}.make.log 2>&1
    touch made.sts
else
	printf "\tAlready Built\n"
fi
