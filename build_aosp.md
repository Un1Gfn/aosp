CircleCI
* [Pipelines](https://app.circleci.com/pipelines/github/Un1Gfn/lineage)
* [Caching Dependencies](https://circleci.com/docs/2.0/caching/)
* [Configuring CircleCI](https://circleci.com/docs/2.0/configuration-reference/#run)

Build AOSP w/ 8GiB RAM
* http://www.2net.co.uk/blog/jack-server.html
* https://stackoverflow.com/questions/35579646/android-source-code-compile-error-try-increasing-heap-size-with-java-option

Debian/Ubuntu
* [J\*](https://askubuntu.com/questions/150057/how-can-i-tell-what-version-of-java-i-have-installed)
* [alternatives system](https://wiki.debian.org/DebianAlternatives)
* tell which package provide FILE `dpkg -S FILE`
* tell which files are provided by PACKAGE `dpkg -L PACKAGE`

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

[zstd](https://facebook.github.io/zstd/)
* [comparison](https://engineering.fb.com/core-data/smaller-and-faster-data-compression-with-zstandard/)
* [benchmark](https://quixdb.github.io/squash-benchmark/)
>xz(1): Threaded decompression hasn't been implemented yet
```bash
su -c "
  sync
  sleep 1
  fstrim -av
  sleep 1
  echo 3 >/proc/sys/vm/drop_caches
  sleep 1
" - root

ls -lh linux-5.6.4.tar.xz
# 107M

/usr/bin/time -f "%E" tar xf linux-5.6.4.tar.xz
# 0:16.67
# 0:16.49

/usr/bin/time -f "%E" tar -c --zstd -f linux-linux-5.6.4.tar.zst linux-5.6.4/
# 0:19.43 0:21.88

tar -cf - linux-5.6.4/ | /usr/bin/time -f "%E" zstd -T2 >linux-linux-5.6.4.tar.zst
# 0:19.27

ls -lh linux-linux-5.6.4.tar.zst
# 163M

/usr/bin/time -f "%E" tar xf linux-linux-5.6.4.tar.zst
# 0:10.21

ls -l linux-5.6.4/
# Apr 13
```

tmux
* Detach: <kbd>Ctrl</kbd>+<kbd>b</kbd> <kbd>d</kbd>
* Scroll: <kbd>Ctrl</kbd>+<kbd>b</kbd> <kbd>[</kbd>

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

```bash
sudo -i docker exec -w / -i arch /bin/ls -Al /
sudo -i docker exec -w / -i arch /bin/ls -Al
sudo -i docker exec -w / -it arch /bin/bash
sudo -i docker kill arch
sudo -i docker rm arch
```

```yaml
- run:
    name: "[D] rc"
      $docker_exec rm -fv "BASH_ENV_DOCKER"
      echo "export RAM=$RAM" | $docker_exec tee "$BASH_ENV_DOCKER"
      cat <<"EOF" | $docker_exec tee "$BASH_ENV_DOCKER"
      export _JAVA_OPTIONS="-Xmx$RAM"
      export  update="pacman -Syy --noprogressbar"
      export   unreg="pacman -D --asdeps"
      export partial="pacman -S --needed --nodeps --noprogressbar --noconfirm" # one --nodeps skip ver chk only
      export      gc="pacman -Rssc --noprogressbar --noconfirm $(pacman -Qdttq)"
      export upgrade="pacman -Suu --noprogressbar --noconfirm"
      EOF
```
