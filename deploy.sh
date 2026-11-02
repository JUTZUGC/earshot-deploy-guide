#!/usr/bin/env bash
set -euo pipefail
# earshot 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/Leonxlnx/earshot#install
# 更新日期：2026-11-02
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1 || { echo "需要先安装 Python 3"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/Leonxlnx/earshot.git
cd earshot && python -m venv .venv
.venv/bin/python -m pip install torch --index-url https://download.pytorch.org/whl/cpu
.venv/bin/python -m pip install -e ".[mcp,llm,dev]"
.venv/bin/python -m earshot doctor --load
echo "装好后用 .venv/bin/python -m earshot describe 试一下"

echo ""

echo "部署完成"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/Leonxlnx/earshot#install"
