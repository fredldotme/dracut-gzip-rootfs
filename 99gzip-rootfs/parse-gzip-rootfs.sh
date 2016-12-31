#!/bin/bash
type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

# Check if root was set
if [[ -z "$root" ]] ; then
	root=$(getarg root=)
fi

if [[ "$root" == "gzramfs" ]] ; then
	if [[ ! -f "/rootfs.tar.gz" ]] ; then
		# Something bad has happened here, as this shouldn't be possible
		warn "Could not find embedded rootfs.tar.gz!"
		die
	fi
	gzramfs_size=$(getarg rd.gzramfs_size=)
	if [[ -z "$gzramfs_size" ]] ; then
		# default to 256 MB, which seems to be a reasonable size
		gzramfs_size="256M"
	fi
	gzramfs_create=1
	fstype="gzramfs"
	rootok=1
fi
