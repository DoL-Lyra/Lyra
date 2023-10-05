# Degrees of Lewdity 整合包发布仓库

## 简介
### 放在前面...
- <img decoding="async" src="https://gitgud.io/uploads/-/system/user/avatar/9096/avatar.png" width="24"> <b>游戏作者</b> $\color{purple} {Vrelnir}$
  - [Vrelnir 的博客][blog]
  - [英文游戏维基][wiki-en]
  - [中文游戏维基][wiki-cn]
  - [官方 Discord][discord]
  - [游戏源码仓库][gitgud]
- [原版汉化仓库][github-chs]
- 美化
  - [Degrees of Lewdity Graphics Mod][beeesss]
  - [BEEESSS Community Sprite Compilation][beeesss-ext]
- 特写
  - [韩站特写][avatar-kr]
  - [Papa Paril BEEESSS Burger Joint][avatar-bj]

### 关于本仓库

本仓库是基于 [汉化仓库][github-chs] 制作的自动化打包仓库，使用 Github Actions 提供多种 Mod 组合可供选择，跟随汉化仓库更新

### 下载

[Latest Release](https://github.com/sakarie9/DOL-CHS-MODS/releases/latest)

### 在线

- [Github Pages](https://dol-chs-mods.github.io/pages/)  *推荐*

- [Netlify](https://dol-chs-mods.netlify.app)

> 在线版仅使用 `美化+作弊+HP+BJ特写` 构建，需要其他版本请前往 [Release](https://github.com/sakarie9/DOL-CHS-MODS/releases) 下载本地版

### 各版本说明

- 美化 | [Degrees of Lewdity Graphics Mod][beeesss] & [BEEESSS Community Sprite Compilation][beeesss-ext]

  ![预览](assets/beautify.webp)

  经典美化

- 作弊

  不需要在设置启动作弊即可使用作弊功能，可以解锁成就

- HP | @洛汐

  显示敌人当前 HP

- BJ特写 | [Papa Paril BEEESSS Burger Joint][avatar-bj]

  ![预览](assets/beautify-avatarbj.webp)

  在立绘旁显示特写头像，推荐使用

  ⚠️仍在早期开发阶段，未支持的头发会显示为光头⚠️

- KR特写 | [原帖][avatar-kr]

  ![预览](assets/beautify-avatarkr.webp)

  另一个特写版本

  ⚠️仍在早期开发阶段，未支持的头发会显示为光头⚠️

### 更新日志
<details>
<summary>点击展开</summary>

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

### 整合包使用须知

- 版本格式
  - 文件名格式
    - `dol-chs-{汉化版本号}-{MOD}-{日期}.{zip,apk}`
  - tag 格式
    - `{原版版本号}-{汉化版本号}-{日期}`

- 本整合包中 Android 端应用名称修改为 `DOL CHS MODS` 且与原版及汉化版共存，请使用导出存档功能转移存档

- 根据汉化仓库中的 [免责声明](https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization/blob/main/README.md#%E5%85%8D%E8%B4%A3%E5%A3%B0%E6%98%8E)

    > 汉化组不对任何修改后的汉化版本负责，包括但不限于修改游戏本体 html 文件，使用可能改变游戏内容的模组，使用他人发布的整合包等；汉化组也不会为任何第三方发布的模组版/修改版/魔改版/整合包等背书或担保。请在反馈问题前检查游戏是否已被修改，若被修改请勿提交，我们可能不会接受使用修改版本的内容反馈。

    在使用本整合包出现问题时在未判断问题是否由本整合包引入之前请勿向汉化仓库反馈

[blog]: https://vrelnir.blogspot.com
[wiki-en]: https://degreesoflewdity.miraheze.org/wiki
[wiki-cn]: https://degreesoflewditycn.miraheze.org/wiki
[gitgud]: https://gitgud.io/Vrelnir/degrees-of-lewdity/-/tree/master
[discord]: https://discord.gg/VznUtEh
[github-chs]: https://github.com/Eltirosto/Degrees-of-Lewdity-Chinese-Localization

[beeesss]: https://gitgud.io/BEEESSS/degrees-of-lewdity-graphics-mod
[beeesss-ext]: https://gitgud.io/Kaervek/kaervek-beeesss-community-sprite-compilation
[avatar-bj]: https://gitgud.io/GTXMEGADUDE/papa-paril-burger-joint
[avatar-kr]: https://arca.live/b/textgame/83875947
