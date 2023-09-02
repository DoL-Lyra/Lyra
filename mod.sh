#!/bin/bash

# 1 1   1     1
# N N cheat beautify

#  echo $(( 3&1 )) = 1

VERSION=$1
MOD_CODE=$2

echo Start mod.sh $VERSION $MOD_CODE

ZIP_DIR=dolzip
APK_DIR=dolapk

OUTPUT_DIR=output
OUTPUT_SUFFIX=''
DATE_NOW=$(date -d "+8 hours" +%m%d)
if [ ! -d $OUTPUT_DIR ]; then
	mkdir $OUTPUT_DIR
fi

fun_zip() {
    FILE_NAME=$(basename dol*.zip)
    BASE_NAME=${FILE_NAME%.*}
    CHS_VER=${BASE_NAME##*chs-}
    unzip -q ${FILE_NAME} -d $ZIP_DIR

    fun_check_code

    OUTPUT_NAME="dol-chs-${CHS_VER}${OUTPUT_SUFFIX}-${DATE_NOW}.zip"

    cd $ZIP_DIR
    zip -q -r dol.zip *
    mv dol.zip ../$OUTPUT_DIR/$OUTPUT_NAME
    cd ..
}

fun_apk() {
    FILE_NAME=$(basename dol*.apk)
    BASE_NAME=${FILE_NAME%.*}
    CHS_VER=${BASE_NAME##*chs-}
    wget -nc -O apktool.jar https://github.com/iBotPeaches/Apktool/releases/download/v2.8.1/apktool_2.8.1.jar
    wget -nc -O uber-apk-signer.jar https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar

    java -jar apktool.jar d dol*.apk -o $APK_DIR

    sed -i 's/"com.vrelnir.DegreesOfLewdityWE"/"com.vrelnir.DegreesOfLewdityWE.chsmods"/g' $APK_DIR/AndroidManifest.xml

    sed -i 's/Degrees of Lewdity/DOL CHS MODS/g' $APK_DIR/res/values/strings.xml

    fun_check_code

    java -jar apktool.jar b $APK_DIR -o tmp.apk
    java -jar uber-apk-signer.jar -a tmp.apk --ks dol.jks --ksAlias dol --ksKeyPass dolchs --ksPass dolchs -o signed

    OUTPUT_NAME="dol-chs-${CHS_VER}${OUTPUT_SUFFIX}-${DATE_NOW}.apk"

    mv signed/*.apk $OUTPUT_DIR/$OUTPUT_NAME
}

fun_check_code() {
    if [ $(( MOD_CODE&1 )) -ne 0 ]
    then
        echo Start patch beautify...
        fun_apply_beautify $VERSION
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-beautify
        echo Complete patch beautify!
    fi
    if [ $(( MOD_CODE&2 )) -ne 0 ]
    then
        echo Start patch cheat...
        fun_apply_cheat $VERSION
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-cheat
        echo Complete patch cheat!
    fi
    if [ $(( MOD_CODE&4 )) -ne 0 ]
    then
        echo TODO
    fi
    if [ $(( MOD_CODE&8 )) -ne 0 ]
    then
        echo TODO
    fi
}

fun_apply_beautify() {
    case "$1" in
    "zip") IMG_PATH=$ZIP_DIR/img
    ;;
    "apk") IMG_PATH=$APK_DIR/assets/www/img
    ;;
    esac

    BEAUTIFY_DIR="beautify"
    fun_ext_beautify $BEAUTIFY_DIR
    cp -r $BEAUTIFY_DIR/img/* $IMG_PATH/
}

fun_apply_cheat() {
    case "$1" in
    "zip") HTML_PATH="$ZIP_DIR/Degrees of Lewdity.html"
    ;;
    "apk") HTML_PATH="$APK_DIR/assets/www/Degrees of Lewdity.html"
    ;;
    esac

    fun_cheat "${HTML_PATH}"
}

fun_ext_beautify() {
    mkdir $1
    cd $1
    wget -nc -O B-1.tar.gz https://gitgud.io/BEEESSS/degrees-of-lewdity-graphics-mod/-/archive/master/degrees-of-lewdity-graphics-mod-master.tar.gz
    wget -nc -O B-2.tar.gz https://gitgud.io/Kaervek/kaervek-beeesss-community-sprite-compilation/-/archive/master/kaervek-beeesss-community-sprite-compilation-master.tar.gz

    tar xf B-1.tar.gz degrees-of-lewdity-graphics-mod-master/img --strip-components 1
    tar xf B-2.tar.gz kaervek-beeesss-community-sprite-compilation-master/img --strip-components 1
    cd ..
}

fun_cheat() {
    sed -i 's/and \$cheatdisable is &quot;f&quot;//' "${1}"
}

case "$VERSION" in
    "zip") fun_zip
    ;;
    "apk") fun_apk
    ;;
esac