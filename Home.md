[adb](https://developer.android.com/studio/command-line/adb)
* http://adbcommand.com/

[LineageOS updater app stores zips in /data/lineageos_updates/](https://wiki.lineageos.org/faq.html#where-does-the-updater-app-store-the-downloaded-zip)

Grant Greenify privileges w/o root for AggressiveDoze & WakeupTrack

```bash
adb -d shell pm grant com.oasisfeng.greenify android.permission.WRITE_SECURE_SETTINGS
adb -d shell pm grant com.oasisfeng.greenify android.permission.DUMP
adb -d shell pm grant com.oasisfeng.greenify android.permission.READ_LOGS
adb -d shell am force-stop com.oasisfeng.greenify
```

