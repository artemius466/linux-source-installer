# Config
LIBCRYPTFILE='libcrypt-dev_4.4.36-2_amd64.deb'

echo 'Using ' + $LIBCRYPTFILE + ' from debian archive.'

# Create folders
mkdir -p build/sources
mkdir -p build/downloads
mkdir -p build/out
mkdir -p linux
mkdir -p in-cache


# Install dependencies
sudo pacman -S wget dosfstools qemu-system-x86 git
clear
echo INSTALLING LIBCRYPT

# Install lybcrypt.a
cd in-cache
wget 'http://ftp.ru.debian.org/debian/pool/main/libx/libxcrypt/' + $LIBCRYPTFILE # If not working, check this: https://packages.debian.org/sid/arm64/libcrypt-dev/download
ar x $LIBCRYPTFILE
tar xf data.tar.xz
sudo cp usr/lib/x86_64-linux-gnu/libcrypt.a /lib/
sudo chmod o+r /lib/libcrypt.a

cd ..
rm -r -f in-cache
clear

echo Done! Installing linux kernel and busybox...

# Install linux kernel and busybox
cd build

wget -P downloads  https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.79.tar.xz
wget -P downloads https://busybox.net/downloads/busybox-1.35.0.tar.bz2

tar -xvf downloads/linux-5.15.79.tar.xz -C sources
tar -xjvf downloads/busybox-1.35.0.tar.bz2 -C sources
cd ..
clear
echo Done! Installing my .sh scripts...

mkdir cache
wget -P cache 'https://raw.githubusercontent.com/artemius466/linux-source-installer/Files/build.sh'
wget -P cache 'https://raw.githubusercontent.com/artemius466/linux-source-installer/Files/startvm.sh'
cp cache/build.sh ./
cp cache/startvm.sh ./
rm -r -f cache

clear

clear
echo DONE! WELCOME TO PUZHOS!
echo Type './build.sh' to build linux
echo Type './startvm.sh' to start linux on virtual machine


read -r -p "Do you want to delete this file? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    rm -f pre-install.sh
    echo Ok, deleted
else
    echo Ok, not deleted
fi