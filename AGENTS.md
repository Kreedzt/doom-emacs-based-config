# Repository Guidelines

Private Doom Emacs configuration (`$DOOMDIR`) for macOS/Apple Silicon. This repo is **not** a Doom source tree: the framework lives in `~/.config/emacs` (upstream `doomemacs/core`) and its modules in the `doomemacs/modules` submodule. Only the tracked files here are ours to edit.

## Project Overview

- Purpose: personal daily-driver Emacs config layered on Doom, published as dotfiles (`github.com/Kreedzt/doom-emacs-based-config`, branch `mac`).
- Stack: Emacs Lisp; Doom 2.2.4 (`doomemacs/core`, upstream commit `59cdaa3`); official modules from `doomemacs/modules`; packages installed by **straight.el** (not `package.el`).
- Deliberate design choice: **evil is disabled** (`init.el:54`), so Doom's `+emacs-bindings` provide vanilla/leader keys. Do not enable evil or rewrite bindings around it without an explicit request.
- Active stack: corfu + vertico completion, lsp-mode (all `+lsp` flags), flycheck (`:checkers syntax`), magit, org, agent-shell.

## Architecture & Data Flow

Startup chain (each step is upstream except the last):

```
emacs
 └─ ~/.config/emacs/early-init.el          ; doom-initialize
     └─ .local/etc/@/init.31.1.el          ; GENERATED profile (do not edit)
         └─ per-module init.el → config.el ; ordered by init.el's (doom!)
             └─ ~/.doom.d/config.el        ; :user module config
                 └─ custom.el              ; absent / unused
```

- `init.el` is a single `(doom! …)` form: it selects modules and flags; it does not execute settings.
- `doom sync` snapshots the module list into `.local/etc/@/init.31.1.el`, installs packages, and regenerates autoloads.
- `config.el` runs after module configs: use it for Doom-level variables, global keys, and `use-package!` blocks.
- `packages.el` only declares packages (`package!`); it is read by the CLI, never loaded as runtime config.
- The CLI (`bin/doom`) also loads `$DOOMDIR/init.el` for every command — a syntax error there breaks `sync`, `doctor`, and `upgrade`.
- All elisp here is **deferred by design**: autoloads resolve symbols; `use-package!`/`after!`/hooks delay package code until first use.

## Key Directories

| Path | Purpose |
|---|---|
| `~/.doom.d/` | This repo / `$DOOMDIR`: `init.el`, `config.el`, `packages.el`, `snippets/`, `README.md` |
| `~/.doom.d/snippets/<major-mode>/` | yasnippet snippets; loaded for that mode |
| `~/.config/emacs/` | Doom core (`$EMACSDIR`) — upstream, read-only |
| `~/.config/emacs/sources/doom+/modules/` | Official module tree (submodule) — upstream, read-only |
| `~/.config/emacs/.local/straight/` | straight repos and `build-31.1/` — generated |
| `~/.config/emacs/.local/etc/@/` | Generated profile init and env snapshot — never edit |
| `~/.config/emacs/.local/state/logs/` | CLI logs (`cli.doom.*.log`) for failures |
| `~/global_deps/` | Python venv for lsp-bridge, only if that module is re-enabled |

## Development Commands

```sh
DOOM=~/.config/emacs/bin/doom   # not on PATH

$DOOM sync          # after init.el / packages.el edits; network + optional prompts
$DOOM sync -r       # regenerate profile only, offline (fast structural check)
$DOOM sync --env    # refresh env snapshot after PATH/tool changes
$DOOM doctor        # full load of all modules + config.el; prints warnings
$DOOM sync --gc     # purge orphaned package repos/builds
```

- `config.el` and snippets need no sync: `M-x doom/reload` or restart Emacs.
- `doom doctor` **always exits 0**, even with errors — read its text, do not use `$?` as a gate.
- Inspect failures in `~/.config/emacs/.local/state/logs/cli.doom.*.log` (full backtraces).
- `doom sync` may prompt on Emacs version/system-hash changes; run interactively or pass `-!`/`-B` in automation.

## Code Conventions & Common Patterns

- File headers: `init.el` and `config.el` start with `;;; … -*- lexical-binding: t; -*-`. `packages.el` uses `;; -*- no-byte-compile: t; -*-` only. Keep both cookies.
- Placement rule: module enablement → `init.el`; global/Doom variables and package config → `config.el`; dependency declarations → `packages.el`. Do not put `package!` in `config.el` or runtime `setq` in `packages.el`.
- Module list style: enabled modules align trailing comments (~column 26); disabled entries are `;;name` with **no space** and keep their stock comments. Preserve alignment; do not reflow the whole block.
- Flags: `+lsp` on lang/tool modules selects lsp-mode; `+eglot` would switch clients. `(docker +lsp)`, `(popup +defaults)`, `(window-select +numbers)`, `(eval +overlay)`, `(default +bindings +smartparens)` are intentional.
- Conditional modules use the Doom DSL: `(:if IS-MAC macos)`.
- Use `use-package!` (bang), never `use-package`; prefer `after!`, `add-hook!`, `map!`, `setq-hook!` over raw `with-eval-after-load`. Do not `require` packages that have autoloads.
- Naming: internal helpers use `+` prefix (`+corfu-…`, Doom convention); user-private helpers should use a `my-`/`+` prefix and live in `config.el`. Snippet filenames are `<key>(<context>)`, e.g. `stylesheet(liquid.js)`.
- State: Doom variables (`doom-font`, `doom-theme`, `org-directory`) are set top-level before packages load; Emacs `customize` state is not used (`custom.el` absent). Avoid `custom-set-variables` here.
- Error handling: no `condition-case` in config; a broken form aborts startup and sets `init-file-had-error`. Surface errors via `doom doctor`/logs rather than swallowing them.
- Git: one-line English subjects with a gitmoji shortcode, e.g. `:sparkles: add lsp-bridge`, `:wrench: modify lsp-bridge config`; no Conventional Commits, no bodies. Branch: `mac`. Commit config changes separately from docs.
- README is Chinese, terse, H2/H3 + dash bullets; keep commands and paths in sync with the installed Doom layout.

Known inert code (do not “fix” it into something active without asking): `evil-default-state` (evil off), `package-archives` (straight installs packages), `hungry-delete`/`prettier` (declared, never configured), commented codeium/lsp-bridge blocks, and the lsp-bridge setup section in `README.md`.

## Important Files

| File | Role |
|---|---|
| `init.el` | `(doom! …)` module/flag selection; sync required after edits |
| `config.el` | Runtime settings: identity, fonts, theme, org dir, `C-s` → `consult-line`, `.liquid` → `web-mode`, agent-shell/mise |
| `packages.el` | Extra packages: `hungry-delete`, `prettier`, `shell-maker`, `acp`, `agent-shell` |
| `snippets/web-mode/*.js` | Liquid snippets (assign, comment, include, stylesheet) |
| `README.md` | Machine setup notes (Chinese): Doom topology, fonts, lsp-bridge venv |
| `~/.config/emacs/.local/etc/@/init.31.1.el` | **Generated** profile init — never hand-edit |
| `~/.config/emacs/.local/etc/@/init.d/05-doom-env.load.el` | **Generated** env snapshot; contains plaintext secrets (`GITLAB_TOKEN`, `ARCHERY_*_PASSWORD`) — never copy or commit |

## Runtime/Tooling Preferences

- Emacs **31.1** (GUI app via `/opt/homebrew/bin/emacs` wrapper). The profile/eln cache is built for 31.1; an `emacs-30.2` binary also exists — do not use it for `doom` commands.
- Doom CLI is `~/.config/emacs/bin/doom` (not on `PATH`). Do not `git pull`/`git submodule update` inside `~/.config/emacs`; use `doom upgrade`/`doom sync`.
- straight.el with shallow clones; no `straight/versions/default.el` lockfile in this install — pins come from core/module `packages.el`, so “reproducible” is not guaranteed.
- External tools assumed: `rg`, `fd`, `git` ≥ 2.23; `mise` shims (`~/.local/share/mise/shims`) are added only after agent-shell loads.
- `package-archives` mirrors are cosmetic for this setup; package installs go through straight recipes. `doom sync` purges ELPA packages.
- Never byte-compile files in `~/.doom.d`: they depend on Doom macros, shadow sources as `.elc`, and the repo does not ignore `*.elc`.
- Do not commit `.agent-shell/` (repo `.gitignore`) or `.claude/settings.local.json` (machine-global ignore).

## Testing & QA

There is **no test suite, CI, linter, or formatter** in this repo, and none is expected. Verification is Doom-level:

1. **Structural/package check** — `~/.config/emacs/bin/doom sync` (or `sync -r` offline). Proves `init.el`/`packages.el` parse, declared packages install, profile/autoloads regenerate.
2. **Full load check** — `doom doctor`. Loads every module plus `config.el`; baseline is **0 errors, ~11 warnings** (Symbola, `gls`, JS/TS tree-sitter flags, external tools, PATH drift). Exit code is always 0.
3. **Interactive smoke test** — required for keys/fonts/theme:

```sh
emacs --daemon=doom-smoke
# wait ~2s for the socket under "${TMPDIR:-/tmp}/emacs$(id -u)/"
emacsclient -s doom-smoke --eval '(princ (format "%s|%s|%s|%d" emacs-version (doom-version) doom-theme (hash-table-count doom-modules)))'
# expect: 31.1|2.2.4|doom-solarized-light|44
emacsclient -s doom-smoke --eval '(kill-emacs 0)'
```

- After `init.el`/`packages.el` edits: `doom sync`, then restart Emacs or the daemon.
- After `config.el` edits: reload (`M-x doom/reload`) or restart; verify via the daemon eval above.
- For keybindings, assert the command directly: `(key-binding (kbd "C-s"))` → `consult-line`.
- Never validate by deleting/regenerating `.local/**`, `profiles/*.el`, or `~/.local/share/doom/profiles*.el*`; those are generated and may hold secrets.
