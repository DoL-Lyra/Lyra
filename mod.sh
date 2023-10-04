#!/bin/bash

# 128 64 32    16      8    4    2   1
# N   N   N   KR特写 BJ特写 HP 作弊 美化

# 美化 1
# 美化+作弊 3
# 美化+HP 5
# 美化+作弊+HP 7
# 美化+BJ特写 9
# 美化+BJ特写+作弊 11
# 美化+HP+BJ特写 13
# 美化+HP+BJ特写+作弊 15
# 美化+KR特写 17
# 美化+KR特写+作弊 19
# 美化+HP+KR特写 21
# 美化+HP+KR特写+作弊 23

# 参数1 包类型 (zip apk)
VERSION=$1
# 参数2 MOD代码
MOD_CODE=$2
# 参数3 可选，格式为月日，如 1231
DATE_PARAM=$3
if  [[ $DATE_PARAM == v* ]]; then
    DATE_NOW=$(echo $DATE_PARAM | awk -F- '{print $NF}')
else
    DATE_NOW=$(date -d "+8 hours" +%m%d)
fi

# 资源地址
# 工具
URL_APKTOOL=https://github.com/iBotPeaches/Apktool/releases/download/v2.8.1/apktool_2.8.1.jar
URL_APKSIGN=https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar
# 资源
URL_BEAUTIFY_1=https://gitgud.io/BEEESSS/degrees-of-lewdity-graphics-mod/-/raw/master/img.zip
URL_BEAUTIFY_2=https://gitgud.io/Kaervek/kaervek-beeesss-community-sprite-compilation/-/archive/master/kaervek-beeesss-community-sprite-compilation-master.tar.gz
#URL_AVATAR_BJ=https://gitgud.io/GTXMEGADUDE/papa-paril-burger-joint/-/raw/master/Paril_BJ_BEEESSS_Addon.rar
URL_AVATAR_BJ=https://gitgud.io/GTXMEGADUDE/papa-paril-burger-joint/-/raw/be9c9af63349beb811775f7802f06915dede290a/Paril_BJ_BEEESSS_Addon.rar

EXTRACT_DIR=extract # 解压目录
OUTPUT_DIR=output # 输出目录
if [ ! -d $OUTPUT_DIR ]; then
	mkdir $OUTPUT_DIR
fi

fun_name() {
    OUTPUT_PREFIX='' # 文件名前缀
    OUTPUT_SUFFIX='' # 文件名后缀
    BASE_NAME=${FILE_NAME%.*}
    DOL_VER=$(echo $BASE_NAME | cut -d '-' -f 2)
    CHS_VER=$(echo $BASE_NAME | cut -d '-' -f 4)
    OUTPUT_PREFIX="dol-chs-${CHS_VER}"
    OUTPUT_PREFIX="${OUTPUT_PREFIX//'alpha'/'a'}"
    OUTPUT_PREFIX="${OUTPUT_PREFIX//'beta'/'b'}"
}

# ZIP
fun_zip() {
    unzip -q ${FILE_NAME} -d $EXTRACT_DIR

    fun_check_code

    OUTPUT_NAME="${OUTPUT_PREFIX}${OUTPUT_SUFFIX}-${DATE_NOW}.zip"
    echo $OUTPUT_NAME

    pushd $EXTRACT_DIR
    zip -q -r dol.zip *
    mv dol.zip ../$OUTPUT_DIR/$OUTPUT_NAME
    popd

    # for generate markdown table
    echo "$OUTPUT_NAME" > $OUTPUT_DIR/${VERSION}_${MOD_CODE}
}

# APK
fun_apk() {
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

    OUTPUT_NAME="${OUTPUT_PREFIX}${OUTPUT_SUFFIX}-${DATE_NOW}.apk"
    echo $OUTPUT_NAME

    mv signed/*.apk $OUTPUT_DIR/$OUTPUT_NAME

    # for generate markdown table
    echo "$OUTPUT_NAME" > $OUTPUT_DIR/${VERSION}_${MOD_CODE}
}

# 处理MOD代码
fun_check_code() {
    if [ $(( MOD_CODE&1 )) -ne 0 ]
    then
        echo 1-Start patch beautify...
        fun_beautify
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-beautify
        echo 1-Complete patch beautify!
    fi
    if [ $(( MOD_CODE&2 )) -ne 0 ]
    then
        echo 2-Start patch cheat...
        fun_cheat
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-cheat
        echo 2-Complete patch cheat!
    fi
    if [ $(( MOD_CODE&4 )) -ne 0 ]
    then
        echo 4-Start patch HP...
        fun_hp
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-hp
        echo 4-Complete patch HP!
    fi
    if [ $(( MOD_CODE&8 )) -ne 0 ]
    then
        echo 8-Start patch avatar type BJ...
        fun_avatar_bj
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-avatarbj
        echo 8-Complete patch avatar type BJ!
    fi
    if [ $(( MOD_CODE&16 )) -ne 0 ]
    then
        echo 16-Start patch avatar type kr...
        fun_avatar_kr
        OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-avatarkr
        echo 16-Complete patch avatar type kr!
    fi
}

# 美化
fun_beautify() {
    BEAUTIFY_DIR="beautify"
    mkdir $BEAUTIFY_DIR
    pushd $BEAUTIFY_DIR
    wget -q -nc -O B-1.zip $URL_BEAUTIFY_1
    wget -q -nc -O B-2.tar.gz $URL_BEAUTIFY_2

    unzip -q B-1.zip
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
    sed -i "/看起来无法承受更多的痛苦/{n;n;n;n
    ;r assets/HP.patch
    }" "${HTML_PATH}"
}

# BJ特写
fun_avatar_bj() {
    AVATARBJ_DIR="avatarbj"
    mkdir $AVATARBJ_DIR
    pushd $AVATARBJ_DIR
    wget -q -nc -O avatar.rar $URL_AVATAR_BJ
    unrar x avatar.rar -idq
    popd
    cp -r $AVATARBJ_DIR/'Paril BJ BEEESSS Addon'/img/* $IMG_PATH/
}

# KR特写
fun_avatar_kr() {
    unzip -q assets/얼굴추가.zip
    cp -r 얼굴추가/img/* $IMG_PATH/
}

# 入口
case "$VERSION" in
    "zip")
        FILE_NAME=$(basename dol*.zip)
        fun_name
        IMG_PATH=$EXTRACT_DIR/img
        HTML_PATH="$EXTRACT_DIR/Degrees of Lewdity.html"
        fun_zip
    ;;
    "apk")
        FILE_NAME=$(basename dol*.apk)
        fun_name
        IMG_PATH=$EXTRACT_DIR/assets/www/img
        HTML_PATH="$EXTRACT_DIR/assets/www/Degrees of Lewdity.html"
        fun_apk
    ;;
esac
