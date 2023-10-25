cd build/sources/busybox-1.35.0
make defconfig
make LDFLAGS=-static
cp busybox ../../out/
cd ../linux-5.15.79
make defconfig
make -j8 || exit
cp arch/x86_64/boot/bzImage ~/simple-linux/linux/vmlinuz-5.15.79

cd ../..
mkdir -p initrd
cd initrd

echo "#! /bin/sh" >> init
echo "mount -t sysfs sysfs /sys" >> init
echo "mount -t proc proc /proc" >> init
echo "mount -t devtmpfs udev /dev" >> init
echo "sysctl -w kernel.printk="2 4 1 7"" >> init
echo "/bin/sh" >> init
echo "poweroff -f" >> init

chmod 777 init
mkdir -p bin dev proc sys
cd bin
cp ../../out/busybox ./
for prog in $(./busybox --list); do ln -s /bin/busybox $prog; done

cd ..
find . | cpio -o -H newc > ../../linux/initrd-busybox-1.35.0.img
cd ../../

./startvm.sh