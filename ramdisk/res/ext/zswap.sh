#!/sbin/busybox sh
#
# zswap
#

RAMSIZE=`grep MemTotal /proc/meminfo | awk '{ print \$2 }'`
ZSWAPSIZE=$(($RAMSIZE*100))

if [ $ZSWAPSIZE -gt 0 ]; then
echo $ZSWAPSIZE > /sys/devices/virtual/block/vnswap0/disksize
/sbin/busybox mkswap /dev/block/vnswap0 > /dev/null 2>&1
/sbin/busybox swapon -p 2 /dev/block/vnswap0 > /dev/null 2>&1
fi
