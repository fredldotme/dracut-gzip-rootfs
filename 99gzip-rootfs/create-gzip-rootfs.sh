#!/bin/bash

. /lib/dracut-lib.sh
if [[ "$gzramfs_create" == 1 ]] ; then
	info "Creating tmpfs for gzipped rootfs"
	mount -t tmpfs -o size=$gzramfs_size tmpfs $NEWROOT
	tar xf /rootfs.tar.gz -C $NEWROOT
	info "gzipped rootfs sucessfully extracted"
fi
