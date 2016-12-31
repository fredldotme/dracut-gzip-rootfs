# Embedded Root Filesystem Dracut Module
This is a module for [dracut][dracut_wiki] to add root filesystem images to
initramfs as tar.gz files.  This module was born out of a diskless PXE boot
setup that uses a minimal Fedora install as the operating system.  The main
use of this module is to provide a volatile, writable root filesystem without
using rwtab.

## Installation
Copy the 99gzip-rootfs directory into /usr/lib/dracut/modules.d/.  To use,
have a rootfs.tar.gz ready in the root directory of your install location.
To create a rootfs.tar.gz file, you could for example run:
````
tar cf - -C <chroot location> | gzip -9 > /tmp/rootfs.tar.gz
````
and then copy /tmp/rootfs.tar.gz into the root of your chroot location.
Then, run dracut with gzip-root module explicitly added:
````
dracut --add-modules="gzip-rootfs" /boot/initramfs.img
````
To boot into the extracted rootfs, pass root=gzramfs on the kernel command
line.  Optionally, you can also pass the argument rd.gzramfs_size to change
the size of the tmpfs allocated for the rootfs, which defaults 256 MB.

## Some Background
Many Linux distributions make /bin, /sbin, /lib and /lib64 symlinks to their
/usr equivalents.  One upside to this is that most of a Linux install now sits
in /usr, making the size of the rest of install tree relatively small.  For
Example, using the minimal Fedora 24 install I use for PXE boot, /usr takes up
892 MB, while the rest of the root filesystem is only 34 MB.  This is
advantageous for PXE clients, as the rootfs minus /usr is small enough to be
embedded into the initramfs image and /usr can be mounted as read-only network
filesystem.  Originally following guidance from 
[Missouri University Science & Technology Pegasus IV Cluster Notes][mst], I
hand-built an initramfs image with my rootfs packed into it.  However, this
is a very problematic when you have multiple types of devices to boot.  One
example issue is having nodes that have different types of network cards.
Dracut takes care of kernel module installation and module dependencies inside
the initramfs image, so this module is an implementation of the packed rootfs
for dracut.  I am currently using this module, as well as my
[dracut-glusterfs](https://github.com/stracy-esu/dracut-glusterfs) module to
boot diskless cluster nodes.

[dracut_wiki]: https://dracut.wiki.kernel.org/index.php/Main_Page
[mst]: http://web.mst.edu/~vojtat/pegasus/administration/nodes.htm
