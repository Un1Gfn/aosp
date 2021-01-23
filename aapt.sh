#!/bin/bash

test "$#" -ge 1 || exit 1

maxlen=-1

for APK in "$@"; do

  # echo "${APK}"
  # echo "${#APK}"
  test "${#APK}" -gt "$maxlen" && maxlen="${#APK}"

done

for APK in "$@"; do

  DUMP="$(aapt dump badging "$APK")"

  # https://unix.stackexchange.com/a/326525
  packageName="$(pcregrep <<<"$DUMP" -o1 "package: name='([a-zA-Z0-9_.]+)")"
  versionCode="$(pcregrep <<<"$DUMP" -o1 "versionCode='([0-9]+)'")"
  versionName="$(pcregrep <<<"$DUMP" -o1 "versionName='([^']+)'")"

  printf "%-${maxlen}s %s - %s (%s)\n" "$APK" "$packageName" "$versionName" "$versionCode"

done
