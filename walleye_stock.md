```bash
shellcheck -sbash flash.bashrc
source flash.bashrc
walleye_vars
walleye_unzip_factory
```

Boot walleye to bootloader(fastboot)

```bash
walleye_fastboot_erase
fastboot_reboot_bootloader
fastboot_flash_factory
fastboot_reboot_system
```

Do nothing and restart to system

Remove stale devices from Google account  
[Google Account](https://myaccount.google.com/) ~ [Security](https://myaccount.google.com/security) ~ [Manage devices](https://myaccount.google.com/device-activity)

Enable USB debugging

```bash
adb_push_owner
```

Install ss-android & load profiles.json

Install Magisk Manager Canary & patch boot.img

```bash
adb_pull_patched_boot_img
adb_reboot_fastboot
fastboot_flash_patched_boot_img
fastboot_reboot_system
```

Turn on MagiskHide & check safetynet

```bash
adb_reboot_system
```

Get GSF ID and [certify device](https://www.google.com/android/uncertified/)

```bash
# adb shell
# su
/data/data/com.termux/files/usr/bin/sqlite3 \
  /data/data/com.google.android.gsf/databases/gservices.db \
  'select * from main where name = "android_id";'
# 
```


```bash
verify_a_b_and_system_as_root
```

Create and switch to unprivileged user jail for cn apps

```bash
adb_push_user
```

<!--
## Use

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

```bash
adb reboot recovery
```

Sideload OTA

```bash
adb devices | grep recovery && adb sideload ota_file.zip
```
-->