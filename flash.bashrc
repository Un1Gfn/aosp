#!/dev/null
# This script should be sourced instead of executed

# DO NOT ERASE ANYTHONG

# Keep vars in case this script is sourced multiple times
T="/storage/emulated/0/Download"
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

function checksum {
  test \
    "$#" -eq 2 -a \
    -f "$2" -a \
    \( \
      "$1" = "md5" -o \
      "$1" = "sha1" -o \
      "$1" = "sha256" \
    \) || { echo "${FUNCNAME[0]} <md5|sha1|sha256> <file>"; return 1; }
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

function walleye_factory_vars {
  test "$#" -eq 1 -a -f "$1" || { echo "${FUNCNAME[0]} <factory_zip>"; return 1; }
  zip=""
  code=""
  dir=""
  local REGEXP_CODE="[a-z][a-z][0-9][a-z]\.[0-9]{6}\.[0-9]{3}\.[a-z][0-9]"
  local REGEXP_ZIP="walleye-$REGEXP_CODE-factory-[0-9a-z]{8}\.zip"
  local GREP='/usr/bin/grep --color=never --extended-regexp --only-matching'
  # $GREP --regexp="$REGEXP_ZIP" <<<"$1"
  # $GREP --regexp="$REGEXP_CODE" <<<"$1"
  zip="$($GREP --regexp="$REGEXP_ZIP" <<<"$1")"
  test \( "$?" -eq 0 \) -a \( "$zip" = "$1" \) || { echo "invalid zip"; return 1; }
  code="$($GREP --regexp="$REGEXP_CODE" <<<"$1")"
  test \( "$?" -eq 0 \) -a \( -n "$code" \) || { echo "invalid code"; return 1; }
  dir="walleye-$code"
  echo "zip=$zip"
  echo "code=$code"
  echo "dir=$dir"
}

function walleye_unzip_factory {
  test -n "$zip" -a -n "$code" -a -n "$dir" || { echo "run walleye_factory_vars first"; return 1; }
  echo
  if [ -e "$dir" ]; then
    echo "$dir exists"
    echo
  else
    echo -n "checksum..."
    checksum "sha256" "$zip" || return 1
    unzip "$zip" # bootloader radio
    pushd "$dir"/ || return 1
    unzip image-walleye-"$code".zip # boot dtbo system system system_other vbmeta vendor
    popd || return 1
    echo
  fi
  tree -aC "$dir"/
  echo
}

function fastboot_flash_factory_walleye {
  # DO NOT ERASE ANYTHONG
  # https://source.android.com/security/verifiedboot/verify-system-other-partition
  # https://www.reddit.com/r/GooglePixel/comments/7hwhma/81_factory_images_system_otherimg_2xl/dqucxy9?utm_source=share&utm_medium=web2x
  # trap 'trap ERR; return' ERR
  fastboot --slot all flash bootloader "$dir"/bootloader-walleye-??????-???.????.??.img; echo
  echo -n "Please manually disconnect walleye, poweroff, boot to bootloader, and connect again "; read -r; echo
  fastboot --slot all flash boot       "$dir"/boot.img; echo
  fastboot --slot all flash dtbo       "$dir"/dtbo.img; echo
  fastboot --slot all flash radio      "$dir"/radio-walleye-g8998-?????-??????????.img; echo
  fastboot --slot all flash vbmeta     "$dir"/vbmeta.img; echo
  fastboot --slot all flash vendor     "$dir"/vendor.img; echo
  fastboot --slot b   flash system     "$dir"/system_other.img; echo
  fastboot --slot a   flash -w system  "$dir"/system.img; echo
  # trap ERR
  echo "Please scroll back and carefully check if anything has failed"; echo
}

################################################################################

################################################################################


function adb_push_owner {
  local unpatched="$dir/boot.img"
  test -f "$unpatched" || { echo "$unpatched not found"; return 1; }
  adb shell rm -v -- "$T/$unpatched"
  adb push -- \
    app-debug.apk \
    "$unpatched" \
    shadowsocks-arm64-v8a-5.1.3.apk \
    profiles.json \
  "$T"/
}

function adb_push_user {
  # https://sj.qq.com/ -> 手機版應用寶 -> MobileAssistant_1.apk
  adb push -- MobileAssistant_1.apk "$T"/
}

function verify_a_b_and_system_as_root {
  # https://topjohnwu.github.io/Magisk/install.html#knowing-your-device
  AB="$(adb shell getprop ro.build.ab_update)"
  SAR="$(adb shell getprop ro.build.system_root_image)"
  echo "${AB:-false} ${SAR:-false}"
  # true true
}

echo -ne "\033]0;flash\007"
