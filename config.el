;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;; 设置编码
;; (prefer-coding-system 'utf-8)
;; (set-default-coding-systems 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (set-selection-coding-system (if (eq system-type 'windows-nt) 'utf-16-le 'utf-8))
;; (setq locale-coding-system 'utf-8)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Kreedzt"
      user-mail-address "zhaozisong1@live.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Source Code Pro" :size 18 :weight 'normal)
       doom-variable-pitch-font (font-spec :family "sans" :size 16))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org-notes/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; (setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;                          ("org-cn". "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
;;                          ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; (setq package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
;;                          ("org-cn". "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
;;                          ("melpa" . "https://melpa.org/packages/")))

;; (setq package-archives
;;       '(("melpa" . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/melpa/")
;;         ("org"   . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/org/")
;;         ("gnu"   . "https://raw.githubusercontent.com/d12frosted/elpa-mirror/master/gnu/")))

;; tencent
;; (setq package-archives
;;       '(("melpa-cn" . "http://mirrors.cloud.tencent.com/elpa/melpa/")
;;         ("org-cn"   . "http://mirrors.cloud.tencent.com/elpa/org/")
;;         ("gnu-cn"   . "http://mirrors.cloud.tencent.com/elpa/gnu/")))


;;Key Configuration for Doom as Vanilla Emacs
(setq evil-default-state 'emacs)

;; 设置 Swiper Keymap
;; (global-set-key "\C-s" 'swiper)

;; 设置编码
;; (set-default-coding-systems 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (set-selection-coding-system (if (eq system-type 'windows-nt) 'utf-16-le 'utf-8))
;; (setq locale-coding-system 'utf-8)
;; (prefer-coding-system 'utf-8)

;; 设置 wakatime
;;(setq wakatime-api-key "61055c82-e3d6-46c9-8757-7f9e60019d6b")
;;(setq wakatime-cli-path "C:\\Python39\\Scripts\\wakatime.exe")
;;(global-wakatime-mode)

;; 全局贪婪删除
(global-hungry-delete-mode)

;; search chinse must add this line
;; https://emacs-china.org/t/emacs-helm-ag/6764
(modify-coding-system-alist 'process "rg" '(utf-8 . chinese-gbk-dos))

;; 设置换行符
;; (defun no-junk-please-were-unixish ()
;;   (let ((coding-str (symbol-name buffer-file-coding-system)))
;;     (when (string-match "-\\(?:dos\\|mac\\)$" coding-str)
;;       (set-buffer-file-coding-system 'unix))))

;; (add-hook 'find-file-hooks 'no-junk-please-were-unixish)

; (set-fontset-font t nil "Symbola" nil 'prepend)

; (set-face-attribute
;  'default nil
;  :font (font-spec :name "Monaco" 
;                   :weight 'normal
;                   :slant 'normal
;                   :size 12.5))

; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;   (set-fontset-font
;    (frame-parameter nil 'font)
;    charset
;    (font-spec :name "KaiTi"
;               :weight 'normal
;               :slant 'normal
;               :size 15.0)))


;; 设置 Swiper Keymap
;; (global-set-key "\C-s" 'swiper)
;; (ivy-mode 1)
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "C-r") 'swiper-isearch-backward)
;; (global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; (global-set-key (kbd "M-y") 'counsel-yank-pop)
;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;; (global-set-key (kbd "<f1> l") 'counsel-find-library)
;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;; (global-set-key (kbd "<f2> j") 'counsel-set-variable)
;; (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
;; (global-set-key (kbd "C-c v") 'ivy-push-view)
;; (global-set-key (kbd "C-c V") 'ivy-pop-view)
(setq ivy-count-format "(%d/%d) ")

;; 设置 utf-8
;; (set-language-environment "UTF-8")
;; (set-default-coding-systems 'utf-8)
;; (set-buffer-file-coding-system 'utf-8-unix)
;; (set-clipboard-coding-system 'utf-8-unix)
;; (set-file-name-coding-system 'utf-8-unix)
;; (set-keyboard-coding-system 'utf-8-unix)
;; (set-next-selection-coding-system 'utf-8-unix)
;; (set-selection-coding-system 'utf-8-unix)
;; (set-terminal-coding-system 'utf-8-unix)
;; (setq locale-coding-system 'utf-8)
;; (prefer-coding-system 'utf-8)

;; MS-Windows spec
 ;; (when (eq system-type 'windows-nt)
 ;;   (set-default 'process-coding-system-alist
 ;;     '(("[pP][lL][iI][nN][kK]" gbk-dos . gbk-dos)
 ;;        ("[cC][mM][dD][pP][rR][oO][xX][yY]" gbk-dos . gbk-dos))))

;; jacobsun
(when (eq system-type 'windows-nt)
  (set-next-selection-coding-system 'utf-16-le)
  (set-selection-coding-system 'utf-16-le)
  (set-clipboard-coding-system 'utf-16-le))
;; hick
(set-default-coding-systems 'utf-8)

;; 设置 wakatime
;;(setq wakatime-api-key "61055c82-e3d6-46c9-8757-7f9e60019d6b")
;;(setq wakatime-cli-path "C:\\Python39\\Scripts\\wakatime.exe")
;;(global-wakatime-mode)

;; 全局贪婪删除
(global-hungry-delete-mode)

;; 设置换行符
(defun no-junk-please-were-unixish ()
  (let ((coding-str (symbol-name buffer-file-coding-system)))
    (when (string-match "-\\(?:dos\\|mac\\)$" coding-str)
      (set-buffer-file-coding-system 'unix))))

(add-hook 'find-file-hooks 'no-junk-please-were-unixish)

;; mode line
(load! "~/awesome-tray/awesome-tray.el")
(require 'awesome-tray)
(awesome-tray-mode 1)


;;修改windows版本的PATH路径。
(setenv "PATH"
        (concat
         "C:/ProgramData/scoop/shims" ";"
         "c:/Users/zhaoz/scoop/shims" ";"
         (getenv "PATH")
         )
        )
