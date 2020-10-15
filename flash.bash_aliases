#!/dev/null

# DO NOT ERASE BOOTLOADER

T="/sdcard/Download"
zip=${zip:-""}
code=${code:-""}
dir=${dir:-""}

######## ###

function confirm {
  test "$#" -eq 1 || return 1
  echo -n "$1"
  read -r
}

function adb_online {
  adb devices | grep --extended-regexp --regexp="^[0-9A-Z]{12}"$'\t'"device$" --silent
}

function adb_reboot_system {
  adb_online || return 1
  adb reboot
}

function adb_reboot_fastboot {
  adb_online || return 1
  adb reboot fastboot
}

function fastboot_online {
  fastboot devices | grep --extended-regexp --regexp="^[0-9A-Z]{12}"$'\t'"fastboot$" --silent
}

function fastboot_reboot_bootloader {
  fastboot_online || return 1
  fastboot reboot bootloader
}

function fastboot_reboot_system {
  fastboot_online || return 1
  fastboot reboot
}

######## ###

function zip_vars {
  test "$#" -eq 1 || { echo "${FUNCNAME[0]} <factory_image_zip_file>"; return 1; }
  test "$#" -eq 1 || return 1
  test -f "$1" || return 1
  zip=""
  code=""
  dir=""
  local GREP='/usr/bin/grep --color=never --extended-regexp --only-matching'
  zip="$($GREP --regexp="walleye-[a-z]{2}[0-9]{1}[a-z]\.[0-9]{6}\.[0-9]{3}-factory-[0-9a-z]{8}\.zip" <<<"$1")"
  test \( "$?" -eq 0 \) -a \( "$zip" = "$1" \) || { echo "invalid zip"; return 1; }
  code="$($GREP --regexp="[a-z]{2}[0-9]{1}[a-z]\.[0-9]{6}\.[0-9]{3}" <<<"$1")"
  test \( "$?" -eq 0 \) -a \( -n "$code" \) || { echo "invalid code"; return 1; }
  dir="walleye-$code"
  echo "zip=$zip"
  echo "code=$code"
  echo "dir=$dir"
}

function unzip_factory {
  test \( -n "$zip" \) -a \( -n "$code" \) -a \( -n "$dir" \) || { echo "run zip_vars first"; return 1; }
  echo -n "checksum..."
  S0="$(grep --fixed-strings --regexp="$zip" sha256sum.txt)"
  S="$(sha256sum "$zip")"
  echo
  test "$S0" = "$S" || return 1
  if [ -e "$dir" ]; then
    echo "$dir/ exists"
    return 1
  fi
  # echo OK
  unzip "$zip" # bootloader radio
  pushd "$dir"/ || return 1
  unzip image-walleye-"$code".zip # boot dtbo system system system_other vbmeta vendor
  popd || return 1
  echo
  tree -aC "$dir"/
  echo
}

function fastboot_erase {
  # DO NOT ERASE BOOTLOADER
  trap 'trap ERR; return' ERR
  fastboot_online
  for i in a b; do
    fastboot erase boot_${i}
    fastboot erase dtbo_${i}
    fastboot erase -w system_${i}
    fastboot erase vbmeta_${i}
    fastboot erase vendor_${i}
  done
  fastboot erase userdata
  fastboot format userdata
  fastboot set_active a
  trap ERR
}

function fastboot_flash_factory {
  # DO NOT ERASE BOOTLOADER
  # https://source.android.com/security/verifiedboot/verify-system-other-partition
  # https://www.reddit.com/r/GooglePixel/comments/7hwhma/81_factory_images_system_otherimg_2xl/dqucxy9?utm_source=share&utm_medium=web2x
  trap 'trap ERR; return' ERR
  fastboot_online
  fastboot --slot all flash bootloader "$dir"/bootloader-walleye-??????-???.????.??.img
  fastboot_reboot_bootloader
  fastboot --slot all flash boot       "$dir"/boot.img
  fastboot --slot all flash dtbo       "$dir"/dtbo.img
  fastboot --slot all flash radio      "$dir"/radio-walleye-g8998-?????-??????????.img
  fastboot --slot all flash vbmeta     "$dir"/vbmeta.img
  fastboot --slot all flash vendor     "$dir"/vendor.img
  fastboot --slot b   flash system     "$dir"/system_other.img
  fastboot --slot a   flash -w system  "$dir"/system.img
  trap ERR
}

function adb_push_owner {
  unpatched="$dir/boot.img"
  test \( -f "$unpatched" \) || { echo "$unpatched is not a regular file"; return 1; }
  adb_online || return 1
  confirm "remove $T ?" || return 1
  adb shell rm -rv -- "$T"
  adb shell mkdir -v -- "$T"
  # https://github.com/topjohnwu/Magisk#downloads -> Magisk Manager Canary -> app-debug.apk
  # Telegram -> rixcloud.ss-android -> profiles.json
  adb push -- \
    app-debug.apk \
    "$unpatched" \
    shadowsocks-arm64-v8a-5.1.3.apk \
    profiles.json \
  "$T"/
}

function adb_pull_patched_boot_img {
  adb_online || return 1
  adb pull /sdcard/Download/magisk_patched.img
}

function fastboot_flash_patched_boot_img {
  fastboot_online || return 1
  fastboot --slot a flash boot magisk_patched.img
}

function adb_push_user {
  # https://sj.qq.com/ -> 手機版應用寶 -> MobileAssistant_1.apk
  adb push -- MobileAssistant_1.apk "$T"/
}

function verify_a_b_and_system_as_root {
  # https://topjohnwu.github.io/Magisk/install.html#knowing-your-device
  adb_online || return 1
  AB="$(adb shell getprop ro.build.ab_update)"
  SAR="$(adb shell getprop ro.build.system_root_image)"
  echo "${AB:-false} ${SAR:-false}"
  # true true
}
