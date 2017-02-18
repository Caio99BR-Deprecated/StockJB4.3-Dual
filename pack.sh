#!/bin/bash

WORK_DIR=$(pwd)
REL=$(date +%d""%m""%Y)
HEAPSIZE=$(grep MemTotal /proc/meminfo | gawk '{ print $2/1024-500 }' | cut -d"." -f1)
PACKAGE_REL="XperiaE1-Stock-ROM-4.3-D2114-${REL}"

if [ $(ls ${WORK_DIR}/ | grep system | wc -l) == "1" ]
then
	echo "Cleaning old zip's"
	rm -fr update.zip ${PACKAGE_REL}.zip

	echo "Packing new zip"
	zip -qr9 update.zip  META-INF system extras boot.img

	if [ $(ls ${WORK_DIR}/ | grep tools | wc -l) == "1" ]
	then
		echo "Signing new zip"
		java -Xmx${HEAPSIZE}m -jar tools/signapk/signapk.jar -w tools/signapk/testkey.x509.pem tools/signapk/testkey.pk8 update.zip ${PACKAGE_REL}.zip
	else
		echo "Tools is missing"
	fi
else
	echo "System is missing"
fi
