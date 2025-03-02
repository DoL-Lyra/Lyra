from pytablewriter import MarkdownTableWriter
import sys
import os
import datetime


class Config:
    def __init__(self):
        # 功能定义
        self.functions = [
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

        # 白名单
        self.add_dec = [5, 37, 132, 516, 774]
        # 黑名单
        self.skip_dec = [128, 512]
        # 推荐
        self.recommend_dec = [5, 37, 132, 516]
        # polyfill
        self.polyfill_comb = "polyfill_7"

        self.baseurl_github = "https://github.com/DoL-Lyra/Lyra/releases/download/"
        self.baseurl_ghproxy = f"https://ghfast.top/{self.baseurl_github}"
        self.pair_path = "pairs"
        self.release_tag = str(sys.argv[1]) if len(sys.argv) > 1 else ""

        self.md_path = "content/posts/downloads"
        if not os.path.exists(self.md_path):
            os.mkdir(self.md_path)

        self.release_fontmatter = f"""+++
title = '{self.release_tag}'
date = {datetime.datetime.now(datetime.UTC).strftime("%Y-%m-%dT%H:%M:%S+00:00")}
slug = 'downloads/{self.release_tag}'
showTableOfContents = false
+++
"""

        self.release_prepend = """
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
使用本整合出现问题时请先使用 [汉化仓库](https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization) 发布的版本，或是汉化仓库提供的 [汉化在线版](https://eltirosto.github.io/Degrees-of-Lewdity-Chinese-Localization/)，测试是否同样出现问题，参考 [发布下载版](https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization/blob/main/README.md#%E5%8F%91%E5%B8%83%E4%B8%8B%E8%BD%BD%E7%89%88)。
<br>
如问题同样能够复现请前往汉化仓库反馈；如问题只在本整合内出现请向 [本仓库](https://github.com/DoL-Lyra/Lyra/issues) 反馈
{{< /alert >}}
<br>
{{< alert >}}
BJ 及 KR 暂未适配新版
{{< /alert >}}
<br>
{{< alert >}}
本仓库分发的为完整游戏本体+mod的 **`整合包`**，并非单独的 mod，请勿使用 modloader 加载。
<br>
请 **`不要`** 手动再添加汉化 `ModI18N.mod.zip` 和图片包 `GameOriginalImagePack.mod.zip`
{{< /alert >}}

## 下载
"""


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


def gencomb(config):
    combinations = []

    BINARY_FORMAT = f"{len(config.functions):02}b"

    for i in range(2 ** len(config.functions)):
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
        # if binary_and(8):
        #     continue
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
        # Susato 与 Goose 互斥
        if should_skip_mutex(10, 8):
            continue

        combinations.append(combination(binary, decimal))

    # 白名单
    for dec in config.add_dec:
        binary = format(dec, BINARY_FORMAT)
        # combinations.append((binary, dec))
        combinations.append(combination(binary, dec))
        combinations.sort()
    # 黑名单
    combinations = [x for x in combinations if x.decimal not in config.skip_dec]

    combinations.sort(key=lambda x: x.recommend, reverse=True)

    # 打印所有组合
    for comb in combinations:
        decimal = comb.decimal
        binary = comb.binary

        funcs = ""
        for j in range(len(binary) - 1, -1, -1):
            if binary[j] == "1":
                funcs = funcs + config.functions[j] + "+"
        funcs = funcs.strip("+")
        # 推荐
        if comb.decimal in config.recommend_dec:
            comb.functions = f"***{funcs}(推荐)***"
            comb.recommend = 1
        else:
            comb.functions = funcs

    # 重排序组合，推荐放至最前
    combinations.sort(key=lambda x: x.recommend, reverse=True)

    # 打印所有组合
    for comb in combinations:
        decimal = comb.decimal
        binary = comb.binary
        functions = comb.functions
        recommend = comb.recommend
        print(
            f"二进制: {binary}, 十进制: {decimal:3d}, 功能: {functions}, 推荐： {recommend}"
        )

    # 打印组合十进制数组
    print(sorted([f.decimal for f in combinations]))
    
    return combinations


def link_builder(filename, config):
    link_github = config.baseurl_github + config.release_tag + "/" + filename
    link_ghproxy = config.baseurl_ghproxy + config.release_tag + "/" + filename
    str = f"[Github下载]({link_github}) / [备链]({link_ghproxy})"
    return str


def gentable(combinations, config):

    if not os.path.exists(config.pair_path):
        print(f"Pair path {config.pair_path} does not exist. Skipping gentable function.")
        return

    table_matrix = []

    # 添加 polyfill
    fzip = open(f"{config.pair_path}/zip_{config.polyfill_comb}")
    linezip = fzip.readline()
    fzip.close()

    fapk = open(f"{config.pair_path}/apk_{config.polyfill_comb}")
    lineapk = fapk.readline()
    fapk.close()

    table_matrix.append(
        ["BESC+CSD(兼容版)", link_builder(linezip, config), link_builder(lineapk, config)]
    )
    # 添加 polyfill 结束

    for comb in combinations:
        fzip = open(f"{config.pair_path}/zip_{comb.decimal}")
        linezip = fzip.readline()
        fzip.close()

        fapk = open(f"{config.pair_path}/apk_{comb.decimal}")
        lineapk = fapk.readline()
        fapk.close()

        table_matrix.append(
            [comb.functions, link_builder(linezip, config), link_builder(lineapk, config)]
        )

    writer = MarkdownTableWriter(
        # table_name="汉化整合",
        headers=["版本选择", "ZIP", "APK"],
        value_matrix=table_matrix,
    )

    md_path_now = config.md_path + "/" + config.release_tag + ".md"
    f = open(md_path_now, "w")
    f.write(config.release_fontmatter)
    f.write(config.release_prepend)
    f.write("\n")
    f.write(writer.dumps())
    f.close()


def main():
    config = Config()
    combinations = gencomb(config)
    gentable(combinations, config)


if __name__ == "__main__":
    main()
