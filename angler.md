```bash
shellcheck -sbash flash.rc
source flash.rc
angler_vars
angler_unzip_factory # boot.img
```

Boot angler to bootloader(fastboot)

```bash
angler_fastboot_erase
fastboot_reboot_bootloader
angler_fastboot_flash_blob
angler_fastboot_flash_twrp
```

Reboot angler to TWRP recovery  
Wipe system  
Wipe data  
Wipe cache  
Format data

```bash
angler_adb_push_zip
```

Flash LineageOS 17.1 zip  
Flash Open GApps for Android 10.0 zip  
Reboot angler to system  
[Skip setup wizard](https://www.reddit.com/r/LineageOS/comments/6pficb/is_there_some_way_of_bypassing_the_lineageos/dkp15k1?utm_source=share&utm_medium=web2x&context=3)  
Do nothing and restart to system  
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

safetynet? cts?

GSF?

---

[Fix SIM card detection issue](https://forum.xda-developers.com/nexus-6p/orig-development/rom-lineageos-15-0-nexus-6p-angler-t3716789)
1. Settings - Security - Screen lock - None
1. Settings - Security - Screen lock - Swipe  
1. Settings - Security - Screen lock - None

[LineageOS 15.1 Changelog](https://www.lineageoslog.com/15.1)

[ElementalX](https://elementalx.org/)
* [Nexus 6P](https://elementalx.org/devices/nexus-6p/)
* [XDA](https://forum.xda-developers.com/nexus-6p/orig-development/kernel-elementalx-n6p-t3240571)

[BLOD workaround](https://forum.xda-developers.com/nexus-6p/general/bootloop-death-blod-workaround-zip-t3819515)

[Failed to mount '/vendor' (No such device)](https://sourceforge.net/p/pixeldustproject/discussion/general/thread/8d56bbe433/)

Block-based OTA
* PixelDust [angler 20200505](https://sourceforge.net/projects/pixeldustproject/files/ota/angler/)
* PixelExperience [angler 20200101](https://download.pixelexperience.org/angler)
* https://wiki.lineageos.org/extracting_blobs_from_zips.html
* https://source.android.com/devices/tech/ota/nonab/block
* https://solarex.github.io/wiki/Android/android_ota_update.html

[kernel](https://forum.xda-developers.com/nexus-6p/help/how-to-make-angler-build-t3262968/page2)

[Partitions and images](https://source.android.com/devices/bootloader/partitions-images)
* [android-simg2img](https://aur.archlinux.org/packages/android-simg2img/)
* [simg-tools](https://aur.archlinux.org/packages/simg-tools/)
* [lineage wiki](https://wiki.lineageos.org/extracting_blobs_from_zips.html)
* [aosp guide](https://source.android.com/devices/bootloader/partitions-images)

file \*img
```bash
boot.img:                           Android bootimg, kernel (0x8000), ramdisk (0x2000000), page size: 4096, cmdline (androidboot.hardware=angler androidboot.console=ttyHSL0 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm)
recovery.img:                       Android bootimg, kernel (0x8000), ramdisk (0x2000000), page size: 4096, cmdline (androidboot.hardware=angler androidboot.console=ttyHSL0 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm)
system.img:                         Android sparse image, version: 1.0, Total of 786432 4096-byte output blocks in 3898 input chunks.
vendor.img:                         Android sparse image, version: 1.0, Total of 51200 4096-byte output blocks in 845 input chunks.
radio-angler-angler-03.88.img:      data
bootloader-angler-angler-03.84.img: data
```

---

Unlock

```bash
fastboot flashing get_unlock_ability
fastboot flashing unlock
fastboot flashing unlock_critical
```

https://bugs.archlinux.org/task/63370

```bash
function pad {
  block_size=4096
  filename=bootloader-angler-angler-03.84.img
  filesize=$(stat --format=%s "$filename")
  block_count=$(( ($filesize + $block_size - 1) / $block_size ))
  aligned_size=$(( $block_count * $block_size ))
  padding_len=$(( $aligned_size - $filesize ))
  dd if=/dev/zero of="$filename-padding" bs=1 count=$padding_len
  cat $filename "$filename-padding" > "$filename-padded"
  rm -v "$filename-padding"
}
# pad bootloader-angler-angler-03.84.img
# fastboot flash bootloader bootloader-angler-angler-03.84.img-padded
# fastboot reboot-bootloader
fastboot flash radio radio-angler-angler-03.88.img &&
fastboot flash vendor vendor.img
```

Additional packages
* [Magisk Manager](https://github.com/topjohnwu/Magisk/releases)
* [com.aefyr.sai](https://apk.support/download-app/com.aefyr.sai)
* [com.smartpack.kernelmanager](https://apk.support/download-app/com.smartpack.kernelmanager) [(source)](https://github.com/SmartPack/SmartPack-Kernel-Manager) [(KernelAdiutor source)](https://github.com/Grarak/KernelAdiutor)
* [org.mozilla.firefox](https://apk.support/download-app/org.mozilla.firefox)

```bash
adb devices | grep -Ee 'device$' && \
adb push \
  MagiskManager-v7.5.1.apk \
  com.aefyr.sai.apk \
  com.smartpack.kernelmanager.zip \
  org.mozilla.firefox.apk \
/sdcard/Download
```

[Verify A/B and system-as-root](https://topjohnwu.github.io/Magisk/install.html#knowing-your-device)

```bash
adb devices | grep 'device$' && adb shell
AB="$(getprop ro.build.ab_update)"
SAR="$(getprop ro.build.system_root_image)"
echo "${AB:-FALSE} ${SAR:-FALSE}"
# FALSE true
```

(Vulnerable to unstable connection) Boot into TWRP ~ Advanced ~ ADB Sideload

[ADB sideload](https://twrp.me/faq/ADBSideload.html)


