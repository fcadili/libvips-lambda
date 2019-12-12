#!/bin/sh
set -e

# Is docker available?
if ! type docker >/dev/null; then
  echo "Please install docker"
  exit 1
fi

echo "Running ..."
docker build -t dev-lambda amazonlinux
docker run --rm=false -i -t -v $PWD:/packaging -w /packaging/build dev-lambda /bin/bash
