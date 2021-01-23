
```bash

# https://wiki.archlinux.org/index.php/Android#Java_Development_Kit
# https://wiki.archlinux.org/index.php/Java#Launching_an_application_with_the_non-default_java_version
# https://source.android.com/setup/build/older-versions#jdk
# export ANDROID_HOME=/opt/android-sdk/
export PATH=/usr/lib/jvm/java-11-openjdk/jre/bin/:$PATH
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk/
export PATH=/usr/lib/jvm/java-10-openjdk/jre/bin/:$PATH
export JAVA_HOME=/usr/lib/jvm/java-10-openjdk/
JAVA_HOME=/usr/lib/jvm/java-8-openjdk/ sdkmanager --licenses
./gradlew --stop
time ./gradlew -DsocksProxyHost=127.0.0.1 -DsocksProxyPort=1080 assembleRelease

# https://developer.android.com/studio/command-line/apksigner
# https://stackoverflow.com/a/14273074/8243991
# https://developer.android.com/studio/build/building-cmdline#sign_cmdline
export PATH=$PATH:/opt/android-sdk/build-tools/28.0.3
yes | keytool -genkeypair -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-alias -storepass 000000
zipalign -v -p 4 *.apk my-app-unsigned-aligned.apk
# echo 000000 | apksigner sign --ks my-release-key.jks --out my-app-release.apk my-app-unsigned-aligned.apk
apksigner sign --ks my-release-key.jks --ks-pass pass:000000 --out my-app-release.apk my-app-unsigned-aligned.apk

# CircleCi
export PATH=$PATH:/opt/android/sdk/build-tools/28.0.3/

yes \
  | keytool \
  -genkeypair \
  -alias my-alias \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -keypass 000000 \
  -keystore my-release-key.jks \
  -storepass 000000 \
  -v

for i in {mobile,tv}/build/outputs/apk/release/*.apk; do
  ORIG="$i"
  ALIGNED="${i%-unsigned.apk}-unsigned-aligned.apk"
  SIGNED="${i%-unsigned.apk}-signed-aligned.apk"
  # echo $ORIG
  # echo $ALIGNED
  # echo $SIGNED
  zipalign -v -p 4 $ORIG $ALIGNED
  apksigner sign --ks my-release-key.jks --ks-pass pass:000000 --out $SIGNED $ALIGNED
  # read -r
done

cp -v my-release-key.jks mobile/build/outputs/apk/release/
cp -v my-release-key.jks tv/build/outputs/apk/release/
rm -fv my-release-key.jks
```
