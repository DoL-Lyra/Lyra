#!/bin/bash

# 128 64     32    16       8      4     2   1
# N   WAX   KR特写 BJ特写 CSD(HP) 作弊  BESC BES

# 二进制: 0000001, 十进制: 1, 功能: BES+
# 二进制: 0000011, 十进制: 3, 功能: BES+BESC+
# 二进制: 0001100, 十进制: 12, 功能: 作弊+HP+
# 二进制: 0001101, 十进制: 13, 功能: BES+作弊+HP+
# 二进制: 0001111, 十进制: 15, 功能: BES+BESC+作弊+HP+
# 二进制: 0010011, 十进制: 19, 功能: BES+BESC+BJ特写+
# 二进制: 0011111, 十进制: 31, 功能: BES+BESC+作弊+HP+BJ特写+
# 二进制: 0100011, 十进制: 35, 功能: BES+BESC+KR特写+
# 二进制: 0101111, 十进制: 47, 功能: BES+BESC+作弊+HP+KR特写+
# 二进制: 1000011, 十进制: 67, 功能: BES+BESC+WAX+
# 二进制: 1001111, 十进制: 79, 功能: BES+BESC+作弊+HP+WAX+
# 二进制: 1010011, 十进制: 83, 功能: BES+BESC+BJ特写+WAX+
# 二进制: 1011111, 十进制: 95, 功能: BES+BESC+作弊+HP+BJ特写+WAX+
# 二进制: 1100011, 十进制: 99, 功能: BES+BESC+KR特写+WAX+
# 二进制: 1101111, 十进制: 111, 功能: BES+BESC+作弊+HP+KR特写+WAX+

# 参数1 包类型 (zip apk)
VERSION=$1
# 参数2 MOD代码
MOD_CODE=$2
# 参数3 可选，格式为月日，如 1231
DATE_PARAM=$3
if [[ $DATE_PARAM == v* ]]; then
  DATE_NOW=$(echo $DATE_PARAM | awk -F- '{print $NF}')
else
  DATE_NOW=$(date -d "+8 hours" +%m%d)
fi

IS_POLYFILL=0

# 资源地址
# 工具
URL_APKTOOL=https://github.com/iBotPeaches/Apktool/releases/download/v2.8.1/apktool_2.8.1.jar
URL_APKSIGN=https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar
# 资源
URL_BES=https://gitgud.io/BEEESSS/degrees-of-lewdity-graphics-mod/-/raw/master/img.zip
URL_BESC=https://gitgud.io/Kaervek/kaervek-beeesss-community-sprite-compilation/-/archive/master/kaervek-beeesss-community-sprite-compilation-master.tar.gz
URL_BESC_WAX=https://gitgud.io/GTXMEGADUDE/beeesss-wax/-/blob/1e2b58248afb1b6537dabba7b684b54225466fcd/BEEESSS_WAX.rar
# URL_AVATAR_BJ=https://gitgud.io/GTXMEGADUDE/double-cheeseburger/-/raw/master/Paril_BJ_BEEESSS_Addon.rar

EXTRACT_DIR=extract # 解压目录
OUTPUT_DIR=output   # 输出目录
PAIRS_DIR=pairs     # 索引输出目录
if [ ! -d $OUTPUT_DIR ]; then
  mkdir $OUTPUT_DIR
fi
if [ ! -d $PAIRS_DIR ]; then
  mkdir $PAIRS_DIR
fi

fun_name() {
  OUTPUT_PREFIX='' # 文件名前缀
  OUTPUT_SUFFIX='' # 文件名后缀
  BASE_NAME=${FILE_NAME%.*}
  DOL_VER=$(echo $BASE_NAME | cut -d '-' -f 3)
  CHS_VER=$(echo $BASE_NAME | cut -d '-' -f 4)
  OUTPUT_PREFIX="DoL-${DOL_VER}-Lyra-${CHS_VER}"
  OUTPUT_PREFIX="${OUTPUT_PREFIX//'alpha'/'a'}"
  OUTPUT_PREFIX="${OUTPUT_PREFIX//'beta'/'b'}"
  if [ $IS_POLYFILL -ne 0 ]; then
    OUTPUT_PREFIX=${OUTPUT_PREFIX}"-polyfill"
  fi
}

fun_gen_pairs() {
  if [ $IS_POLYFILL -eq 0 ]; then
    echo "$OUTPUT_NAME" >$PAIRS_DIR/${VERSION}_${MOD_CODE}
  else
    echo "$OUTPUT_NAME" >$PAIRS_DIR/${VERSION}_polyfill_${MOD_CODE}
  fi
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
  fun_gen_pairs
}

# APK
fun_apk() {
  wget -q -nc -O apktool.jar $URL_APKTOOL
  wget -q -nc -O uber-apk-signer.jar $URL_APKSIGN

  java -jar apktool.jar d $FILE_NAME -o $EXTRACT_DIR

  # 修改包名
  sed -i 's/"com.vrelnir.DegreesOfLewdity"/"com.vrelnir.DegreesOfLewdity.lyra"/g' $EXTRACT_DIR/AndroidManifest.xml

  # 修改应用名
  sed -i 's/DoL/DoL Lyra/g' $EXTRACT_DIR/res/values/strings.xml
  sed -i 's/Degrees of Lewdity/DoL Lyra/g' $EXTRACT_DIR/res/values/strings.xml

  fun_check_code

  java -jar apktool.jar b $EXTRACT_DIR -o tmp.apk
  java -jar uber-apk-signer.jar -a tmp.apk --ks dol.jks --ksAlias dol --ksKeyPass dolchs --ksPass dolchs -o signed

  OUTPUT_NAME="${OUTPUT_PREFIX}${OUTPUT_SUFFIX}-${DATE_NOW}.apk"
  echo $OUTPUT_NAME

  mv signed/*.apk $OUTPUT_DIR/$OUTPUT_NAME

  # for generate markdown table
  fun_gen_pairs
}

# 处理MOD代码
fun_check_code() {
  if [ $((MOD_CODE & 1)) -ne 0 ]; then
    echo 1-Start patch bes...
    fun_bes
    OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-bes
    echo 1-Complete patch bes!
  fi
  if [ $((MOD_CODE & 2)) -ne 0 ]; then
    echo 2-Start patch besc...
    fun_besc
    OUTPUT_SUFFIX=${OUTPUT_SUFFIX}c
    echo 2-Complete patch besc!
  fi
  if [ $((MOD_CODE & 64)) -ne 0 ]; then
    echo 64-Start patch wax...
    fun_wax
    OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-wax
    echo 64-Complete patch wax!
  fi
  if [ $((MOD_CODE & 128)) -ne 0 ]; then
    echo 128-Start patch susato...
    OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-susato
    echo 128-Complete patch susato!
  fi
  if [ $((MOD_CODE & 4)) -ne 0 ]; then
    echo 4-Start patch cheat...
    # fun_cheat
    OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-cheat
    echo 4-Complete patch cheat!
  fi
  if [ $((MOD_CODE & 8)) -ne 0 ]; then
    echo 8-Start patch CSD...
    # fun_csd
    OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-csd
    echo 8-Complete patch CSD!
  fi
  if [ $((MOD_CODE & 16)) -ne 0 ]; then
    echo 16-Start patch sideview type BJ...
    fun_sideview_bj
    OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-sideviewbj
    echo 16-Complete patch sideview type BJ!
  fi
  if [ $((MOD_CODE & 32)) -ne 0 ]; then
    echo 32-Start patch sideview type kr...
    fun_sideview_kr
    OUTPUT_SUFFIX=${OUTPUT_SUFFIX}-sideviewkr
    echo 32-Complete patch sideview type kr!
  fi
}

# 美化
fun_bes() {
  BEAUTIFY_DIR="beautify"
  mkdir $BEAUTIFY_DIR
  pushd $BEAUTIFY_DIR

  wget -q -nc -O B-1.zip $URL_BES
  unzip -q B-1.zip

  popd
  cp -r $BEAUTIFY_DIR/img/* $IMG_PATH/
}
fun_besc() {
  BEAUTIFY_DIR="beautify"
  mkdir $BEAUTIFY_DIR
  pushd $BEAUTIFY_DIR

  wget -q -nc -O B-2.tar.gz $URL_BESC
  tar xf B-2.tar.gz kaervek-beeesss-community-sprite-compilation-master/img --strip-components 1

  popd
  cp -r $BEAUTIFY_DIR/img/* $IMG_PATH/
}
fun_wax() {
  BEAUTIFY_DIR="beautify"
  mkdir $BEAUTIFY_DIR
  pushd $BEAUTIFY_DIR

  wget -q -nc -O B-3.zip $URL_BESC_WAX
  unzip -q B-3.zip
  cp -r 'BEEESSS WAX/img' .

  popd
  cp -r $BEAUTIFY_DIR/img/* $IMG_PATH/
}

# BJ特写
fun_sideview_bj() {
  DIR_SIDEVIEWBJ="sideview_bj"
  unzip -q assets/BJ_Extend.zip -d $DIR_SIDEVIEWBJ
  cp -r $DIR_SIDEVIEWBJ/BJ_Extend/img/* $IMG_PATH/
}

# KR特写
fun_sideview_kr() {
  DIR_SIDEVIEWKR="sideview_kr"
  unzip -q assets/KR_G259M.zip -d $DIR_SIDEVIEWKR
  cp -r $DIR_SIDEVIEWKR/얼굴추가/img/* $IMG_PATH/
}

# 入口
if [[ ${MOD_CODE} = polyfill-* ]]; then
  echo polyfill-12-Use cheat csd base
  FILE_NAME=$(basename DoL*polyfill-12.$VERSION)
  IS_POLYFILL=1
  MOD_CODE=$(echo $MOD_CODE | cut -d '-' -f 2)
elif [ $MOD_CODE -eq 140 ]; then
  echo 140-Use susato cheat csd
  FILE_NAME=$(basename DoL*-140.$VERSION)
elif [ $MOD_CODE -eq 136 ]; then
  echo 140-Use susato csd
  FILE_NAME=$(basename DoL*-136.$VERSION)
elif [ $((MOD_CODE & 12)) -eq 12 ]; then
  echo 12-Use cheat csd base
  FILE_NAME=$(basename DoL*[^polyfill]-12.$VERSION)
elif [ $((MOD_CODE & 8)) -eq 8 ]; then
  echo 8-Use csd base
  FILE_NAME=$(basename DoL*-8.$VERSION)
elif [ $((MOD_CODE & 4)) -eq 4 ]; then
  echo 4-Use cheat base
  FILE_NAME=$(basename DoL*-4.$VERSION)
else
  echo 0-Use i18n only
  FILE_NAME=$(basename DoL*-0.$VERSION)
fi

case "$VERSION" in
"zip")
  fun_name
  IMG_PATH=$EXTRACT_DIR/img
  fun_zip
  ;;
"apk")
  fun_name
  IMG_PATH=$EXTRACT_DIR/assets/www/img
  fun_apk
  ;;
esac
