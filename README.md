# 基于 DOOM Emacs 的二次配置

## 环境说明

- Doom 主仓库：<https://github.com/doomemacs/core>（安装到 `~/.config/emacs`）
- 模块仓库：<https://github.com/doomemacs/modules>，以 submodule 形式检出到
  `~/.config/emacs/sources/doom+`，由 `doom install` / `doom upgrade` 自动初始化
- 本配置目录 `~/.doom.d` 仍受支持（作为 `$DOOMDIR`）；新安装默认使用
  `~/.config/doom`。两者只取其一，若同时存在则优先 `~/.config/doom`。

## 环境要求

### 字体

- [思源黑体](https://github.com/adobe-fonts/source-han-sans/tree/release)
- [Source Code Pro](https://fonts.google.com/specimen/Source+Code+Pro)

### lsp-bridge 配置

``` sh
python3 -m venv ~/global_deps
source ~/global_deps/bin/activate
python3 -m pip install epc orjson sexpdata six setuptools paramiko rapidfuzz watchdog
```

完成后重新执行 `~/.config/emacs/bin/doom sync --env` 使其 env 生效
（`bin/doom` 已在 `PATH` 中时可直接用 `doom sync --env`）。
