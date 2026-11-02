# earshot 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/Leonxlnx/earshot#install
# 更新日期：2026-11-02
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command python -ErrorAction SilentlyContinue)) { throw '需要先安装 Python 3' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/Leonxlnx/earshot.git
Set-Location earshot
python -m venv .venv
.venv\Scripts\python -m pip install torch --index-url https://download.pytorch.org/whl/cpu
.venv\Scripts\python -m pip install -e ".[mcp,llm,dev]"
.venv\Scripts\python -m earshot doctor --load
Write-Host "装好后用 .venv\Scripts\python -m earshot describe 试一下"

Write-Host ''

Write-Host '部署完成'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/Leonxlnx/earshot#install'
