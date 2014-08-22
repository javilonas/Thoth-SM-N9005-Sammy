#!/sbin/busybox sh
#
# Script inicio lonas-init.sh
#

SYSTEM_DEVICE="/dev/block/mmcblk0p23"

# Inicio lonas-init.sh
/sbin/busybox mount -o remount,rw -t ext4 $SYSTEM_DEVICE /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs

# Hacer root si no detecta bianrio SU
if [ ! -f /system/xbin/su ] && [ ! -f /system/bin/su ]; then

/sbin/busybox mkdir /system/bin/.ext
/sbin/busybox cp /sbin/su /system/xbin/su
/sbin/busybox cp /sbin/daemonsu /system/xbin/daemonsu
/sbin/busybox cp /sbin/su /system/bin/.ext/.su
/sbin/busybox cp /res/ext/install-recovery.sh /system/etc/install-recovery.sh
/sbin/busybox cp /res/ext/99SuperSUDaemon /system/etc/init.d/99SuperSUDaemon
/sbin/busybox echo /system/etc/.installed_su_daemon

/sbin/busybox chown 0.0 /system/bin/.ext
/sbin/busybox chmod 0777 /system/bin/.ext
/sbin/busybox chown 0.0 /system/xbin/su
/sbin/busybox chmod 6755 /system/xbin/su
/sbin/busybox chown 0.0 /system/xbin/daemonsu
/sbin/busybox chmod 6755 /system/xbin/daemonsu
/sbin/busybox chown 0.0 /system/bin/.ext/.su
/sbin/busybox chmod 6755 /system/bin/.ext/.su
/sbin/busybox chown 0.0 /system/etc/install-recovery.sh
/sbin/busybox chmod 0755 /system/etc/install-recovery.sh
/sbin/busybox chown 0.0 /system/etc/.installed_su_daemon
/sbin/busybox chmod 0644 /system/etc/.installed_su_daemon

/sbin/busybox chattr +i /system/xbin/su
/sbin/busybox chattr +i /system/bin/.ext/.su
/sbin/busybox chattr +i /system/xbin/daemonsu

/system/bin/sh /system/etc/install-recovery.sh

fi

/res/ext/inicio_correcto.sh

# Detectar y generar INIT.D
/res/ext/init_d.sh

# Iniciar Bootanimation personalizado
/res/ext/bootanimation.sh

# Limpiador
/res/ext/limpiador.sh

# Iniciar SQlite
/res/ext/sqlite.sh

# Iniciar Zipalign
/res/ext/zipalign.sh

# Remontar y Optimizar particiones con EXT4
/res/ext/optimi_remount.sh

# Iniciar Tweaks Lonas_KL
/res/ext/tweaks.sh

# Iniciar Sensor
/res/ext/sensors.sh

# Soporte Init.d
if [ -d /system/etc/init.d ]; then
  /sbin/busybox run-parts /system/etc/init.d
fi;

# Now wait for the rom to finish booting up
# (by checking for any android process)
while ! /sbin/busybox pgrep android.process.acore ; do
  /sbin/busybox sleep 2
done

# kill radio logcat to sdcard
/sbin/busybox pkill -f "logcat -b radio -v time";

/sbin/busybox sleep 2

/sbin/busybox sync

# Iniciar Liberar Memoria
/res/ext/libera_ram.sh &
/sbin/busybox renice 19 `pidof libera_ram.sh`

/sbin/busybox sleep 3

/res/ext/smoothsystem.sh &
/sbin/busybox renice 19 `pidof smoothsystem.sh`

/sbin/busybox sleep 3

/sbin/ext/killing.sh &

/sbin/busybox sleep 2

sync

/sbin/busybox mount -t rootfs -o remount,ro rootfs
/sbin/busybox mount -o remount,ro -t ext4 $SYSTEM_DEVICE /system
