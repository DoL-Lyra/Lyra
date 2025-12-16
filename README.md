# DoL-Lyra 整合包发布仓库

## 目录

- [目录](#目录)
- [简介](#简介)
  - [关于本仓库](#关于本仓库)
- [各版本说明](#各版本说明)
- [下载](#下载)
- [在线](#在线)
- [疑难解答](#疑难解答)
- [更新日志](#更新日志)
- [整合包使用须知](#整合包使用须知)
- [Credits](#credits)

---

## 简介

### 关于本仓库

本仓库是基于 [汉化仓库][github-chs] 制作的自动化打包仓库，使用 Github Actions 提供多种 Mod 组合可供选择，跟随汉化仓库更新

**该仓库并非 DoL 或汉化组官方发布渠道**

## 各版本说明

->->-> [【版本说明】](https://dol-lyra.github.io/hub/docs/) <-<-<-

## 下载

->->-> [【下载站】](https://dol-lyra.github.io/hub/) <-<-<-

## 在线

[【DoL-Lyra Github Pages】](https://dol-lyra.github.io)

> 在线版仅使用 `BESC+作弊+CSD` 构建，需要其他版本请前往下载本地版

## 疑难解答

> [!NOTE]
>
>  参考 [【疑难解答】](https://dol-lyra.github.io/hub/troubleshoot/)

> [!IMPORTANT]
>
> **使用本整合出现各种问题时请先使用 [汉化仓库][github-chs] 发布的版本，或是汉化仓库提供的 [汉化在线版][github-chs-pages]，测试是否同样出现问题，参考 [发布下载版](https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization/blob/main/README.md#%E5%8F%91%E5%B8%83%E4%B8%8B%E8%BD%BD%E7%89%88)。如问题同样能够复现请前往汉化仓库反馈；如问题只在本整合内出现请向本仓库反馈**

> [!IMPORTANT]
>
> 本仓库无法受理任何打包问题以外的美化问题

- APK 版打开之后是英文，左下角也没有 modloader？

  更新系统 `webview`，或尝试使用 `兼容版`，都不行可以使用现代浏览器打开 [在线版](#在线)

- 为什么用 modloader 加载 zip 会提示 `bootJson文件 [boot.json] 无效`？

  本仓库分发的为完整游戏本体+mod的 **`整合包`**，并非单独的 mod，请勿使用 modloader 加载

- 中英文混杂？

  卸载 `modloader - 旁加载` 中的汉化 mod，整合包已经自带了对应游戏版本的最新汉化

- 明明下载了有美化的包为什么美化没有生效？

  检查是否加载了图片包 mod `GameOriginalImagePack-*.mod.zip`，有则 **`卸载`**

  本整合并未使用 mod 方式加载图片资源，图片包 mod 优先级在游戏 `img` 文件夹之上，所以在加载了图片包 mod 的情况下整合自带的图片不会生效

- 美化出现了奇怪的错位/黑边/光头？

  所使用的美化未跟进最新的游戏内容

## 更新日志

<details>
<summary>点击展开</summary>

- 20251216

  通过修改 `ModLoader` 使内置的 `汉化/作弊/CSD` 可被禁用/调整顺序

  默认将全部内置以降低打包成本

- 20250201

  添加新美化，移除旧美化

- 20240415

  添加 `kr特写刘海补充`

- 20240310

  添加 `Susato Model`

- 20240215

  添加 `DOL_BJ_hair_extend`

- 20240102

  添加 polyfill 版本

  重命名仓库

- 1118

  使用 ModLoader 打包

- 1110

  HP 重命名为 CSD

- 1017

  版本说明及下载表格移至独立发布页

- 1014

  作弊添加更多功能：关闭成就锁、启用言灵

- 1009

  更精细的美化版本种类

- 1007

  添加 BEEESSS Wax 身体美化

- 0914

  移除世界扩展

  使用新格式HP显示

- 0911

  修改特写命名

  > 特写1 -> KR特写
  > 特写2 -> BJ特写

- 0908

  新增世界扩展作为底包

- v1.3.0-0904

  修正特写2未被应用的问题

- v1.3.0-0903

  添加特写1和特写2及HP显示

- v1.3.0-0902

  首次更新

</details>

## 整合包使用须知

- 版本格式

  - 文件名格式
    - `dol-{原版版本号}-chsmods-{汉化版本号}-{MODS}-{日期}[.{修订号}].{zip,apk}`
  - tag 格式
    - `{原版版本号}-{汉化版本号}-{日期}[.{修订号}]`

- 本整合包为完整游戏本体，请勿将压缩包作为 mod 在 modloader 内加载

- 本整合包中 Android 端应用名称修改为 `DoL Lyra` 且与原版及汉化版共存，请使用导出存档功能转移存档

- 根据汉化仓库中的 [免责声明](https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization/blob/main/README.md#%E5%85%8D%E8%B4%A3%E5%A3%B0%E6%98%8E)

  > 汉化组不对任何修改后的汉化版本负责，包括但不限于修改游戏本体 html 文件，使用可能改变游戏内容的模组，使用他人发布的整合包等；汉化组也不会为任何第三方发布的模组版/修改版/魔改版/整合包等背书或担保。请在反馈问题前检查游戏是否已被修改，若被修改请勿提交，我们可能不会接受使用修改版本的内容反馈。

  在使用本整合包出现问题时在未判断问题是否由本整合包引入之前请勿向汉化仓库反馈

## Credits

- <img decoding="async" src="https://gitgud.io/uploads/-/system/user/avatar/9096/avatar.png" width="24"> $\color{purple} {Vrelnir}$
  - [Vrelnir 的博客][blog]
  - [英文游戏维基][wiki-en]
  - [中文游戏维基][wiki-cn]
  - [官方 Discord][discord]
  - [游戏源码仓库][gitgud]
- [原版汉化仓库][github-chs]
  - [为汉化仓库做出过贡献的诸位][github-chs-credits]
- [DoL-Lyra][github-lyra]
- Mod
  - [Lyra-CombatStatusDisplay][lyra-csd]
  - [Lyra-Cheat][lyra-cheat]
- 美化
  - [Degrees of Lewdity Plus][dolp]
  - [Degrees of Lewdity Graphics Mod][beeesss]
    - BEEESSS
  - [BEEESSS Community Sprite Compilation][beeesss-ext]
    - BEEESSS, ethanatortx, MatchaCrepeCakes, LedhaKuromi, Tommohas, Jessplayin690, SkyFall669/SomethingIsHuntingYou, AvinsXD, okbd321, cloversnipe, Elegant_Dress_5771, doseonseng, G259M, VanityDecay, Hikari, luoyin mengling, Tieba user_5CU79bt, Xiaochien, cheese shredded cake, artiste (the gayest man alive), Suqi eggplant stew, Paril, La Maritza, AD calcium, Isari, 森谷華子, aqua, superhydroxide, 再3棘, 567600, ToumanLin, Isopod, ◌/あきやま, Poop, SydNekoKawaii, Bunnyberry<3, Mizzy, 長門有栖☆, 七玳, 墮天使
  - [BEEESSS Wax][beeesss-wax]
    - Paril, b333sss
  - [Susato Model][susato-model]
    - susato, miyako2428
  - [通用战斗美化 UCB][ucb-github]
    - 贴吧用户\_GaC5V7E
- 特写
  - [Hikari][hikari]
  - [Goose][goose]
  - [Paril Double Cheeseburger][sideview-dc]
    - Paril, b333sss, Zubonko, Blaine
  - [DOL BJ hair extend][sideview-bj-extend]
    - Zubonko
  - [韩站特写][sideview-kr]
    - G259M
  - [KR特写刘海补充][sideview-kr-extend]
    - 贴吧用户\_GaC5V7E

[blog]: https://vrelnir.blogspot.com
[wiki-en]: https://degreesoflewdity.miraheze.org/wiki
[wiki-cn]: https://degreesoflewditycn.miraheze.org/wiki
[gitgud]: https://gitgud.io/Vrelnir/degrees-of-lewdity/-/tree/master
[discord]: https://discord.gg/VznUtEh
[github-chs]: https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization
[github-chs-credits]: https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization/blob/main/CREDITS.md
[github-chs-pages]: https://eltirosto.github.io/Degrees-of-Lewdity-Chinese-Localization/
[beeesss]: https://gitgud.io/BEEESSS/degrees-of-lewdity-graphics-mod
[beeesss-ext]: https://gitgud.io/Kaervek/kaervek-beeesss-community-sprite-compilation
[beeesss-wax]: https://gitgud.io/GTXMEGADUDE/beeesss-wax
[sideview-dc]: https://gitgud.io/GTXMEGADUDE/double-cheeseburger
[sideview-bj-extend]: https://github.com/zubonko/DOL_BJ_hair_extend
[sideview-kr]: https://arca.live/b/textgame/83875947
[sideview-kr-extend]: https://tieba.baidu.com/p/9055647926
[github-lyra]: https://github.com/DoL-Lyra
[lyra-csd]: https://github.com/DoL-Lyra/CombatStatusDisplay
[lyra-cheat]: https://github.com/DoL-Lyra/Cheat
[susato-model]: https://discord.com/channels/675158131688603721/1216104862870147303
[ucb-github]: https://github.com/site098/mysterious
[dolp]: https://gitgud.io/Frostberg/degrees-of-lewdity-plus
[hikari]: https://gitgud.io/HikariT/hikari-mods
[goose]: https://gitgud.io/goose/createshit
