#!/dev/null

# DO NOT ERASE BOOTLOADER

T="/sdcard/Download"
zip=${zip:-""}
code=${code:-""}
dir=${dir:-""}

PS1_ORIG='[\u@\h \W]\$ '

export PROMPT_COMMAND=prompt_command

function prompt_command {
  local R=$?
  if [ "$R" -ne 0 ]; then
    # PS1="\e[1;31m$R\e[0m|$PS1_ORIG"
    PS1="\[\e[1;31m\]$R\[\e[0m\]|$PS1_ORIG"
  else
    # PS1="\e[1;32m$R\e[0m|$PS1_ORIG"
    PS1="\[\e[1;32m\]$R\[\e[0m\]|$PS1_ORIG"
  fi
}

# checksum <md5|sha1|sha256> <file>
function checksum {
  test \
    "$#" -eq 2 -a \
    -f "$2" -a \
    \( \
      "$1" = "md5" -o \
      "$1" = "sha1" -o \
      "$1" = "sha256" \
    \) || return 1
  local DB="${1}sum.txt"
  local SUM_DB
  local SUM
  SUM_DB="$(grep --fixed-strings --regexp="$2" "$DB")"
  SUM="$("${1}sum" "$2")"
  test "$SUM_DB" = "$SUM" || return 1
  echo "$2 matches checksum in $DB"
}

function confirm {
  test "$#" -eq 1 || return 1
  echo -n "$1"
  read -r
}

function adb_online {
  adb devices | grep --extended-regexp \
    --regexp="^[0-9A-Z]{12}"$'\t'"device$" \
    --regexp="^[0-9A-Z]{16}"$'\t'"device$" \
    --regexp="^[0-9A-Z]{16}"$'\t'"recovery$" \
  --silent
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
  fastboot devices | grep --extended-regexp --regexp="^[0-9A-Z]{12,16}"$'\t'"fastboot$" --silent
}

# function angler_fastboot_reboot_recovery {
#   fastboot_online || return 1
#   fastboot reboot recovery
# }

function fastboot_reboot_bootloader {
  fastboot_online || return 1
  fastboot reboot bootloader
}

function fastboot_reboot_system {
  fastboot_online || return 1
  fastboot reboot
}

# walleye_zip_vars <factory_image_zip_file>
function walleye_vars {
  test "$#" -eq 1 -a -f "$1" || return 1
  zip=""
  code=""
  dir=""
  local WALLEYE_REGEXP_CODE="[a-z]{2}[0-9]{1}[a-z]\.[0-9]{6}\.[0-9]{3}"
  local WALLEYE_REGEXP_ZIP="walleye-$REGEXP_CODE-factory-[0-9a-z]{8}\.zip"
  local GREP='/usr/bin/grep --color=never --extended-regexp --only-matching'
  zip="$($GREP --regexp="$WALLEYE_REGEXP_ZIP" <<<"$1")"
  test \( "$?" -eq 0 \) -a \( "$zip" = "$1" \) || { echo "invalid zip"; return 1; }
  code="$($GREP --regexp="$WALLEYE_REGEXP_CODE" <<<"$1")"
  test \( "$?" -eq 0 \) -a \( -n "$code" \) || { echo "invalid code"; return 1; }
  dir="walleye-$code"
  echo "zip=$zip"
  echo "code=$code"
  echo "dir=$dir"
}

# angler-opm7.181205.001/image-angler-opm7.181205.001.zip
function angler_vars {
  code="opm7.181205.001"
  dir="angler-$code"
  zip="angler-$code-factory-b75ce068.zip"
  test "$#" -eq 0 -a -f "$zip" || return 1
  echo "code=$code"
  echo "dir=$dir"
  echo "zip=$zip"
}

function walleye_unzip_factory {
  test -n "$zip" -a -n "$code" -a -n "$dir" || { echo "run walleye_vars first"; return 1; }
  echo -n "checksum..."
  checksum "sha256" "$zip" || return 1
  if [ -e "$dir" ]; then
    echo "$dir/ exists"
    return 1
  fi
  unzip "$zip" # bootloader radio
  pushd "$dir"/ || return 1
  unzip image-walleye-"$code".zip # boot dtbo system system system_other vbmeta vendor
  popd || return 1
  echo
  tree -aC "$dir"/
  echo
}

function angler_unzip_factory {
  test -n "$zip" -a -n "$code" -a -n "$dir" || { echo "run angler_vars first"; return 1; }
  echo -n "checksum..."
  checksum "sha1" "$zip" || return 1
  test -e "$dir" && { echo "$dir/ exists"; return 1; }
  unzip "$zip" # bootloader radio
  pushd "$dir"/ || return 1
  unzip image-angler-"$code".zip # boot recovery system vendor
  popd || return 1
  echo
  tree -aC "$dir"/
  echo
}

function walleye_fastboot_erase {
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

function angler_fastboot_erase {
  # DO NOT ERASE BOOTLOADER
  trap 'trap ERR; return' ERR
  fastboot_online
  fastboot erase boot
  fastboot erase cache
  fastboot erase recovery
  fastboot erase vendor
  fastboot erase system -w
  fastboot erase userdata
  fastboot format system
  fastboot format userdata
  trap ERR
}

function walleye_fastboot_flash_factory {
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

function angler_fastboot_flash_blob {
  # DO NOT ERASE BOOTLOADER
  trap 'trap ERR; return' ERR
  fastboot_online
  fastboot flash bootloader "$dir"/bootloader-angler-angler-03.84.img
  fastboot_reboot_bootloader
  fastboot flash radio      "$dir"/radio-angler-angler-03.88.img
  fastboot flash vendor     "$dir"/vendor.img
  trap ERR
}

function angler_fastboot_flash_twrp {
  # DO NOT ERASE BOOTLOADER
  trap 'trap ERR; return' ERR
  fastboot_online
  local twrp_img="twrp-3.4.0-0-angler.img"
  sha256sum -c "$twrp_img.sha256"
  fastboot flash recovery "$twrp_img"
  trap ERR
}

function angler_adb_push_zip {
  adb_online || return 1
  local lineage_zip="lineage-17.1-20200819-UNOFFICIAL-angler.zip"
  local opengapps_zip="open_gapps-arm64-10.0-pico-20201023.zip"
  checksum "md5" "$lineage_zip"
  md5sum --check "$opengapps_zip.md5"
  confirm "remove $T ?" || return 1
  adb shell rm -rv -- "$T"
  adb shell mkdir -v -- "$T"
  adb push -- \
    "$lineage_zip" \
    "$opengapps_zip" \
  "$T"
}

function adb_push_owner {
  unpatched="$dir/boot.img"
  test -f "$unpatched" || return 1
  adb_online || return 1
  confirm "remove $T ?" || return 1
  adb shell rm -rv -- "$T"
  adb shell mkdir -v -- "$T"
  # https://github.com/topjohnwu/magisk_files/blob/canary/app-debug.apk
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