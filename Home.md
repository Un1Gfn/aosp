[Link to this page](https://github.com/Un1Gfn/lineage)
[Link to CircleCI pipelines](https://app.circleci.com/pipelines/github/Un1Gfn/lineage)

CircleCI
* [Pipelines](https://app.circleci.com/pipelines/github/Un1Gfn/lineage)
* [Caching Dependencies](https://circleci.com/docs/2.0/caching/)
* [Configuring CircleCI](https://circleci.com/docs/2.0/configuration-reference/#run)

Debian/Ubuntu
* [J\*](https://askubuntu.com/questions/150057/how-can-i-tell-what-version-of-java-i-have-installed)
* [alternatives system](https://wiki.debian.org/DebianAlternatives)
* tell which package provide FILE `dpkg -S FILE`

[Repo](https://gerrit.googlesource.com/git-repo/)
* [Repo Command Reference](https://source.android.com/setup/develop/repo)

[Soong](https://android.googlesource.com/platform/build/soong)
* [modules](https://ci.android.com/builds/submitted/6402685/linux/latest/view/soong_build.html)
* [envsetup.sh](https://android.googlesource.com/platform/build/+/refs/heads/master/envsetup.sh)
* [m](https://source.android.com/setup/build/building#build-the-code)

[AOSP](https://source.android.com/)
* [Android CI](https://ci.android.com/)
* [Mailing list](https://groups.google.com/forum/#!forum/android-building)
* [Android Community and contacts](https://source.android.com/setup/community.html)
* [Google Git](https://android.googlesource.com/)
* [Android Code Search](https://cs.android.com/)
* [Codename ~ Version ~ API level ~ NDK release](https://source.android.com/setup/start/build-numbers#platform-code-names-versions-api-levels-and-ndk-releases)
* [NDK Revision](https://developer.android.com/ndk/downloads/revision_history)

Nexus 6P
* [XDA](https://forum.xda-developers.com/nexus-6p)
* [kernel](https://forum.xda-developers.com/nexus-6p/help/how-to-make-angler-build-t3262968/page2)

[Partitions and images](https://source.android.com/devices/bootloader/partitions-images)
  * [android-simg2img](https://aur.archlinux.org/packages/android-simg2img/)
  * [simg-tools](https://aur.archlinux.org/packages/simg-tools/)
  * [lineage wiki](https://wiki.lineageos.org/extracting_blobs_from_zips.html)
  * [aosp guide](https://source.android.com/devices/bootloader/partitions-images)

tmux
* Detach: <kbd>Ctrl</kbd>+<kbd>b</kbd> <kbd>d</kbd>
* Scroll: <kbd>Ctrl</kbd>+<kbd>b</kbd> <kbd>[</kbd>

assert(P)
```bash
[ P ] || exit 1
```

return code
```bash
PS0="$PS1"
PS1="\$?|$PS0"
PS1="$PS0"
```

curl
```bash
# Progress meter
curl -LOJR 'https://...'
# Progress bar
curl -# -LOJR 'https://...'
# Silent
curl -sS -LOJR 'https://...'
```

Save disk space
* [duc](https://duc.zevv.nl/)
  * [usage](https://github.com/zevv/duc/blob/master/doc/duc.md)
  * [AUR](https://aur.archlinux.org/packages/duc/)
  * [xenial](https://packages.ubuntu.com/xenial/duc)

file *img
```bash
boot.img:                           Android bootimg, kernel (0x8000), ramdisk (0x2000000), page size: 4096, cmdline (androidboot.hardware=angler androidboot.console=ttyHSL0 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm)
recovery.img:                       Android bootimg, kernel (0x8000), ramdisk (0x2000000), page size: 4096, cmdline (androidboot.hardware=angler androidboot.console=ttyHSL0 msm_rtb.filter=0x37 ehci-hcd.park=3 lpm)
system.img:                         Android sparse image, version: 1.0, Total of 786432 4096-byte output blocks in 3898 input chunks.
vendor.img:                         Android sparse image, version: 1.0, Total of 51200 4096-byte output blocks in 845 input chunks.
radio-angler-angler-03.88.img:      data
bootloader-angler-angler-03.84.img: data
```

huawei-angler-opm7.181205.001-52ed73ce.tgz
extract-huawei-angler.sh
```huawei
vendor/
vendor/huawei/
vendor/huawei/angler/
vendor/huawei/angler/BoardConfigPartial.mk
vendor/huawei/angler/device-vendor.mk
vendor/huawei/angler/device-partial.mk
vendor/huawei/angler/proprietary/
vendor/huawei/angler/proprietary/vendor.img
vendor/huawei/angler/android-info.txt
vendor/huawei/angler/BoardConfigVendor.mk
```

lunch aosp_angler-userdebug
```
============================================
PLATFORM_VERSION_CODENAME=REL
PLATFORM_VERSION=8.1.0
TARGET_PRODUCT=aosp_angler
TARGET_BUILD_VARIANT=userdebug
TARGET_BUILD_TYPE=release
TARGET_ARCH=arm64
TARGET_ARCH_VARIANT=armv8-a
TARGET_CPU_VARIANT=cortex-a53
TARGET_2ND_ARCH=arm
TARGET_2ND_ARCH_VARIANT=armv7-a-neon
TARGET_2ND_CPU_VARIANT=cortex-a53.a57
HOST_ARCH=x86_64
HOST_2ND_ARCH=x86
HOST_OS=linux
HOST_OS_EXTRA=Linux-4.15.0-1027-gcp-x86_64-with-Ubuntu-16.04-xenial
HOST_CROSS_OS=windows
HOST_CROSS_ARCH=x86
HOST_CROSS_2ND_ARCH=x86_64
HOST_BUILD_TYPE=release
BUILD_ID=OPM7.181205.001
OUT_DIR=out
============================================
```

m help
```
Common make targets:
----------------------------------------------------------------------------------
droid                   Default target
clean                   (aka clobber) equivalent to rm -rf out/
snod                    Quickly rebuild the system image from built packages
vnod                    Quickly rebuild the vendor image from built packages
offline-sdk-docs        Generate the HTML for the developer SDK docs
doc-comment-check-docs  Check HTML doc links & validity, without generating HTML
libandroid_runtime      All the JNI framework stuff
framework               All the java framework stuff
services                The system server (Java) and friends
help                    You're reading it right now
```

m droid
```
[44/44] bootstrap out/soong/.minibootstrap/build.ninja.in
[4/4] out/soong/.bootstrap/bin/minibp out/soong/.bootstrap/build.ninja
[860/861] glob vendor/*/*/Android.bp
[54/54] out/soong/.bootstrap/bin/soong_build out/soong/build.ninja
12:19:53 *******************************************************
12:19:53 You are attempting to build with an unsupported JDK.
12:19:53 
12:19:53 Only an OpenJDK based JDK is supported.
12:19:53 
12:19:53 Please follow the machine setup instructions at:
12:19:53     https://source.android.com/source/initializing.html
12:19:53 *******************************************************
12:19:53 stop
```

<details><summary> h </summary>

[zstd](https://facebook.github.io/zstd/)
* [comparison](https://engineering.fb.com/core-data/smaller-and-faster-data-compression-with-zstandard/)
* [benchmark](https://quixdb.github.io/squash-benchmark/)

LineageOS
* [the updater app stores zips in /data/lineageos_updates/](https://wiki.lineageos.org/faq.html#where-does-the-updater-app-store-the-downloaded-zip)
* [Build status](https://www.lineageoslog.com/build)

[Build LineageOS for angler](https://wiki.lineageos.org/devices/angler/build)
* angler tree
  * [device tree](https://github.com/LineageOS/android_device_huawei_angler)
  * [kernel](https://github.com/LineageOS/android_kernel_huawei_angler)

[Docker](https://www.docker.com/)
* Privileged is evil [<sup>O</sup>]() [<sup>O</sup>]() [<sup>O</sup>]() [<sup>O</sup>]() [<sup>O</sup>]()
* [Migration from docker to machine](https://circleci.com/docs/2.0/docker-to-machine/)
* [wikipedia](https://en.wikipedia.org/wiki/Docker_(software))
* [Travis guide](https://docs.travis-ci.com/user/docker/)
* [get into docker](https://stackoverflow.com/questions/30172605/how-do-i-get-into-a-docker-containers-shell)
* [SSH into docker](https://phase2.github.io/devtools/common-tasks/ssh-into-a-container/)
* CLI reference
  * [docker pull](https://docs.docker.com/engine/reference/commandline/pull/)
  * [docker run](https://docs.docker.com/engine/reference/commandline/run/)
  * [docker exec](https://docs.docker.com/engine/reference/commandline/exec/)

Check container capabilities
```bash
# https://stackoverflow.com/questions/46212787/how-to-correctly-report-available-ram-within-a-docker-container
cat /sys/fs/cgroup/memory/memory.limit_in_bytes
ls -Al /
df -h
```

</details>

