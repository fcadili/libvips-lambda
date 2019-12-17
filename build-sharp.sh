#!/bin/sh
function help {
	echo
	echo "Usage: $0 -v VERSION -s VERSION [-d]"
	echo "Build shared libraries for sharp using libvips tar.gz. Sharp installation is checked with nodejs.10x"
	echo
	echo "Please specify the libvips VERSION, e.g. 8.7.0"
	echo "Please specify the sharp VERSION, e.g. 0.21.3"
	echo "Use -d to debug the build."
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
while [ $# != 0 ]
do
    case $1 in
    -v) VERSION_VIPS="$2"; shift
        ;;
    -d) RUNMODE=debug
        ;;
	-s) VERSION_SHARP="$2"; shift
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

if [ -z "$VERSION_SHARP" ]
then
	VERSION_SHARP=0.21.3
fi

# Is docker available?
if ! type docker >/dev/null; then
  echo "Please install docker"
  exit 1
fi

echo "Building ..."

docker build -t dev-lambda amazonlinux
docker run --rm=false -e "VERSION_VIPS=${VERSION_VIPS}" -e "VERSION_SHARP=${VERSION_SHARP}" -v $PWD:/packaging dev-lambda sh -c "/packaging/build/sharp.sh $RUNMODE"
