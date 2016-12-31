#!/bin/bash
#
# This module embeds the final rootfs into the initramfs.
#
# The reasoning behind this module is to create a volatile rootfs in ram,
# much like a live image.  This however does not require a squashfs image,
# but a gzipp'ed image of the rootfs.  This is mostly useful for netboot or 
# diskless systems.  This also allows for a volatile rootfs, without having
# to use /etc/sysconfig/readonly_root and /etc/rwtab, which can become a
# hassle very quickly and don't seem very systemd compatible right now.

# Called by dracut
check() {
	require_binaries tar gzip || return 1
	return 255
}

# Called by dracut
depends() {
	return 0
}

# Called by dracut
cmdline() {
	printf " root=gzramfs rd.gzramfs_size=%s "
	return 0
}

# Called by dracut
install() {
	inst_multiple tar gzip
	inst_simple /rootfs.tar.gz
	inst_hook cmdline 99 "$moddir/parse-gzip-rootfs.sh"
	inst_hook mount 99 "$moddir/create-gzip-rootfs.sh"
}

# Called by dracut
installkernel() {
	return 0
}
