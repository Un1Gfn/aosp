[XDA Nexus 6P](https://forum.xda-developers.com/nexus-6p)
* [LineageOS 17.1 (PixelBoot)](https://forum.xda-developers.com/nexus-6p/orig-development/rom-lineageos-17-0-nexus-6p-angler-t4012099)

[ElementalX](https://elementalx.org/)
* [Nexus 6P](https://elementalx.org/devices/nexus-6p/)
* [XDA](https://forum.xda-developers.com/nexus-6p/orig-development/kernel-elementalx-n6p-t3240571)

[BLOD workaround](https://forum.xda-developers.com/nexus-6p/general/bootloop-death-blod-workaround-zip-t3819515)

[PixelDust](https://sourceforge.net/projects/pixeldustproject/)
* [PixelDust-Project-X](https://github.com/PixelDust-Project-X)
* [PixelDust Project CAF](https://github.com/pixeldust-project-caf) [(CAF)](https://www.codeaurora.org/)
* [Failed to mount '/vendor' (No such device)](https://sourceforge.net/p/pixeldustproject/discussion/general/thread/8d56bbe433/)

Block-based OTA
* PixelDust [angler 20200505](https://sourceforge.net/projects/pixeldustproject/files/ota/angler/)
* PixelExperience [angler 20200101](https://download.pixelexperience.org/angler)
* https://wiki.lineageos.org/extracting_blobs_from_zips.html
* https://source.android.com/devices/tech/ota/nonab/block
* https://solarex.github.io/wiki/Android/android_ota_update.html

[XDA](https://forum.xda-developers.com/nexus-6p)

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

[Verify neither A/B nor system-as-root](https://topjohnwu.github.io/Magisk/install.html#knowing-your-device)

```bash
fastboot boot twrp-3.3.1-0-angler.img
adb shell
# false and false
getprop ro.build.ab_update
getprop ro.build.system_root_image
getprop | grep build
exit
```

Erase **DO NOT ERASE BOOTLOADER**

```bash
fastboot erase boot &&
fastboot erase cache &&
fastboot erase recovery &&
fastboot erase system -w &&
fastboot erase userdata &&
fastboot erase vendor
```

Format (user)data , otherwise TWRP asks for a nonexist password and complains about "Failed to mount XXX" [(details)](https://www.reddit.com/r/Nexus6P/comments/46hyxc/encryptingdecrypting_user_data_twrp_default/d05lpol)

```bash
fastboot format userdata
```

Flash TWRP

```bash
fastboot flash recovery twrp-3.3.1-0-angler.img
```

Unzip [factory image](https://developers.google.com/android/images)

```bash
unzip angler-opm7.181205.001-factory-b75ce068.zip # bootloader and radio
cd angler-opm7.181205.001/
unzip image-angler-opm7.181205.001.zip vendor.img # vendor
```

|||
|-|-|
|bootloader|factory image|
|radio|factory image|
|vendor|factory image|
|recovery|twrp|
|system|pixeldust|
|(user)data|erase (fastboot -h \| grep -- -w)|

Flash bootloader, radio and vendor from factory image

```bash
function pad {
  # https://bugs.archlinux.org/task/63370
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

Boot into TWRP

Push OTA zip

```bash
adb devices
adb push lineage-17.1-20200608-UNOFFICIAL-angler.zip /sdcard/
```

Install OTA zip in TWRP manually

Boot into system

Do nothing and restart system

Enable USB debugging

Push Survival APKs
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

Install the above APKs

Push boot image

```bash
adb push boot.img /sdcard/Download
```

Connect to be.mygod.vpnhotspot behind non-DDoS'ed proxy before checking updates in Magisk Manager

Patch boot image w/ Magisk Manager

Pull patched boot image

```bash
adb pull /sdcard/Download/magisk_patched.img
```

Reboot into bootloader

Flash patched boot image

```bash
fastboot --slot a flash boot magisk_patched.img 
```

Boot into system


<details><summary>h</summary>

Magisk APK

```bash
adb install MagiskManager-v7.5.1.apk
```

(Vulnerable to unstable connection) Boot into TWRP ~ Advanced ~ ADB Sideload

[ADB sideload](https://twrp.me/faq/ADBSideload.html)
``` bash
adb sideload PixelDust-X-caf-angler-20200606-0903.zip
```

</details>


