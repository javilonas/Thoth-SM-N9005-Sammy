#!/sbin/busybox sh
#
# Zram 150MB x 4 = 600MB
#

# Tamaño Zram
zram_size=600

# ZRAM
if [ $zram_size -gt 0 ]; then
echo `expr $zram_size \* 1024 \* 256` > /sys/devices/virtual/block/zram0/disksize
/sbin/busybox swapoff /dev/block/zram0 > /dev/null 2>&1
echo 1 > /sys/devices/virtual/block/zram0/reset
echo 1 > /sys/devices/virtual/block/zram0/initstate
/sbin/busybox mkswap /dev/block/zram0 > /dev/null 2>&1
/sbin/busybox swapon -p 2 /dev/block/zram0 > /dev/null 2>&1

echo `expr $zram_size \* 1024 \* 256` > /sys/devices/virtual/block/zram1/disksize
/sbin/busybox swapoff /dev/block/zram1 > /dev/null 2>&1
echo 1 > /sys/devices/virtual/block/zram1/reset
echo 1 > /sys/devices/virtual/block/zram1/initstate
/sbin/busybox mkswap /dev/block/zram1 > /dev/null 2>&1
/sbin/busybox swapon -p 2 /dev/block/zram1 > /dev/null 2>&1

echo `expr $zram_size \* 1024 \* 256` > /sys/devices/virtual/block/zram2/disksize
/sbin/busybox swapoff /dev/block/zram2 > /dev/null 2>&1
echo 1 > /sys/devices/virtual/block/zram2/reset
echo 1 > /sys/devices/virtual/block/zram2/initstate
/sbin/busybox mkswap /dev/block/zram2 > /dev/null 2>&1
/sbin/busybox swapon -p 2 /dev/block/zram2 > /dev/null 2>&1

echo `expr $zram_size \* 1024 \* 256` > /sys/devices/virtual/block/zram3/disksize
/sbin/busybox swapoff /dev/block/zram3 > /dev/null 2>&1
echo 1 > /sys/devices/virtual/block/zram3/reset
echo 1 > /sys/devices/virtual/block/zram3/initstate
/sbin/busybox mkswap /dev/block/zram3 > /dev/null 2>&1
/sbin/busybox swapon -p 2 /dev/block/zram3 > /dev/null 2>&1
fi

