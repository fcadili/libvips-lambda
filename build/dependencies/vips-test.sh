#!/bin/sh

printf "\tPrepare ${DEPS}/${DEP_NAME}\n"
export DEP_NAME=vips-test
if [ -d ${DEPS}/${DEP_NAME} ]
then
	rm -rf ${DEPS}/${DEP_NAME}
fi
mkdir -p ${DEPS}/${DEP_NAME}
cd ${DEPS}/${DEP_NAME}

printf "\tCopying test files\n"
cp ${TEST}/${DEP_NAME}/* .

printf "\tTest vips cli\n"
for file in $(ls sample.*) ; do
	vips magickload $file "${file//./-}.jpg"

	if [ -f "${file//./-}.jpg" ] ; then
		printf "\tCli conversion of ${file} succeded.\n"
	fi
done
