#!/bin/bash

# 使用二进制决定是否应用某MOD
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
# echo $(( 3&1 )) = 1

# 参数1 版本 (zip apk)
VERSION=$1
# 参数2 MOD代码
MOD_CODE=$2
# 参数3 可选，格式为月日，如 1231
if  [[ $3 == v* ]]; then
    DATE_NOW=$(echo $3 | cut -d'-' -f2)
else
    DATE_NOW=$(date -d "+8 hours" +%m%d)
fi

# 资源地址
# 工具
URL_APKTOOL=https://github.com/iBotPeaches/Apktool/releases/download/v2.8.1/apktool_2.8.1.jar
URL_APKSIGN=https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar
# 资源
URL_BEAUTIFY_1=https://gitgud.io/BEEESSS/degrees-of-lewdity-graphics-mod/-/archive/master/degrees-of-lewdity-graphics-mod-master.tar.gz
URL_BEAUTIFY_2=https://gitgud.io/Kaervek/kaervek-beeesss-community-sprite-compilation/-/archive/master/kaervek-beeesss-community-sprite-compilation-master.tar.gz
URL_AVATAR_2=https://gitgud.io/GTXMEGADUDE/papa-paril-burger-joint/-/raw/master/Paril_BJ_BEEESSS_Addon.rar

EXTRACT_DIR=extract # 解压目录
OUTPUT_DIR=output # 输出目录
OUTPUT_SUFFIX=''
if [ ! -d $OUTPUT_DIR ]; then
	mkdir $OUTPUT_DIR
fi

# ZIP
fun_zip() {
    FILE_NAME=$(basename dol*.zip)
    BASE_NAME=${FILE_NAME%.*}
    CHS_VER=${BASE_NAME##*chs-}
    unzip -q ${FILE_NAME} -d $EXTRACT_DIR

    fun_check_code

    OUTPUT_NAME="dol-chs-${CHS_VER}${OUTPUT_SUFFIX}-${DATE_NOW}.zip"

    pushd $EXTRACT_DIR
    zip -q -r dol.zip *
    mv dol.zip ../$OUTPUT_DIR/$OUTPUT_NAME
    popd

    # for generate markdown table
    echo "$OUTPUT_NAME" > $OUTPUT_DIR/${VERSION}_${MOD_CODE}
}

# APK
fun_apk() {
    FILE_NAME=$(basename dol*.apk)
    BASE_NAME=${FILE_NAME%.*}
    CHS_VER=${BASE_NAME##*chs-}
    wget -q -nc -O apktool.jar $URL_APKTOOL
    wget -q -nc -O uber-apk-signer.jar $URL_APKSIGN

    java -jar apktool.jar d dol*.apk -o $EXTRACT_DIR

    # 修改包名
    sed -i 's/"com.vrelnir.DegreesOfLewdityWE"/"com.vrelnir.DegreesOfLewdityWE.chsmods"/g' $EXTRACT_DIR/AndroidManifest.xml

    # 修改应用名
    sed -i 's/Degrees of Lewdity/DOL CHS MODS/g' $EXTRACT_DIR/res/values/strings.xml

    fun_check_code

    java -jar apktool.jar b $EXTRACT_DIR -o tmp.apk
    java -jar uber-apk-signer.jar -a tmp.apk --ks dol.jks --ksAlias dol --ksKeyPass dolchs --ksPass dolchs -o signed

    OUTPUT_NAME="dol-chs-${CHS_VER}${OUTPUT_SUFFIX}-${DATE_NOW}.apk"

    mv signed/*.apk $OUTPUT_DIR/$OUTPUT_NAME

    # for generate markdown table
    echo "$OUTPUT_NAME" > $OUTPUT_DIR/${VERSION}_${MOD_CODE}
}

# 处理MOD代码
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

# 美化
fun_beautify() {
    BEAUTIFY_DIR="beautify"
    mkdir $BEAUTIFY_DIR
    pushd $BEAUTIFY_DIR
    wget -q -nc -O B-1.tar.gz $URL_BEAUTIFY_1
    wget -q -nc -O B-2.tar.gz $URL_BEAUTIFY_2

    tar xf B-1.tar.gz degrees-of-lewdity-graphics-mod-master/img --strip-components 1
    tar xf B-2.tar.gz kaervek-beeesss-community-sprite-compilation-master/img --strip-components 1
    popd
    cp -r $BEAUTIFY_DIR/img/* $IMG_PATH/
}

# 作弊
fun_cheat() {
    sed -i 's/and \$cheatdisable is &quot;f&quot;//' "${HTML_PATH}"
}

# HP
fun_hp() {
    sed -i '/看起来无法承受更多的痛苦/{n;n;n;n;a\
    \n\t\t\tHP：&lt;&lt;= Math.round($enemyhealth) &gt;&gt;
    }' "${HTML_PATH}"
}

# 特写1
fun_avatar_type1() {
    unzip -q assets/얼굴추가.zip
    cp -r 얼굴추가/img/* $IMG_PATH/
}

# 特写2
fun_avatar_type2() {
    AVATAR2_DIR="avatar2"
    mkdir $AVATAR2_DIR
    pushd $AVATAR2_DIR
    wget -q -nc -O avatar.rar $URL_AVATAR_2
    unrar x avatar.rar -idq
    popd
    cp -r $AVATAR2_DIR/'Paril BJ BEEESSS Addon'/img/* $IMG_PATH/
}

# 入口
case "$VERSION" in
    "zip")
        IMG_PATH=$EXTRACT_DIR/img
        HTML_PATH="$EXTRACT_DIR/Degrees of Lewdity.html"
        fun_zip
    ;;
    "apk")
        IMG_PATH=$EXTRACT_DIR/assets/www/img
        HTML_PATH="$EXTRACT_DIR/assets/www/Degrees of Lewdity.html"
        fun_apk
    ;;
esac