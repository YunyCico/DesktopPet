# DesktopPet

一个面向 iOS 16 rootless/roothide 越狱环境的 SpringBoard 桌面小宠物插件最小版本。

## 当前功能

- 注入 SpringBoard，在桌面显示一个圆形小宠物
- 长按拖动，松手自动吸附到屏幕范围内
- 点击切换表情并显示气泡
- 定时做轻微待机动画
- 不依赖网络、不读取用户数据

## 编译

不必须使用 Mac。可以在 macOS、Linux、WSL2 或 GitHub Actions 编译。

本工程已附带 `.github/workflows/build.yml`：

1. 将 `DesktopPet` 文件夹上传到 GitHub 仓库
2. 打开仓库的 **Actions** 页面
3. 选择 **Build DesktopPet**
4. 点击 **Run workflow**
5. 在任务完成后下载 `DesktopPet-rootless` 或 `DesktopPet-roothide` 产物

本地 Theos 环境也可以执行：

```bash
make package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless
```

roothide：

```bash
make package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=roothide
```

产物位于 `packages/`，然后通过 Sileo / Zebra 安装 `.deb`。

## rootless / roothide 说明

- Makefile 默认使用 `rootless`，适合 Dopamine / palera1n rootless 类环境。
- roothide 环境请先加载 roothide/theos，再执行：`make package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=roothide`。
- 普通 rootless 环境可执行：`make package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless`。
- 该插件不访问越狱文件路径，因此源码层无需加入 jbroot API。
- 安装后执行一次 SpringBoard 重载。

## 后续可扩展

可继续加入 PNG/GIF 角色、配置开关、不同位置策略、点击打开自定义动作、低电量/时间问候等功能。
