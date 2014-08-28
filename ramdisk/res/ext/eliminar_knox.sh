#!/sbin/busybox sh
#
# Deleted Knox NOTE3 by Javilonas 28/08/2014

# set busybox location
BB=/sbin/busybox

$BB mount -o remount,rw,nosuid,nodev /cache;
$BB mount -o remount,rw,nosuid,nodev /data;
$BB mount -o remount,rw /;

# cleaning
$BB rm -rf /system/etc/secure_storage/com.sec.knox.seandroid 2> /dev/null;
$BB rm -rf /system/etc/secure_storage/com.sec.knox.store 2> /dev/null;
$BB rm -rf /system/container 2> /dev/null;
$BB rm -rf /system/containers 2> /dev/null;
$BB rm -rf /system/preloadedsso 2> /dev/null;

$BB rm -rf /system/app/Bridge.apk 2> /dev/null;
$BB rm -rf /system/app/Bridge.odex 2> /dev/null;
$BB rm -rf /system/app/ContainerAgent.apk 2> /dev/null;
$BB rm -rf /system/app/ContainerAgent.odex 2> /dev/null;
$BB rm -rf /system/app/ContainerEventsRelayManager.apk 2> /dev/null;
$BB rm -rf /system/app/ContainerEventsRelayManager.odex 2> /dev/null;
$BB rm -rf /system/app/KLMSAgent.apk 2> /dev/null;
$BB rm -rf /system/app/KLMSAgent.odex 2> /dev/null;
$BB rm -rf /system/app/KNOXAgent.apk 2> /dev/null;
$BB rm -rf /system/app/KNOXAgent.odex 2> /dev/null;
$BB rm -rf /system/app/KnoxAttestationAgent.apk 2> /dev/null;
$BB rm -rf /system/app/KnoxAttestationAgent.odex 2> /dev/null;
$BB rm -rf /system/app/KnoxMigrationAgent.apk 2> /dev/null;
$BB rm -rf /system/app/KnoxMigrationAgent.odex 2> /dev/null;
$BB rm -rf /system/app/KnoxSetupWizardClient.apk 2> /dev/null;
$BB rm -rf /system/app/KnoxSetupWizardClient.odex 2> /dev/null;
$BB rm -rf /system/app/KnoxSetupWizardStub.apk 2> /dev/null;
$BB rm -rf /system/app/KnoxSetupWizardStub.odex 2> /dev/null;
$BB rm -rf /system/app/KNOXStore.apk 2> /dev/null;
$BB rm -rf /system/app/KNOXStore.odex 2> /dev/null;
$BB rm -rf /system/app/KNOXStub.apk 2> /dev/null;
$BB rm -rf /system/app/KNOXStub.odex 2> /dev/null;
$BB rm -rf /system/app/KnoxVpnServices.apk 2> /dev/null;
$BB rm -rf /system/app/KnoxVpnServices.odex 2> /dev/null;
$BB rm -rf /system/app/RCPComponents.apk 2> /dev/null;
$BB rm -rf /system/app/RCPComponents.odex 2> /dev/null;
$BB rm -rf /system/app/SPDClient.apk 2> /dev/null;
$BB rm -rf /system/app/SPDClient.odex 2> /dev/null;
$BB rm -rf /system/app/UniversalMDMClient.apk 2> /dev/null;
$BB rm -rf /system/app/UniversalMDMClient.odex 2> /dev/null;

sync;




