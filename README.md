# earshot 一键安装指南

> 第三方部署指南 · 非 earshot 官方仓库。官方项目：[Leonxlnx/earshot](https://github.com/Leonxlnx/earshot)
> 内容来自官方文档（2026-11-02）。项目迭代快，请以[官方文档](https://github.com/Leonxlnx/earshot#install)为准。

[![⚡ 一键安装](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E5%AE%89%E8%A3%85-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键安装推荐用百度搭子)

## 一键安装（推荐：用百度搭子）

> [!TIP]
> 不用自己敲命令，让百度搭子帮你把环境跑起来。

⚠️ 只跑 CPU，不占显卡；需要 Python 3.10+ 与 ffmpeg / ffprobe。首次调用要加载模型，约 20–40 秒，之后走 MCP 或常驻进程会快很多。可选的音频大模型点评需要自己的 Gemini Key，并显式同意上传。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/earshot-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会建好 Python 虚拟环境，装 CPU 版 PyTorch 与 earshot，再跑 doctor 自检，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## earshot 是什么？

earshot 是开源的把声音变成 agent 能读的证据：像什么、像不像、在哪一秒、是不是合成的（协议：MIT，<img src="https://img.shields.io/github/stars/Leonxlnx/earshot?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

本地音频分析工具链：描述音色、按文字匹配、在长录音里定位片段、判断真人录制还是代码合成、输出整片听感时间线与评分卡，还能用代码生成并迭代音效。

- describe：用文字说清一个声音像什么
- match / rank：按描述挑最合适的音频
- find：在长录音里定位最佳片段
- realness：判断真实录制还是合成
- timeline / sheet：整片听感时间线与标注图
- forge：用代码造声并按听感迭代

（来源：[官方仓库](https://github.com/Leonxlnx/earshot)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 3484 stars 10 月新项目 | 名称搜索 249 条但无同名部署指南 |
| 纯 CPU 运行 | 不用抢显卡 |
| 分析与生成一体 | agent 能听也能造 |
| 输出时间线、标注图与评分卡 | — |
| 自带 MCP server | — |
| MIT | 可自用可二开 |

| 需要注意 | 说明 |
|---|---|
| 首次加载模型较慢 | — |
| 依赖 ffmpeg 与 Python 环境 | — |
| 可选大模型点评要自己的 Key | — |
| 结果有置信度 | 不是绝对判断 |
| 模型与依赖占磁盘 | — |

> 以上基于官方文档与社区反馈整理（2026-11-02），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/Leonxlnx/earshot.git
cd earshot && python -m venv .venv
.venv/bin/python -m pip install torch --index-url https://download.pytorch.org/whl/cpu
.venv/bin/python -m pip install -e ".[mcp,llm,dev]"
.venv/bin/python -m earshot doctor --load
echo "装好后用 .venv/bin/python -m earshot describe 试一下"
```

部署步骤来源：[https://github.com/Leonxlnx/earshot#install](https://github.com/Leonxlnx/earshot#install)

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 Python 3.10+、ffmpeg 依赖与纯 CPU 运行 | 已核对 2026-11-02 |
| 确认 MCP 注册方式与 `doctor --load` 自检命令 | 已核对 2026-11-02 |
| 未实测安装、模型加载与音频分析 | 说明 2026-11-02 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-02 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-02 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

自带 MCP server（`python -m earshot mcp`），把同一套分析工具提供给 Claude Code 等客户端；本仓库的 MCP 只提供安装步骤与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-02）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\earshot-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 先装系统依赖

```powershell
winget install Gyan.FFmpeg
winget install Python.Python.3.12
```

确认 `ffmpeg -version` 与 `python --version` 都能用。

## 注册 MCP

```powershell
claude mcp add earshot --scope user -e EARSHOT_THREADS=3 -- "C:\\path\\to\\earshot\\.venv\\Scripts\\python.exe" -m earshot mcp
```

其他客户端在 `.mcp.json` 里写 `command` 与 `args`，路径用绝对路径。慢机器把启动超时调大，例如 `MCP_TIMEOUT=60000`。

## 常用命令

| 命令 | 作用 |
|---|---|
| `describe FILE` | 说清这个声音像什么 |
| `match FILE QUERY` | 判断与描述有多贴合 |
| `find FILE QUERY` | 找长录音里的最佳片段 |
| `realness FILE` | 判断真实录制还是合成 |
| `timeline FILE` | 整片听感时间线 |
| `critique FILE` | 对照专业片给评分卡 |
| `forge RECIPE` | 用代码造声并迭代 |

## 性能与资源

- 纯 CPU，不需要显卡
- 首次调用加载模型约 20–40 秒
- 连续调用建议用 MCP 或一个常驻 Python 进程
- 模型与词表会占几百 MB 磁盘

## 注意

- `ffmpeg` 不在 PATH 时多数命令直接失败
- 可选的 Gemini 点评会上传音频，必须显式同意
- 结果带置信度，弱匹配不要当结论
- 生成音效与真实录音的判断不是鉴定报告
- MIT，可自用可二开

## 常见坑

- 命令报 ffmpeg 错：先装 ffmpeg 并重开终端
- 首次调用超时：等模型加载，或改用 MCP 常驻
- MCP 连不上：用虚拟环境里 python 的绝对路径注册
- 内存不足：减少线程数，例如 `EARSHOT_THREADS=2`
- 音频读不了：确认格式受支持，先用 ffmpeg 转码
- 结果不稳定：同一文件多次分析取一致结论，弱匹配别硬用
- 上传顾虑：不要开 `--yes-upload`，除非确实需要云端点评

## 免责声明

本仓库为第三方指南，与 earshot 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-02），项目迭代快，请以[官方文档](https://github.com/Leonxlnx/earshot#install)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
