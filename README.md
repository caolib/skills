# 一些自用的 agent skills

## everything-local-search

让 Agent 可以通过使用[everything](https://www.voidtools.com/) 命令行工具 [es](https://github.com/voidtools/es) 快速搜索本地文件

![image-20260308155447946](https://free.picui.cn/free/2026/03/08/69ad2afea9e8c.png)

前置条件：

1. 下载 [everything](https://www.voidtools.com/zh-cn/downloads/) 保证其运行在后台
2. 下载 [es](https://www.voidtools.com/zh-cn/downloads/#cli) 命令行接口，并将`es.exe`文件所在目录添加到环境变量
3. 补充条件：如果你使用的是`everything 1.5a`版本，将下面的设置为`false`然后退出重启`everything`

![image-20260308160509949](./../../Users/caolib/AppData/Roaming/Typora/typora-user-images/image-20260308160509949.png)



验证：打开终端，使用es命令搜索文件，例如：`es everything -n 5`，能正常搜索到文件即可
