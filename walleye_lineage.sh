#!/dev/null
exit 1
# This script should be manually copied and executed in bash, line by line 

# Prepare phone
Manually disconnect walleye
Manually poweroff walleye
Manually boot walleye into bootloader/fastboot

# Prepare env
cd ~darren/aosp
shellcheck -sbash flash.bashrc
su
#
Manually input password
source flash.bashrc

# Flash latest factory image
walleye_factory_vars walleye-rp1a.201005.004.a1-factory-0c23f6cf.zip
walleye_unzip_factory
Manually connect walleye dual-typec
fastboot devices
clear; tput reset
fastboot_flash_factory_walleye
fastboot reboot-bootloader

# Flash lineage recovery
fastboot flash boot lineage-17.1-20210119-recovery-walleye.img
fastboot reboot-bootloader

# https://wiki.lineageos.org/devices/walleye/install#installing-lineageos-from-recovery
# fastboot reboot recovery # Doesn't work
Manually boot into Recovery Mode
Manually Factory reset -> Format data/factory reset -> Format data
#
Manually Apply update -> Apply from ADB
adb devices | grep --color=always sideload
adb sideload lineage-17.1-20210119-nightly-walleye-signed.zip

# Open GApps
Manually disconnect cable
Manually Advanced -> Power off
Manually boot into Recovery Mode
Manually Apply update -> Apply from ADB
adb devices | grep --color=always sideload
adb sideload open_gapps-arm64-10.0-pico-20210123.zip
Manually Install anyway -> Yes
Manually disconnect cable
Manually Advanced -> Power off

# Install Magisk
Manually set up Wi-Fi with LAN HTTP proxy
Manually install chrome from Play Store
Manually download and install Magisk Manager
Manually enable adb
adb devices
adb push -- "$dir/boot.img" "$T/"
Manually patch img in Magisk Manager
adb pull -- "$T/magisk_patched_uecSE.img"
Manually reboot to bootloader
fastboot devices
fastboot flash boot "magisk_patched_uecSE.img"
Manually reboot to system

# Remove system apps

# Shadowsocks
Manually install telegram from Play Store
Manually log in to telegram
Manually install shadowsocks from Play Store
Manually download json from telegram
Manually import



################################################################################
exit 0
################################################################################


Install Magisk Manager Canary & patch boot.img

adb_pull_patched_boot_img
adb_reboot_fastboot
fastboot_flash_patched_boot_img
fastboot_reboot_system

Turn on MagiskHide & check safetynet


Get GSF ID and [certify device](https://www.google.com/android/uncertified/)

# adb shell
# su
/data/data/com.termux/files/usr/bin/sqlite3 \
  /data/data/com.google.android.gsf/databases/gservices.db \
  'select * from main where name = "android_id";'
# 

verify_a_b_and_system_as_root

Create and switch to unprivileged user jail for cn apps

adb_push_user

Play Store Download Pending
* https://support.google.com/googleplay/thread/14845927?hl=en&msgid=14853207
* https://www.makeuseof.com/tag/4-simple-fixes-google-play-store-problems/
* https://www.maketecheasier.com/fix-download-pending-error-google-play/
* Turn off bluetooth
* Clear com.android.providers.downloads data
* Grant com.android.vending location premission manually

## [Full OTA Image](https://developers.google.com/android/ota)

**CANCEL ANY PENDING OTA**

Reboot into stock recovery

adb reboot recovery

Sideload OTA

adb devices | grep recovery && adb sideload ota_file.zip
-->