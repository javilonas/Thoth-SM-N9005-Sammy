#!/sbin/busybox sh
#
# ZdualSwap 08-08-2014
# Copyright 2014 Javier Sayago "Javilonas"
# Contact: javilonas@esp-desarrolladores.com
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# 483MB Zdualswap 400 MB Zram + 10% Zswap

# Tamaño Zswap
zswap_size=83

# ZSWAP
if [ $zswap_size -gt 0 ]; then
echo `expr $zswap_size \* 1024 \* 1024` > /sys/devices/virtual/block/vnswap0/disksize
/sbin/busybox mkswap /dev/block/vnswap0 > /dev/null 2>&1
/sbin/busybox swapon -p 2 /dev/block/vnswap0 > /dev/null 2>&1
fi

sleep 3

# Tamaño Zram
zram_size=400

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

