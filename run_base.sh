#!/bin/bash -e

##
## @file        run_base.sh
## @brief       Script to run the PetaLinux Docker Image
## @author      Keitetsu
## @date        2019/11/04
## @copyright   Copyright (c) 2019 Keitetsu
## @par         License
##              This software is released under the MIT License.
##
if [ -z "$DATADIR" ]; then
	for dir in . .. ; do
		if [ -e "$dir/pre-built/linux" ]; then
		export DATADIR=$(cd "$dir/pre-built/linux" && pwd)
		fi
	done
fi
if [ ! -e "$DATADIR" ]; then
	echo "Cannot find DATADIR at '$DATADIR'"
	exit 1
fi
xhost +local:root

docker run \
    --interactive \
    --tty \
    --net host \
    --rm \
    --name petalinux \
    --env TZ=Australia/Brisbane \
    --env DISPLAY=${DISPLAY} \
    --env QT_X11_NO_MITSHM=1 \
    --env HOST_USER=user \
    --env HOST_UID=$(id -u ${USER}) \
    --env HOST_GROUP=dialout \
    --env HOST_GID=$(id -g ${USER}) \
    --volume /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --volume $DATADIR:/data \
    rhx/petalinux:ubuntu20.04-base
