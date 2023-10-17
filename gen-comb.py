from pytablewriter import MarkdownTableWriter
import sys
from datetime import datetime

# 功能定义
functions = ["WAX", "KR特写", "BJ特写", "HP", "作弊", "BESC", "BES"]

# 白名单
add_dec = [27,91]
# 黑名单
skip_dec = [0]
# 推荐
recommend_dec = [15,31]

baseurl_github = "https://github.com/sakarie9/DOL-CHS-MODS/releases/download/"
baseurl_ghproxy = f"https://ghproxy.com/{baseurl_github}"
#pair_path = str(sys.argv[1])
pair_path = "pairs"
release_tag = str(sys.argv[1])
md_path = "content/posts/downloads"

release_fontmatter = f"""
+++
title = '{release_tag}'
date = {datetime.datetime.now(datetime.UTC).strftime("%Y-%m-%dT%H:%M:%S+00:00")}
+++
"""

release_fontmatter_latest = f"""
+++
title = '{release_tag}'
+++
"""

class combination:
    binary = 0
    decimal = 0
    functions = ""

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

    for i in range(2**len(functions)):
        binary = format(i, BINARY_FORMAT)  # 用8位二进制表示
        decimal = i

        # A依赖于B,B是A的依赖
        binary_and = lambda A: decimal & (1 << (A-1))
        should_skip_dep = lambda A,B: binary_and(A) and not binary_and(B)
        should_skip_mutex = lambda A,B: binary_and(A) and binary_and(B)
        # 跳过 0
        if i == 0:
            continue
        # 添加限制条件：BESC只能在BES应用的同时应用
        if should_skip_dep(2,1):
            continue
        # 只存在BES不存在BESC时跳过
        if should_skip_dep(1,2):
            continue
        # 特写WAX依赖BESC
        if should_skip_dep(5,2):
            continue
        if should_skip_dep(6,2):
            continue
        if should_skip_dep(7,2):
            continue
        # 特写互斥
        if should_skip_mutex(5,6):
            continue
        # HP作弊异或
        if (binary_and(3) and not binary_and(4)) or (not binary_and(3) and binary_and(4)):
            continue

        #combinations.append((binary, decimal))
        combinations.append(combination(binary, decimal))

    # 白名单
    for dec in add_dec:
        binary = format(dec, BINARY_FORMAT)
        #combinations.append((binary, dec))
        combinations.append(combination(binary, dec))
        combinations.sort()
    # 黑名单
    combs_tmp = [x for x in combinations if x.decimal not in skip_dec]
    combinations = combs_tmp

    # 功能组合
    #for binary, decimal in combinations:
    for i, comb in enumerate(combinations):
        decimal = comb.decimal
        binary = comb.binary

        funcs = ""
        for j in range(len(binary)-1,-1,-1):
            # 跳过BES如果BESC存在
            if j == len(binary)-1 and binary[j-1] == '1':
                continue
            if binary[j] == '1':
                funcs = funcs + functions[j] + "+"
        funcs = funcs.strip("+")
        # 推荐
        if comb.decimal in recommend_dec:
            combinations[i].functions = f"***{funcs}(推荐)***"
        else:
            combinations[i].functions = funcs

    # # 打印所有组合
    # for comb in combinations:
    #     decimal = comb.decimal
    #     binary = comb.binary
    #     functions = comb.functions
    #     print(f"二进制: {binary}, 十进制: {decimal}, 功能: {functions}")

def gentable():
    global combinations
    global pair_path
    global release_fontmatter
    global release_fontmatter_latest

    class comb_table:
        functions = ""
        decimal = 0

        def __init__(self, functions, decimal):
            self.functions = functions
            self.decimal = decimal
        
    table_matrix = []

    for comb in combinations:
        fzip = open(f"{pair_path}/zip_{comb.decimal}")
        linezip = fzip.readline()
        fzip.close()

        fapk = open(f"{pair_path}/apk_{comb.decimal}")
        lineapk = fapk.readline()
        fapk.close()

        table_matrix.append([comb.functions,link_builder(linezip),link_builder(lineapk)])

    writer = MarkdownTableWriter(
        table_name="汉化整合",
        headers=["版本选择", "ZIP", "APK"],
        value_matrix=table_matrix,
        
    )

    f = open(md_path + "/" + release_tag + ".md", "w")
    f.write(release_fontmatter)
    f.write("\n")
    f.write(writer.dumps())

def link_builder(filename):
    global baseurl_github
    global baseurl_ghproxy
    global release_tag
    link_github = baseurl_github+release_tag+"/"+filename
    link_ghproxy = baseurl_ghproxy+release_tag+"/"+filename
    str = f"[Github下载]({link_github}) / [备链]({link_ghproxy})"
    return str


if __name__ == "__main__":
    gencomb()
    gentable()
