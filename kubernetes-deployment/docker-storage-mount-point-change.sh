#!/bin/bash

# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# This script will mount /var/lib/docker to the storagePath
# In our VM: storagePath's mount point is /dev/sdb1

sudo su

storagePath="/mnt"
storagePathMountPoint="/dev/sdb1"
restartDocker="restart"

[[ -f $storagePath/mountdone ]] && {

    echo Mount Successfully
    exit 0

}


if command -v docker >/dev/null 2>&1; then
    echo docker has been installed. And docker daemon will be stopped first.
    systemctl stop docker
else
    mkdir -p /var/lib/docker
    restartDocker=""
fi

cp -r /var/lib/docker/* /mnt
rm -rf /var/lib/docker/*
mount $storagePathMountPoint /var/lib/docker

umount $storagePath
echo  "$storagePathMountPoint  /var/lib/docker   ext4    defaults    0 0" >> /etc/fstab

touch $storagePath/mountdone

echo Mount Successfully

[[ "$restartDocker" == "restart" ]] && {

    echo restart docker!
    systemctl restart docker

}