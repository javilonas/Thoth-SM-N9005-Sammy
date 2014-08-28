#!/sbin/busybox sh
#
# zswap
#

#RAMSIZE=`grep MemTotal /proc/meminfo | awk '{ print \$2 }'`
#ZSWAPSIZE=$(($RAMSIZE*100))
ZSWAPSIZE=512
if [ $ZSWAPSIZE -gt 0 ]; then
echo `expr $ZSWAPSIZE \* 1024 \* 1024` > /sys/devices/virtual/block/vnswap0/disksize
/sbin/busybox swapoff /dev/block/zram0 > /dev/null 2>&1
echo 1 > /sys/devices/virtual/block/vnswap0/reset
/sbin/busybox mkswap /dev/block/vnswap0 > /dev/null 2>&1
/sbin/busybox swapon /dev/block/vnswap0 > /dev/null 2>&1
fi
