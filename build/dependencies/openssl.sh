#!/bin/sh

fetchSource openssl https://openssl.org/source/openssl-${VERSION_OPENSSL}.tar.gz
export JSON_VERSIONS="${JSON_VERSIONS}, \"${DEP_NAME}\": \"${VERSION_OPENSSL}\""

if [ ! -f "configured.sts" ]; then
    printf "\tConfiguring\n"
    mkdir -p ${TARGET}/etc/ssl
    #sed -i 's# libcrypto.a##;s# libssl.a##' Makefile
    ./config  \
        --prefix=${TARGET}  \
         --openssldir=${TARGET}/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic >> ${BUILD_LOGS}/${DEP_NAME}.config.log 2>&1
    touch configured.sts
else
    printf "\tAlready Configured\n"
fi
if [ ! -f "made.sts" ]; then
    printf "\tBuilding\n"
    # Bug: openssl /packaging/var/task/etc/ssl/man/man3/hmac.3: Too many levels of symbolic links
    if [ -d "${TARGET}/etc/ssl/man/man3" ]
    then
		rm -rf "${TARGET}/etc/ssl/man/man3"
    fi
    # Bug *** No rule to make target `sha256t.o', needed by `sha256t'.  Stop
    # remove test directory
    if [ -d test ] ; then
		rm -rf test
	fi
    make install   >> ${BUILD_LOGS}/${DEP_NAME}.make.log 2>&1
    curl -o ${TARGET}/etc/ssl/certdata.txt https://hg.mozilla.org/releases/mozilla-release/raw-file/default/security/nss/lib/ckfw/builtins/certdata.txt >> ${BUILD_LOGS}/${DEP_NAME}.make.log 2>&1
    touch made.sts
else
	printf "\tAlready Built\n"
fi
