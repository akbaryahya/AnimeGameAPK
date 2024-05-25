#!/bin/bash

echo "Create Proxy APK"
./gradlew assembleRelease

echo "Add Fake Signed"
java -jar tool/uber-apk-signer.jar -a app/build/outputs/apk/release/app-release-unsigned.apk

auto=true
install_to_phone=true

if ($auto); then
    file_apk="apk/official/46/ys/yuanshen_4.6.0/dist/46.apk"
    file_final="apk/final/YuukiPS_YS_46.apk"
    file_out="apk/out/46-387-lspatched.apk"
    file_our="app/build/outputs/apk/release/app-release-aligned-debugSigned.apk"

    echo "Tried Patching Mod APK with Proxy APK"
    java -jar tool/lspatch.jar $file_apk -m $file_our -o apk/out -f || echo "Failed to Patch Mod APK with Proxy APK"

    echo "Rename file..."
    mv $file_out $file_final || echo -e "Failed to rename file\nFile: $file_out\nTo: $file_final\nNot found" 

    if ($install_to_phone); then
     echo "Trying to install on phone (Final)"
     adb install -r "$(PWD)/$file_final"
    fi

fi