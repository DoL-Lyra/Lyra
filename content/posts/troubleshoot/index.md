+++
title = '疑难解答'
date = 2023-10-16T18:38:12+08:00
+++

{{< alert >}}
使用本整合出现各种问题时请先使用 [汉化仓库][github-chs] 发布的版本，或是汉化仓库提供的 [汉化在线版][github-chs-pages]，测试是否同样出现问题，参考 [发布下载版](https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization/blob/main/README.md#%E5%8F%91%E5%B8%83%E4%B8%8B%E8%BD%BD%E7%89%88)。如问题同样能够复现请前往汉化仓库反馈；如问题只在本整合内出现请向本仓库反馈
{{< /alert >}}

- APK 版打开之后是英文，左下角也没有 modloader？

  更新系统 `webview`，或尝试使用 `兼容版`，都不行可以使用现代浏览器打开 [在线版](#在线)

- 为什么用 modloader 加载 zip 会提示 `bootJson文件 [boot.json] 无效`？

  本仓库分发的为完整游戏本体+mod的 **`整合包`**，并非单独的 mod，请勿使用 modloader 加载

- 明明下载了有美化的包为什么美化没有生效？

  检查是否加载了图片包 mod `GameOriginalImagePack-*.mod.zip`，有则 **`卸载`**

  本整合并未使用 mod 方式加载图片资源，图片包 mod 优先级在游戏 `img` 文件夹之上，所以在加载了图片包 mod 的情况下整合自带的图片不会生效