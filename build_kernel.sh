#!/bin/sh
# Build Script: Javilonas, 22-08-2014
# Javilonas <admin@lonasdigital.com>
start_time=`date +'%d/%m/%y %H:%M:%S'`
echo "#################### Eliminando Restos ####################"
./clean.sh > /dev/null 2>&1
echo "#################### Preparando Entorno ####################"
export KERNELDIR=`readlink -f .`
export RAMFS_SOURCE=`readlink -f $KERNELDIR/ramdisk`
#export USE_SEC_FIPS_MODE=true
export TOOLBASE="/home/lonas/Kernel_Lonas/Thoth-SM-N9005-Sammy/scripts"

if [ "${1}" != "" ];then
  export KERNELDIR=`readlink -f ${1}`
fi

ROOTFS_PATH="/home/lonas/Kernel_Lonas/Thoth-SM-N9005-Sammy/ramdisk"
RAMFS_TMP="/home/lonas/Kernel_Lonas/tmp/ramfs-source-sgn3"

export KERNEL_VERSION="Thoth-1.0"
export VERSION_KL="SAMMY-4.4.2"
export REVISION="RTM"

export KBUILD_BUILD_VERSION="1"

# make defconfig
cp arch/arm/configs/lonas_msm8974_sec_defconfig .config

. $KERNELDIR/.config

echo "#################### Aplicando Permisos correctos ####################"
chmod 644 $ROOTFS_PATH/*.rc
chmod 750 $ROOTFS_PATH/init*
chmod 640 $ROOTFS_PATH/fstab*
chmod 644 $ROOTFS_PATH/default.prop
chmod 771 $ROOTFS_PATH/data
chmod 755 $ROOTFS_PATH/dev
chmod 755 $ROOTFS_PATH/lib
chmod 755 $ROOTFS_PATH/lib/modules
chmod 644 $ROOTFS_PATH/lib/modules/*
chmod 755 $ROOTFS_PATH/proc
chmod 750 $ROOTFS_PATH/sbin
chmod 750 $ROOTFS_PATH/sbin/*
chmod 755 $ROOTFS_PATH/res/ext/99SuperSUDaemon
chmod 755 $ROOTFS_PATH/sys
chmod 755 $ROOTFS_PATH/system

find . -type f -name '*.h' -exec chmod 644 {} \;
find . -type f -name '*.c' -exec chmod 644 {} \;
find . -type f -name '*.py' -exec chmod 755 {} \;
find . -type f -name '*.sh' -exec chmod 755 {} \;
find . -type f -name '*.pl' -exec chmod 755 {} \;


echo "ramfs_tmp = $RAMFS_TMP"

#remove previous ramfs files
rm -rf $RAMFS_TMP > /dev/null 2>&1
rm -rf $RAMFS_TMP.cpio > /dev/null 2>&1
rm -rf $RAMFS_TMP.cpio.gz > /dev/null 2>&1
#copy ramfs files to tmp directory
cp -ax $RAMFS_SOURCE $RAMFS_TMP
#clear git repositories in ramfs
find $RAMFS_TMP -name .git -exec rm -rf {} \;
#remove empty directory placeholders
find $RAMFS_TMP -name EMPTY_DIRECTORY -exec rm -rf {} \;
find $RAMFS_TMP -name .EMPTY_DIRECTORY -exec rm -rf {} \;
rm -rf $RAMFS_TMP/tmp/* > /dev/null 2>&1
#remove mercurial repository
rm -rf $RAMFS_TMP/.hg > /dev/null 2>&1
cd $RAMFS_TMP
find | fakeroot cpio -H newc -o > $RAMFS_TMP.cpio 2>/dev/null
ls -lh $RAMFS_TMP.cpio
gzip -9 $RAMFS_TMP.cpio

echo "#################### Compilar Kernel ####################"
#remove previous out files
rm $KERNELDIR/dt.img > /dev/null 2>&1
rm $KERNELDIR/boot.img > /dev/null 2>&1
rm $KERNELDIR/*.ko > /dev/null 2>&1
#compile kernel
cd $KERNELDIR
nice -n 10 make -j7 >> compile.log 2>&1 || exit -1

echo "#################### Generar nueva dt image ####################"
$TOOLBASE/dtbTool -o $KERNELDIR/dt.img -s 2048 -p $KERNELDIR/scripts/dtc/ $KERNELDIR/arch/arm/boot/

echo "#################### Generar nuevo boot.img ####################"
$TOOLBASE/mkbootimg_dtb --base 0x0 --kernel $KERNELDIR/arch/arm/boot/zImage --ramdisk_offset 0x2000000 --tags_offset 0x1e00000 --pagesize 2048 --cmdline 'console=null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 zswap.enabled=1 zswap.compressor=lz4' --ramdisk $RAMFS_TMP.cpio.gz --dt $KERNELDIR/dt.img -o $KERNELDIR/boot.img

find . -name "boot.img"
find . -name "*.ko" -exec mv {} . \;
${CROSS_COMPILE}strip --strip-unneeded ./*.ko
find . -name "*.ko"

echo "#################### Preparando flasheables ####################"

cp boot.img $KERNELDIR/releasetools/zip
cp boot.img $KERNELDIR/releasetools/tar

cd $KERNELDIR
cd releasetools/zip
zip -0 -r $KERNEL_VERSION-$REVISION$KBUILD_BUILD_VERSION-$VERSION_KL.zip *
cd ..
cd tar
tar cf $KERNEL_VERSION-$REVISION$KBUILD_BUILD_VERSION-$VERSION_KL.tar boot.img && ls -lh $KERNEL_VERSION-$REVISION$KBUILD_BUILD_VERSION-$VERSION_KL.tar

echo "#################### Eliminando restos ####################"

rm $KERNELDIR/releasetools/zip/boot.img > /dev/null 2>&1
rm $KERNELDIR/releasetools/tar/boot.img > /dev/null 2>&1
rm $KERNELDIR/boot.img > /dev/null 2>&1
rm $KERNELDIR/zImage > /dev/null 2>&1
rm $KERNELDIR/zImage-dtb > /dev/null 2>&1
rm $KERNELDIR/boot.dt.img > /dev/null 2>&1
rm $KERNELDIR/dt.img > /dev/null 2>&1
rm -rf /home/lonas/Kernel_Lonas/tmp/ramfs-source-sgn3 > /dev/null 2>&1
rm /home/lonas/Kernel_Lonas/tmp/ramfs-source-sgn3.cpio.gz > /dev/null 2>&1
echo "#################### Terminado ####################"
