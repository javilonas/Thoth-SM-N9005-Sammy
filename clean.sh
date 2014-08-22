#!/bin/bash

TOOLCHAIN="/home/lonas/crom/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-"
DIR="/home/lonas/Kernel_Lonas/Thoth-SM-N9005-Sammy"

echo "#################### Eliminando Restos ####################"
if [ -e boot.img ]; then
	rm boot.img
fi

if [ -e compile.log ]; then
	rm compile.log
fi

if [ -e ramdisk.cpio ]; then
	rm ramdisk.cpio
fi

if [ -e ramdisk.cpio.gz ]; then
        rm ramdisk.cpio.gz
fi

#make distclean
make clean && make mrproper
rm Module.symvers

# clean ccache
read -t 6 -p "Eliminar ccache, (y/n)?"
if [ "$REPLY" == "y" ]; then
	ccache -C
fi

echo "ramfs_tmp = $RAMFS_TMP"

echo "#################### Eliminando build anterior ####################"

echo "Cleaning latest build"
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` mrproper
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` clean

find -name '*.ko' -exec rm -rf {} \;
rm -f $DIR/releasetools/tar/*.tar
rm -f $DIR/releasetools/zip/*.zip
rm -rf $DIR/arch/arm/boot/zImage
rm -f $DIR/arch/arm/boot/*.dtb
rm -f $DIR/arch/arm/boot/*.cmd
rm -rf $DIR/arch/arm/boot/Image
rm $DIR/boot.img
rm $DIR/zImage
