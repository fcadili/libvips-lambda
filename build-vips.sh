#!/bin/sh
function help {
	echo
	echo "Usage: $0 -v VERSION [-d] [-k] [-c]"
	echo "Build shared libraries for libvips and its dependencies via containers"
	echo
	echo "Please specify the libvips VERSION, e.g. 8.7.0"
	echo "Add -d as parameter to enable bash debugging"
	echo "Add an extra -k parameter to avoid recompilation of freetype and fontconfig libraries. Usually this parameter is not given."
	echo "Use -c to rebuild all libraries."
	echo
}

if [ $# -lt 1 ]
then
	help
	exit -1
fi
set -e

VERSION_VIPS=
RUNMODE=release
KEEPALL=none
REBUILD=false
while [ $# != 0 ]
do
    case $1 in
    -v) VERSION_VIPS="$2"; shift
        ;;
    -d) RUNMODE=debug
        ;;
	-k) KEEPALL=keepall
		;;
	-c) REBUILD=true
		;;
	-h)
		help
		exit 1
    esac
    shift
done

if [ -z "$VERSION_VIPS" ]
then
	VERSION_VIPS=8.7.0
fi
echo "libvips version: ${VERSION_VIPS}"

if [ "$REBUILD" == true ]
then
	KEEPALL=
	if [ -d "var/task" ]
	then
		rm -rf "var/task"
	fi
	# remove freetype and fontconfig
	if [ -d "deps/freetype" ]
	then
		rm -rf "deps/freetype"
	fi
	if [ -d "deps/fontconfig" ]
	then
		rm -rf "deps/fontconfig"
	fi
	
	# Bug?
	#if [ -d "deps/icu" ]
	#then
	#	rm -rf "deps/icu"
	#fi
	
	# force relink
	find deps -name made.sts -exec rm {} \;
fi

# Is docker available?
if ! type docker >/dev/null; then
  echo "Please install docker"
  exit 1
fi

echo "Building ..."

docker build -t dev-lambda amazonlinux
docker run --rm=false -e "VERSION_VIPS=${VERSION_VIPS}" -v $PWD:/packaging dev-lambda sh -c "/packaging/build/vips.sh $RUNMODE $KEEPALL"
