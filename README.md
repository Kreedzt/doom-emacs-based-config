# 基于 DOOM Emacs 的二次配置

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

完成后重新执行 `~/.emacs.d/bin/doom sync` 使其 env 生效
