#!/sbin/busybox sh
#
#

# set busybox location
BB=/sbin/busybox

$BB mount -o remount,rw,nosuid,nodev /cache;
$BB mount -o remount,rw,nosuid,nodev /data;
$BB mount -o remount,rw /;
$BB mount -o remount,rw /lib/modules;

# cleaning
$BB rm -rf /cache/lost+found/* 2> /dev/null;
$BB rm -rf /data/lost+found/* 2> /dev/null;
$BB rm -rf /data/tombstones/* 2> /dev/null;
$BB rm -rf /data/anr/* 2> /dev/null;

# critical Permissions fix
$BB chown -R root:system /sys/devices/system/cpu/;
$BB chown -R system:system /data/anr;
$BB chown -R root:radio /data/property/;

# Make tmp folder to support TPowerCC smooth execution
$BB mkdir /tmp;

# Give permissions to execute
$BB chmod -R 777 /tmp/;
$BB chmod -R 6755 /sbin/ext/*;
$BB chmod -R 777 /res/;

$BB chmod -R 0777 /dev/cpuctl/;
$BB chmod -R 0777 /data/system/inputmethod/;
$BB chmod -R 0777 /sys/devices/system/cpu/;
$BB chmod -R 0777 /data/anr/;
$BB chmod 0744 /proc/cmdline;
$BB chmod -R 0770 /data/property/;
$BB chmod -R 0400 /data/tombstones;

# fix owners on critical folders
$BB chown -R root:root /tmp;
$BB chown -R root:root /res;
$BB chown -R root:root /sbin;
$BB chown -R root:root /lib;

# oom and mem perm fix
$BB chmod 666 /sys/module/lowmemorykiller/parameters/cost;
$BB chmod 666 /sys/module/lowmemorykiller/parameters/adj;

# protect init from oom
echo "-1000" > /proc/1/oom_score_adj;

# set sysrq to 2 = enable control of console logging level as with CM-KERNEL
#echo "2" > /proc/sys/kernel/sysrq;

# Make sure powersuspend use kernel mode instead of userspace
echo "0" > /sys/kernel/power_suspend/power_suspend_mode

# fix storage folder owner
$BB chown system.sdcard_rw /storage;

sync;

# Disable RIL power collapse
setprop ro.ril.disable.power.collapse 1

# Disable Google OTA Update checkin
setprop ro.config.nocheckin 1

# ROM Tuning
setprop pm.sleep_mode 1
setprop af.resampler.quality 4
setprop audio.offload.buffer.size.kb 32
setprop audio.offload.gapless.enabled false
setprop av.offload.enable true

