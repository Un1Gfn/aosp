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

## [Factory Image](https://developers.google.com/android/images)

Erase **DO NOT ERASE BOOTLOADER**

```bash
cat <<"EOF" | bash -e
for i in a b; do
  fastboot erase boot_${i}
  fastboot erase dtbo_${i}
  fastboot erase -w system_${i}
  fastboot erase vbmeta_${i}
  fastboot erase vendor_${i}
done
fastboot erase userdata
fastboot set_active a
fastboot reboot bootloader
EOF
```

Unzip

```bash
unzip walleye-????.??????.???-factory-????????.zip # bootloader radio
cd walleye-????.??????.???/
unzip image-walleye-????.??????.???.zip # boot dtbo system system system_other vbmeta vendor
```

Flash bootloader

```bash
fastboot --slot all flash bootloader bootloader-walleye-??????-???.????.??.img
fastboot reboot bootloader
```

Flash everything else [(system_other)](https://source.android.com/security/verifiedboot/verify-system-other-partition) [(reddit)](https://www.reddit.com/r/GooglePixel/comments/7hwhma/81_factory_images_system_otherimg_2xl/dqucxy9?utm_source=share&utm_medium=web2x)

```bash
cat <<"EOF" | bash -e
fastboot --slot all flash boot boot.img
fastboot --slot all flash dtbo dtbo.img
fastboot --slot all flash radio radio-walleye-g8998-?????-??????????.img
fastboot --slot all flash vbmeta vbmeta.img
fastboot --slot all flash vendor vendor.img
fastboot --slot b flash system system_other.img
fastboot --slot a flash -w system system.img
fastboot erase userdata
fastboot format userdata
fastboot reboot bootloader
EOF
```

Boot into system

Do nothing and restart system

Remove stale devices from Google account  
[Google Account](https://myaccount.google.com/) ~ [Security](https://myaccount.google.com/security) ~ [Manage devices](https://myaccount.google.com/device-activity)

Enable USB debugging

Push Survival APKs
* [com.github.shadowsocks](https://apk.support/app/com.github.shadowsocks) (config.json)
* [com.github.shadowsocksd](https://github.com/TheCGDF/SSD-Android/releases)
* [Magisk Manager](https://github.com/topjohnwu/Magisk/releases)

```bash
adb devices | grep -Ee 'device$' && \
adb push \
  MagiskManager-v7.5.1.apk \
  SSD-2020.1-mobile.apk \
  com.github.shadowsocks.apk \
  profiles.json \
/sdcard/Download
```

Install the above APKs

Push boot image

```bash
adb push boot.img /sdcard/Download
```

**Connect to a non-DDoS'ed proxy from ssrcloud w/ ShadowsocksD** before checking updates in Magisk Manager  
[(otherwise Magisk Manager fails to connect to raw.githubusercontent.com)](https://github.com/topjohnwu/Magisk/issues/2905#issuecomment-647087771)

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

Sign in to Google

