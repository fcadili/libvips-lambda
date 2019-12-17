#!/bin/sh
set -e
RUNMODE=$1
if [ "$RUNMODE" == "debug" ]
then
    set -x
fi

pushd `dirname $0` > /dev/null
BUILDPATH=`pwd`
popd > /dev/null


# Exports and Versions
source "${BUILDPATH}/exports.sh" skip-configuration
source "${BUILDPATH}/versions.sh"

# Pull in our Functions
source "${BUILDPATH}/functions.sh"

# check distribution
if [ ! -f "/packaging/dist/libvips-${VERSION_VIPS}-lambda.tar.gz" ]
then
	prinf "Libvips distribution ${VERSION_VIPS} must be created. Use ./build-vips -v ${VERSION_VIPS}"
	exit -1
fi

# Build All Dependencies

########################################################################################################################
#
# These have no dependencies to worry about
#
########################################################################################################################

printf "sharp, version: ${VERSION_SHARP}"
build sharp

packageSharp
