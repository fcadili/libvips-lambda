#!/bin/sh

printf "\tPrepare ${DEPS}/${DEP_NAME}\n"
export DEP_NAME=sharp
if [ -d ${DEPS}/${DEP_NAME} ]
then
	rm -rf ${DEPS}/${DEP_NAME}
fi
mkdir -p ${DEPS}/${DEP_NAME}
cd ${DEPS}/${DEP_NAME}

printf "\tCreate sharp nodejs directory structure\n"
mkdir -p nodejs
cat << . > nodejs/package.json
{
  "name": "serverless-iiif",
  "version": "1.1.0",
  "description": "Lambda wrapper for iiif-processor",
  "author": "Michael B. Klein",
  "license": "Apache-2.0",
  "dependencies": {},
  "devDependencies": {
    "sharp": "^0.21.3"
  }
}
.
sed -i -e 's/\^0.21.3/\^'${VERSION_SHARP}'/g' nodejs/package.json

printf "\tCopying test files\n"
cd nodejs
cp ${TEST}/${DEP_NAME}/* .

printf "\tCreating libvips-${VERSION_VIPS}-linux-x64.tar.gz\n"
VENDOR=nodejs/node_modules/sharp/vendor
mkdir -p ${VENDOR}

rsync -a --exclude='*.la' ${TARGET}/lib/ ${VENDOR}/lib/
rsync -a --ignore-existing --exclude='*.la' ${TARGET}/lib64/ ${VENDOR}/lib/
rsync -a --ignore-existing --exclude='*.la' ${TARGET}/lib64-all/ ${VENDOR}/lib/
rsync -a ${TARGET}/include/ ${VENDOR}/include/

mv -f ${VENDOR}/lib/versions.json ${VENDOR}/versions.json
cat << . > nodejs/node_modules/sharp/vendor/platform.json
"linux-x64"
.

printf "\tCopy libvips-${VERSION_VIPS}-linux-x64.tar.gz in node cache"
mkdir -p /root/.npm/_libvips/
cd ${VENDOR}
tar -zcf /root/.npm/_libvips/libvips-${VERSION_VIPS}-linux-x64.tar.gz *

printf "\tBuilding sharp from code (using cached library)."
cd ${DEPS}/${DEP_NAME}/nodejs
rm -rf node_modules
npm install --build-from-source

printf "\tTest sharp with node10.x\n"

cd ${DEPS}/${DEP_NAME}/nodejs
node index.js
for file in "$(ls sample-*.jpg)" ; do
	original=${file//-/.}
	original=${original%.*}
	printf "\tCli conversion of ${original} succeded.\n"
done
