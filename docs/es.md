# es.exe（兼容旧版）精简说明

## 前提

- 必须已安装并运行 `Everything.exe`。
- 命令格式：`es.exe [options] [search text]`。

## 可用参数（仅通用参数）

以下参数可用于旧版本 Everything：

- `-r` / `-regex`：正则搜索。
- `-i` / `-case`：大小写敏感。
- `-w` / `-ww` / `-whole-word` / `-whole-words`：全字匹配。
- `-p` / `-match-path`：匹配完整路径和文件名。
- `-o <offset>` / `-offset <offset>`：从第 `offset` 条结果开始输出（从 0 开始）。
- `-n <num>` / `-max-results <num>`：最多输出 `num` 条。
- `-s`：按完整路径排序。
- `-h` / `-help`：显示帮助。

## 兼容性约束

不要使用 Everything 1.4 专属命令行参数（旧版本可能不可用），包括但不限于：

- `-sort ...`、`-sort-*`
- `-path`、`-parent`、`-parent-path`
- `/ad`、`/a-d`、`/a[...]`
- `-csv`、`-efu`、`-txt`、`-m3u`、`-m3u8`
- `-export-*`

## 使用约束（给 AI）

- 仅生成纯 `es.exe` 命令。
- 不要拼接 `| grep`、`| findstr`、`| awk`、`| sed` 等外部过滤命令。
- 不要添加任何不属于 `es` 的参数。
- 如果 `es` 参数无法表达某个筛选条件，改写搜索词；仍无法满足时直接说明限制。
- `exact:<filename>` 属于 Everything 查询语法（搜索词），允许使用。
- `ext:<suffix>` 属于 Everything 查询语法（搜索词），允许使用。
- `audio:`、`zip:`、`doc:`、`exe:`、`pic:`、`video:` 属于 Everything 查询语法（搜索词），允许使用。

## 精确文件名建议

如果已经确定完整文件名，优先使用 `exact:`，避免 `-w` 带来的“包含匹配”噪音。

示例对比：

```powershell
es -w code.exe
```

可能返回 `Code.exe - 快捷方式.lnk`、`CODE.EXE-*.pf`、`fuck-u-code.exe` 等。

```powershell
es exact:code.exe
```

返回更接近“文件名完全等于 `code.exe`”的结果。

## 按后缀筛选建议

如果要按文件后缀筛选，使用 `ext:`。

示例：

```powershell
es ext:exe
es ext:md "readme"
```

## 按类型筛选建议

可直接使用以下搜索词前缀：

- `audio:`：搜索音频文件。
- `zip:`：搜索压缩文件。
- `doc:`：搜索文档文件。
- `exe:`：搜索可执行文件。
- `pic:`：搜索图片文件。
- `video:`：搜索视频文件。

示例：

```powershell
es audio:
es exe: code
es video: tutorial
```

## 常用搜索示例

1. 关键词搜索：

```powershell
es.exe -n 50 "project plan"
```

2. 按扩展名搜索文件：

```powershell
es.exe ext:md
```

3. 全路径参与匹配：

```powershell
es.exe -p -n 100 "C:\\code\\skills\\docs\\es.md"
```

4. 大小写敏感 + 全字匹配：

```powershell
es.exe -i -w -n 50 API
```

5. 正则搜索：

```powershell
es.exe -r -n 100 "^readme(\..+)?$"
```

6. 分页读取结果：

```powershell
es.exe -n 100 -o 0 "log"
es.exe -n 100 -o 100 "log"
```

7. 搜索文件夹名（兼容做法）：

```powershell
es.exe -p -n 200 "node_modules"
```

需要“仅文件夹/仅文件”时，不使用 1.4 参数；优先改写搜索词与路径关键词，无法精确表达时直接说明限制。

## 常见返回码

- `0`：搜索成功。
- `8`：未找到 Everything IPC 窗口（通常是 Everything 未运行）。


