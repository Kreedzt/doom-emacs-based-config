# Windows Doom 配置迁移任务（master）

> 本文件由 mac 侧静态调研生成，执行与验收在 Windows 真机。改动前先完整阅读第 1 节。

## 0. 目标与边界

- 把 `master` 的旧 Doom 配置适配到新结构：`doomemacs/core` + `sources/doom+`（`doomemacs/modules` submodule）。
- 目标环境：Windows 主力；Go/Node 由 **mise** 管理。
- 只改本仓库的 `init.el` / `config.el` / `packages.el`；不改 `~/.config/emacs` 与 `sources/doom+`。
- `mac` 分支已迁移完成，可作为对照；本任务只针对 `master`。

## 1. 前置检查（不满足则停止）

- [ ] 当前分支为 `master`，工作区干净（`git status` 只允许本机临时目录，如 `.agent-shell/`）。
- [ ] Windows 侧 Doom 已是新 core：`git -C <EMACSDIR> remote -v` 显示 `doomemacs/core`，且 `sources/doom+` 是 `doomemacs/modules` 子模块。
- [ ] Windows Emacs **≥ 29.1**（`doom+` 模块的硬要求；30/31 更佳）。
- [ ] `doom` 命令可用；若不在 `PATH`，使用 `$EMACSDIR\bin\doom.ps1`（PowerShell）。
- [ ] 已记录当前基线：`doom doctor` 输出、`emacs --version`、`git rev-parse --short HEAD`。

路径约定：`$EMACSDIR` = Doom 安装目录（如 `C:\Users\<你>\.config\emacs`）；`$DOOMDIR` = 本仓库根目录。

旧配置若尚未升级 Doom，先升级 Doom 再执行本任务；否则 `corfu` / `vertico` / `dashboard` 模块不存在。

## 2. P0：兼容新 core（必须改）

### 2.1 `init.el`：补全栈（ivy/company 已 deprecated）

`doomemacs/modules` 中 `completion/ivy`、`completion/company` README 均标注 *deprecated in favor of vertico/corfu*。

原：

```elisp
:completion
company           ; the ultimate code completion backend
;;helm              ; the *other* search engine for love and life
;;ido               ; the other *other* search engine...
(ivy
  +childframe
  +icons)               ; a search engine for love and life
```

改为：

```elisp
:completion
corfu             ; complete with cap(f), cape, and a flying feather
;;helm              ; the *other* search engine for love and life
;;ido               ; the other *other* search engine...
(vertico +childframe +icons)  ; tomorrow's search engine
```

`vertico` 保留原 ivy 的 `+childframe` / `+icons` flag；`corfu` 无对应 flag。

### 2.2 `init.el`：模块改名/删除

- `doom-dashboard` → `dashboard`（2.1 起改名；旧名只会触发 remap 警告）。
- 删除 `rgb`（上游 `doomemacs/modules` 提交 `0dedfd449`，2024-06-30 移除；当前是静默 no-op）。

```elisp
:ui
dashboard         ; a nifty splash screen for Emacs

:tools
;; 删除 rgb 整行
```

CSS/Sass/Stylus 的十六进制颜色高亮仍由 `:lang web` 内置的 `rainbow-mode` 提供；`kurecolor` 命令随 `rgb` 模块消失。

### 2.3 `config.el`：ivy 与过时 hook

```elisp
;; 原：(global-set-key "\C-s" 'swiper)
(global-set-key "\C-s" 'consult-line)

;; 原：(add-hook 'find-file-hooks 'no-junk-please-were-unixish)
(add-hook 'find-file-hook #'no-junk-please-were-unixish)
```

`find-file-hooks` 在 Emacs 31 仍是 obsolete alias；改新名避免未来的移除。

### 2.4 不要动

- `package-archives`：straight 不读取，仅影响 `package.el`；保留即可。
- `evil-default-state`：`:editor evil` 未启用，属于无副作用的死配置；保留。
- Windows 编码块（`utf-16-le` 剪贴板、`utf-8` 默认、强制 unix 换行）：保留。
- 字体 `Source Code Pro 32` / `sans 28`：Windows 侧既有选择，保留。

## 3. P1：Windows + mise

mise 在 Windows 的 shim 目录是 `%LOCALAPPDATA%\mise\shims`（官方文档：<https://mise.jdx.dev/dev-tools/shims.html>）。为避免从开始菜单启动 Emacs 时 PATH 缺少 mise，在 `config.el` 现有 Windows 编码块之后加入：

```elisp
;; mise shims (go/node) for GUI-launched Emacs
(when (eq system-type 'windows-nt)
  (let ((shims (expand-file-name "mise/shims"
                                 (or (getenv "LOCALAPPDATA") "~/AppData/Local"))))
    (when (and (file-directory-p shims)
               (not (member shims exec-path)))
      (add-to-list 'exec-path shims)
      (setenv "PATH" (concat shims path-separator (getenv "PATH"))))))
```

同时在 Windows 上生成环境快照：

```powershell
# 先确认当前 PowerShell 的 PATH 含 mise shims（mise 安装后通常已写入用户 Path）
$env:Path -split ';' | Select-String 'mise'
doom sync --env
```

`doom sync --env` 会把 shell 的 `PATH` 固化到 `$EMACSDIR\.local\etc\@\init.d\05-doom-env.load.el`，重启 Emacs 后生效。

LSP server 由 mise 提供时，确认可执行文件可见：

```elisp
(executable-find "go")                        ; mise
(executable-find "node")                      ; mise
(executable-find "gopls")                     ; 若启用 go +lsp
(executable-find "typescript-language-server"); 若使用 JS/TS LSP
```

## 4. P2：可选（默认不做，需确认）

| 项 | 说明 | 默认 |
|---|---|---|
| LSP 覆盖 | master 仅 `javascript +lsp` / `rust +lsp`；是否给 `json`/`python`/`web` 加 `+lsp`，或启用 `yaml +lsp` | 保持现状 |
| Go | mise 管 go，但 `:lang go` 仍注释；是否启用 `(go +lsp)` | 不启用 |
| treemacs | 是否改 `(treemacs +lsp)` 以启用 `lsp-treemacs` | 不启用 |
| tree-sitter | 需 Windows Emacs 带 tree-sitter（29.1+ build）；可用则给 `javascript`/`rust` 等加 `+tree-sitter` 并启用 `:tools tree-sitter` | 不启用 |
| ibuffer | master 注释、mac 启用；是否打开 | 不打开 |
| 仓库文件 | 是否补 `.gitignore`（`.agent-shell/`、`custom.el`、`*.elc`）、Windows `README.md`、`AGENTS.md`、`snippets/` | 不补 |
| 死声明 | `wakatime-mode`（配置全注释）、`prettier`（`:editor format` 未启用）是否删除 | 保留 |

## 5. 执行步骤（Windows）

1. `git pull` 拿到本文件；确认 `master`。
2. 按第 2、3 节修改 `init.el` / `config.el`（P2 若确认再改）。
3. 同步并重建 profile：

   ```powershell
   doom sync --env
   ```

   - 首次执行会安装 corfu/vertico/consult 等包，需要网络。
   - 若提示 Emacs 版本变化，确认后继续。
   - 退出码非 0 时停止，查看 `$EMACSDIR\.local\state\logs\cli.doom.*.log`。
4. **完全退出并重启 Emacs**（不是 `doom/reload`），让 ivy/company 卸载、新模块生效。
5. 运行诊断：

   ```powershell
   doom doctor
   ```

   `doom doctor` 永远返回 0，只看文本；目标是新增 0 error，允许既有环境告警。

## 6. 验收清单

- [ ] `doom sync` 输出中不再出现 `(:ui doom-dashboard) module was moved` 或未知模块。
- [ ] 启动后 `doom-version` 为 2.2.x，模块数正常（含 corfu/vertico/dashboard）。
- [ ] 首次输入后 `global-corfu-mode` / `vertico-mode` 为 t。
- [ ] `C-s` 调用 `consult-line`；`M-x` 候选由 vertico 显示。
- [ ] `M-x hungry-delete-mode` 相关行为正常（`global-hungry-delete-mode` 已启用）。
- [ ] `(executable-find "go")` / `"node"` 返回 mise shims 路径。
- [ ] 复制中文到系统剪贴板、保存含 CRLF 的文件后为 LF（Windows 编码块仍生效）。

可在一个 scratch buffer 中执行：

```elisp
(list (doom-version)
      (modulep! :completion corfu)
      (modulep! :completion vertico)
      (modulep! :ui dashboard)
      (key-binding (kbd "C-s"))
      (executable-find "node")
      (executable-find "go"))
;; 期望：("2.2.x" t t t consult-line "…\\mise\\shims\\node.exe" "…\\mise\\shims\\go.exe")
```

## 7. 回滚

```powershell
git restore init.el config.el packages.el
doom sync
```

然后完全重启 Emacs。回滚会重新安装 ivy/company，属于预期行为。

## 8. 注意事项

- `doom sync --env` 生成的 `05-doom-env.load.el` 含明文环境变量（可能包含 token/密码），**不要提交、不要贴到 issue/日志**。
- 不要提交 `.agent-shell/`；`custom.el` 与 `*.elc` 也不应入库。
- 不要手工编辑 `$EMACSDIR\.local\**`、`profiles/*.el`、`~/.local/share/doom/profiles*.el*`；它们由 Doom 生成。
- 本仓库行尾保持 LF；Windows 上不要让编辑器把 `.el` 转成 CRLF。
- 若 Windows Doom 仍是旧仓库/旧模块树，先升级 Doom；本任务的模块名（`dashboard`/`corfu`/`vertico`）在旧 core 中不存在。
