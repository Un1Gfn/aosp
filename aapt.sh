#!/bin/bash

# https://stackoverflow.com/questions/6289149/read-the-package-name-of-an-android-apk

test "$#" -ge 1 || exit 1

maxlen=-1

for APK in "$@"; do

  # echo "${APK}"
  # echo "${#APK}"
  test "${#APK}" -gt "$maxlen" && maxlen="${#APK}"

done

for APK in "$@"; do

  DUMP="$(aapt dump badging "$APK")"

  # https://stackoverflow.com/a/54259946
  # packageName="$(aapt2 dump packagename "$APK")"
  # printf "%-${maxlen}s %s\n" "$APK" "$packageName"

  # https://unix.stackexchange.com/a/326525
  # packageName="$(pcregrep <<<"$DUMP" -o1 "package: name='([a-zA-Z0-9_.]+)")"
  # versionCode="$(pcregrep <<<"$DUMP" -o1 "versionCode='([0-9]+)'")"
  # versionName="$(pcregrep <<<"$DUMP" -o1 "versionName='([^']+)'")"
  # printf "%-${maxlen}s %s - %s (%s)\n" "$APK" "$packageName" "$versionName" "$versionCode"

  # https://stackoverflow.com/a/33942340
  if [[ "$DUMP" =~ package:\ name=\'([a-zA-Z0-9_.]+)\'\ versionCode=\'([0-9]+)\'\ versionName=\'([^\']+)\' ]]; then
    printf "%-${maxlen}s %s - %s (%s)\n" "$APK" "${BASH_REMATCH[1]}" "${BASH_REMATCH[3]}" "${BASH_REMATCH[2]}"
  fi

done
