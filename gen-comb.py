from pytablewriter import MarkdownTableWriter
import sys
import os
import datetime

# 功能定义
functions = [
    "GOOSE",
    "UCB",
    "SUSATO",
    "WAX",
    "HIKARI",
    "KR特写",
    "BJ特写",
    "CSD",
    "作弊",
    "BESC",
]

# 暂时移除： 二进制:   10001000, 十进制: 136, 功能: ***CSD+SUSATO(推荐)***, 推荐： 1
# 白名单
add_dec = [5, 37, 516, 774]
# 黑名单
skip_dec = [512]
# 推荐
recommend_dec = [5, 37, 516]
# polyfill
polyfill_comb = "polyfill_6"

baseurl_github = "https://github.com/DoL-Lyra/Lyra/releases/download/"
baseurl_ghproxy = f"https://mirror.ghproxy.com/{baseurl_github}"
# pair_path = str(sys.argv[1])
pair_path = "pairs"
release_tag = str(sys.argv[1])

md_path = "content/posts/downloads"
if not os.path.exists(md_path):
    os.mkdir(md_path)

release_fontmatter = f"""+++
title = '{release_tag}'
date = {datetime.datetime.now(datetime.UTC).strftime("%Y-%m-%dT%H:%M:%S+00:00")}
slug = 'downloads/{release_tag}'
showTableOfContents = false
+++
"""

release_prepend = """
{{< alert >}}
⚠永远记得在升级之前备份你的存档⚠
{{< /alert >}}
<br>
{{< alert >}}
下载之前请阅读 [版本说明]({{< ref "docs" >}}) 以选择所需版本
{{< /alert >}}
<br>
{{< alert >}}
如出现问题请参考 [⚠疑难解答⚠]({{< ref "troubleshoot" >}})
{{< /alert >}}
<br>
{{< alert >}}
本仓库分发的为完整游戏本体+mod的 **`整合包`**，并非单独的 mod，请勿使用 modloader 加载。
<br>
请 **`不要`** 手动再添加汉化 `ModI18N.mod.zip` 和图片包 `GameOriginalImagePack.mod.zip`
{{< /alert >}}
<br>
{{< alert >}}
使用本整合出现问题时请先使用 [汉化仓库](https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization) 发布的版本，或是汉化仓库提供的 [汉化在线版](https://eltirosto.github.io/Degrees-of-Lewdity-Chinese-Localization/)，测试是否同样出现问题，参考 [发布下载版](https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization/blob/main/README.md#%E5%8F%91%E5%B8%83%E4%B8%8B%E8%BD%BD%E7%89%88)。
<br>
如问题同样能够复现请前往汉化仓库反馈；如问题只在本整合内出现请向 [本仓库](https://github.com/DoL-Lyra/Lyra/issues) 反馈
{{< /alert >}}
<br>
{{< alert >}}
安卓版注意：
<br>
从 `v0.5.2.8` 开始， DoL 原版修改了打包框架，使得覆盖安装会造成存档丢失。本仓库内的安卓版已修改为新包名，请在旧版导出存档然后在新版中导入。
{{< /alert >}}
<br>
{{< alert >}}
BJ，KR 及 Susato 暂未适配新版
{{< /alert >}}

## 汉化整合
"""

# release_fontmatter_latest = f"""
# +++
# title = '{release_tag}'
# +++
# """


class combination:
    binary = 0
    decimal = 0
    functions = ""
    recommend = 0

    def __init__(self, binary, decimal):
        self.binary = binary
        self.decimal = decimal

    def __lt__(self, other):
        return self.decimal < other.decimal


combinations = []


def gencomb():
    global functions
    global combinations
    global add_dec
    global skip_dec
    global recommend_dec

    BINARY_FORMAT = f"{len(functions):02}b"

    for i in range(2 ** len(functions)):
        binary = format(i, BINARY_FORMAT)  # 用8位二进制表示
        decimal = i

        # A依赖于B,B是A的依赖
        def binary_and(A):
            return decimal & 1 << A - 1

        def should_skip_dep(A, B):
            return binary_and(A) and not binary_and(B)

        def should_skip_mutex(A, B):
            return binary_and(A) and binary_and(B)

        # 跳过 0
        if i == 0:
            continue
        # 跳过 WAX，BJ，KR
        if binary_and(7) or binary_and(5) or binary_and(4):
            continue
        # 跳过 SUSATO
        if binary_and(8):
            continue
        # 添加限制条件：BESC只能在BES应用的同时应用
        # if should_skip_dep(2, 1):
        #     continue
        # 只存在BES不存在BESC时跳过
        # if should_skip_dep(1, 2):
        #     continue
        # 特写WAX依赖BESC
        if should_skip_dep(4, 1):
            continue
        if should_skip_dep(5, 1):
            continue
        if should_skip_dep(6, 1):
            continue
        if should_skip_dep(7, 1):
            continue
        # UCB依赖BESC
        if should_skip_dep(9, 1):
            continue
        # 绑定WAX和BESC
        # if (binary_and(7) and not binary_and(2)) or (
        #     not binary_and(7) and binary_and(2)
        # ):
        #     continue
        # 特写互斥
        if should_skip_mutex(4, 5):
            continue
        # HP作弊异或
        if (binary_and(2) and not binary_and(3)) or (
            not binary_and(2) and binary_and(3)
        ):
            continue
        # Susato 与 BESC 互斥
        if should_skip_mutex(8, 1):
            continue
        # Goose 与 BESC 互斥
        if should_skip_mutex(10, 1):
            continue

        # combinations.append((binary, decimal))
        combinations.append(combination(binary, decimal))

    # 白名单
    for dec in add_dec:
        binary = format(dec, BINARY_FORMAT)
        # combinations.append((binary, dec))
        combinations.append(combination(binary, dec))
        combinations.sort()
    # 黑名单
    combs_tmp = [x for x in combinations if x.decimal not in skip_dec]
    combinations = combs_tmp

    # 功能组合
    # for binary, decimal in combinations:
    for i, comb in enumerate(combinations):
        decimal = comb.decimal
        binary = comb.binary

        funcs = ""
        for j in range(len(binary) - 1, -1, -1):
            # 跳过BES如果BESC存在
            # if j == len(binary) - 1 and binary[j - 1] == "1":
            #     continue
            if binary[j] == "1":
                funcs = funcs + functions[j] + "+"
        funcs = funcs.strip("+")
        # 推荐
        if comb.decimal in recommend_dec:
            combinations[i].functions = f"***{funcs}(推荐)***"
            combinations[i].recommend = 1
        else:
            combinations[i].functions = funcs

    # 重排序组合，推荐放至最前
    combinations.sort(key=lambda x: x.recommend, reverse=True)

    # 打印所有组合
    for comb in combinations:
        decimal = comb.decimal
        binary = comb.binary
        functions = comb.functions
        recommend = comb.recommend
        print(
            f"二进制: {binary}, 十进制: {decimal}, 功能: {functions}, 推荐： {recommend}"
        )

    # 打印组合十进制数组

    print(sorted([f.decimal for f in combinations]))


def gentable():
    global combinations
    global pair_path
    global release_fontmatter
    global release_fontmatter_latest
    global polyfill_comb

    class comb_table:
        functions = ""
        decimal = 0

        def __init__(self, functions, decimal):
            self.functions = functions
            self.decimal = decimal

    table_matrix = []

    # 添加 polyfill
    fzip = open(f"{pair_path}/zip_{polyfill_comb}")
    linezip = fzip.readline()
    fzip.close()

    fapk = open(f"{pair_path}/apk_{polyfill_comb}")
    lineapk = fapk.readline()
    fapk.close()

    table_matrix.append(
        ["BESC+CSD(兼容版)", link_builder(linezip), link_builder(lineapk)]
    )
    # 添加 polyfill 结束

    for comb in combinations:
        fzip = open(f"{pair_path}/zip_{comb.decimal}")
        linezip = fzip.readline()
        fzip.close()

        fapk = open(f"{pair_path}/apk_{comb.decimal}")
        lineapk = fapk.readline()
        fapk.close()

        table_matrix.append(
            [comb.functions, link_builder(linezip), link_builder(lineapk)]
        )

    writer = MarkdownTableWriter(
        # table_name="汉化整合",
        headers=["版本选择", "ZIP", "APK"],
        value_matrix=table_matrix,
    )

    md_path_now = md_path + "/" + release_tag + ".md"
    f = open(md_path_now, "w")
    f.write(release_fontmatter)
    f.write(release_prepend)
    f.write("\n")
    f.write(writer.dumps())
    f.close()

    # md_path_latest = md_path + "/" + "latest.md"
    # f = open(md_path_latest, "w")
    # f.write(release_fontmatter_latest)
    # f.write("\n")
    # f.write(writer.dumps())
    # f.close()


def link_builder(filename):
    global baseurl_github
    global baseurl_ghproxy
    global release_tag
    link_github = baseurl_github + release_tag + "/" + filename
    link_ghproxy = baseurl_ghproxy + release_tag + "/" + filename
    str = f"[Github下载]({link_github}) / [备链]({link_ghproxy})"
    return str


if __name__ == "__main__":
    gencomb()
    gentable()
