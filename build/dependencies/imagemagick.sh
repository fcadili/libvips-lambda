#!/bin/sh

major=${VERSION_IMAGEMAGICK%%.*}
if [ "$major" == "6" ]
then
	fetchSource imagemagick https://github.com/ImageMagick/ImageMagick6/archive/${VERSION_IMAGEMAGICK}.tar.gz
else
	fetchSource imagemagick https://imagemagick.org/download/ImageMagick-${VERSION_IMAGEMAGICK}.tar.xz
fi
export JSON_VERSIONS="${JSON_VERSIONS}, \"${DEP_NAME}\": \"${VERSION_IMAGEMAGICK}\""

if [ ! -f "configured.sts" ]; then
    printf "\tConfiguring\n"
    #  REMOVED: --with-modules
    ./configure \
        --prefix=${TARGET} \
        --sysconfdir=${TARGET}/etc \
        --enable-hdri   \
        --with-gslib    \
        --with-rsvg     \
        --disable-static >> ${BUILD_LOGS}/${DEP_NAME}.config.log 2>&1
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
