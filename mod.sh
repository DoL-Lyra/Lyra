#!/bin/bash
# 128 64 32    16    8    4    2   1
# N   N   N   特写2 特写1 HP 作弊 美化

# 美化 1
# 美化+作弊 3
# 美化+HP 5
# 美化+作弊+HP 7
# 美化+特写1 9
# 美化+特写1+作弊 11
# 美化+HP+特写1 13
# 美化+HP+特写1+作弊 15
# 美化+特写2 17
# 美化+特写2+作弊 19
# 美化+HP+特写2 21
# 美化+HP+特写2+作弊 23

#  echo $(( 3&1 )) = 1

VERSION=$1
MOD_CODE=$2

# echo Start mod.sh $VERSION $MOD_CODE

OUTPUT_DIR=output
OUTPUT_SUFFIX=''
if [ ! -d $OUTPUT_DIR ]; then
	mkdir $OUTPUT_DIR
fi

if  [[ $3 == v* ]]; then
    DATE_NOW=$(echo $3 | cut -d'-' -f2)
else
    DATE_NOW=$(date -d "+8 hours" +%m%d)
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

    # for generate markdown table
    echo "$OUTPUT_NAME" > $OUTPUT_DIR/${VERSION}_${MOD_CODE}
}

fun_apk() {
    FILE_NAME=$(basename dol*.apk)
    BASE_NAME=${FILE_NAME%.*}
    CHS_VER=${BASE_NAME##*chs-}
    wget -q -nc -O apktool.jar https://github.com/iBotPeaches/Apktool/releases/download/v2.8.1/apktool_2.8.1.jar
    wget -q -nc -O uber-apk-signer.jar https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar

    java -jar apktool.jar d dol*.apk -o $APK_DIR

    sed -i 's/"com.vrelnir.DegreesOfLewdityWE"/"com.vrelnir.DegreesOfLewdityWE.chsmods"/g' $APK_DIR/AndroidManifest.xml

    sed -i 's/Degrees of Lewdity/DOL CHS MODS/g' $APK_DIR/res/values/strings.xml

    fun_check_code

    java -jar apktool.jar b $APK_DIR -o tmp.apk
    java -jar uber-apk-signer.jar -a tmp.apk --ks dol.jks --ksAlias dol --ksKeyPass dolchs --ksPass dolchs -o signed

    OUTPUT_NAME="dol-chs-${CHS_VER}${OUTPUT_SUFFIX}-${DATE_NOW}.apk"

    mv signed/*.apk $OUTPUT_DIR/$OUTPUT_NAME

    # for generate markdown table
    echo "$OUTPUT_NAME" > $OUTPUT_DIR/${VERSION}_${MOD_CODE}
}

fun_check_code() {
    if [ $(( MOD_CODE&1 )) -ne 0 ]
    then
        echo Start patch beautify...
        fun_beautify
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-beautify
        echo Complete patch beautify!
    fi
    if [ $(( MOD_CODE&2 )) -ne 0 ]
    then
        echo Start patch cheat...
        fun_cheat
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-cheat
        echo Complete patch cheat!
    fi
    if [ $(( MOD_CODE&4 )) -ne 0 ]
    then
        echo Start patch HP...
        fun_hp
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-hp
        echo Complete patch HP!
    fi
    if [ $(( MOD_CODE&8 )) -ne 0 ]
    then
        echo Start patch avatar type 1...
        fun_avatar_type1
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-avatar1
        echo Complete patch avatar type 1!
    fi
    if [ $(( MOD_CODE&16 )) -ne 0 ]
    then
        echo Start patch avatar type 2...
        fun_avatar_type2
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-avatar2
        echo Complete patch avatar type 2!
    fi
}

fun_beautify() {
    BEAUTIFY_DIR="beautify"
    mkdir $BEAUTIFY_DIR
    cd $BEAUTIFY_DIR
    wget -q -nc -O B-1.tar.gz https://gitgud.io/BEEESSS/degrees-of-lewdity-graphics-mod/-/archive/master/degrees-of-lewdity-graphics-mod-master.tar.gz
    wget -q -nc -O B-2.tar.gz https://gitgud.io/Kaervek/kaervek-beeesss-community-sprite-compilation/-/archive/master/kaervek-beeesss-community-sprite-compilation-master.tar.gz

    tar xf B-1.tar.gz degrees-of-lewdity-graphics-mod-master/img --strip-components 1
    tar xf B-2.tar.gz kaervek-beeesss-community-sprite-compilation-master/img --strip-components 1
    cd ..
    cp -r $BEAUTIFY_DIR/img/* $IMG_PATH/
}

fun_cheat() {
    sed -i 's/and \$cheatdisable is &quot;f&quot;//' "${HTML_PATH}"
}

fun_hp() {
    sed -i '/看起来无法承受更多的痛苦/{n;n;n;n;a\
    \n\t\t\tHP：&lt;&lt;= Math.round($enemyhealth) &gt;&gt;
    }' "${HTML_PATH}"
}

fun_avatar_type1() {
    unzip -q assets/얼굴추가.zip
    cp -r 얼굴추가/img/* $IMG_PATH/
}

fun_avatar_type2() {
    AVATAR2_DIR="avatar2"
    mkdir $AVATAR2_DIR
    cd $AVATAR2_DIR
    wget -q -nc -O avatar.rar https://gitgud.io/GTXMEGADUDE/papa-paril-burger-joint/-/raw/master/Paril_BJ_BEEESSS_Addon.rar
    unrar x avatar.rar
    cd ..
    cp -r $AVATAR2_DIR/'Paril BJ BEEESSS Addon'/img/* $IMG_PATH/
}

case "$VERSION" in
    "zip")
        ZIP_DIR=dolzip
        IMG_PATH=$ZIP_DIR/img
        HTML_PATH="$ZIP_DIR/Degrees of Lewdity.html"
        fun_zip
    ;;
    "apk")
        APK_DIR=dolapk
        IMG_PATH=$APK_DIR/assets/www/img
        HTML_PATH="$APK_DIR/assets/www/Degrees of Lewdity.html"
        fun_apk
    ;;
esac