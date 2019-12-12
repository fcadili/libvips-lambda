#!/bin/sh

fetchSource svg https://github.com/GNOME/librsvg/archive/${VERSION_SVG}.tar.gz
export JSON_VERSIONS="${JSON_VERSIONS}, \"${DEP_NAME}\": \"${VERSION_SVG}\""

if [ ! -f "configured.sts" ]; then
    printf "\tConfiguring\n"
    cp /usr/share/gtk-doc/data/gtk-doc.make .
    autoreconf -fiv >> ${BUILD_LOGS}/${DEP_NAME}.autoreconf.log 2>&1
    ./configure  \
        --prefix=${TARGET} \
        --enable-shared \
        --disable-static \
        --disable-dependency-tracking \
        --disable-introspection \
        --disable-tools \
        --disable-pixbuf-loader >> ${BUILD_LOGS}/${DEP_NAME}.config.log 2>&1
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
