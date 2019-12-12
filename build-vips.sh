#!/bin/sh
set -e

if [ $# -lt 1 ]; then
  echo
  echo "Usage: $0 VERSION [debug] [keepall]"
  echo "Build shared libraries for libvips and its dependencies via containers"
  echo
  echo "Please specify the libvips VERSION, e.g. 8.7.0"
  echo "Add debug as parameter to enable bash debugging"
  echo "Add an extra keepall parameter to avoid recompilation of freetype and fontconfig libraries. Usually this parameter is not given."
  echo
  exit 1
fi
VERSION_VIPS="$1"
RUNMODE="$2"
KEEPALL="$3"

# Is docker available?
if ! type docker >/dev/null; then
  echo "Please install docker"
  exit 1
fi

echo "Building ..."

docker build -t dev-lambda amazonlinux
docker run --rm=false -e "VERSION_VIPS=${VERSION_VIPS}" -v $PWD:/packaging dev-lambda sh -c "/packaging/build/vips.sh $RUNMODE $KEEPALL"
