;; M-x describe-function FUNCTION
;; M-x describe-symbol SYMBOL
;; M-x describe-variable VARIABLE
;; M-x describe-key KEY_LIST
;; M-x eval-buffer: reload init.el without saving it

;; Performance tweaks for modern machines
(setq gc-cons-threshold 100000000)
(setq read-process-outout-max (* 1024 1024)) ;; 1mb

;; Hide UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Set the font. height = px * 100
(set-face-attribute 'default nil :font "IntelOne Mono" :height 120)

(setq visible-bell t
      ring-bell-function 'ignore)

(global-hl-line-mode) ;; highlight the current line
(global-display-line-numbers-mode) ;; display line number

(blink-cursor-mode -1) ;; disable cursor blinking

;(setq inhibit-startup-screen t) ;; maybe I should look for another useful startup screen?

;(set-language-environment "UTF-8")
;(set-default-coding-systems 'utf-8-unix)

(global-auto-revert-mode t) ;; revert changes in buffer if associated file changed

(electric-pair-mode t) ;; close brackets
(show-paren-mode 1) ;; highlight matched brackets

(setq-default indent-tabs-mode nil)

(save-place-mode t) ;; remembering the last place you visited in a file

(savehist-mode t) ;; Save history in minibuffer to keep recent commands easily accessible

(recentf-mode t) ;; remembering recent edited file

;; Display line numbers only when in programming modes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;(setq show-paren-style 'expression)

;; Add unique buffer names in the minibuffer where there are many
;; identical files. This is super useful if you rely on folders for
;; organization and have lots of files with the same name,
;; e.g. foo/index.ts and bar/index.ts.
(require 'uniquify)

(setq uniquify-buffer-name-style 'forward
      window-resize-pixelwise t
      frame-resize-pixelwise t
      load-prefer-newer t
      backup-by-copying t
      ;; Backups are placed into your Emacs directory, e.g. ~/.config/emacs/backups
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      ;; I'll add an extra note here since user customizations are important.
      ;; Emacs actually offers a UI-based customization menu, "M-x customize".
      ;; You can use this menu to change variable values across Emacs. By default,
      ;; changing a variable will write to your init.el automatically, mixing
      ;; your hand-written Emacs Lisp with automatically-generated Lisp from the
      ;; customize menu. The following setting instead writes customizations to a
      ;; separate file, custom.el, to keep your init.el clean.
      custom-file (expand-file-name "custom.el" user-emacs-directory))

;;;───────────────────── Plugins ─────────────────────

(require 'package)

;; Add MELPA, an unofficial (but well-curated) package registry to the
;; list of accepted package registries. By default Emacs only uses GNU
;; ELPA and NonGNU ELPA, https://elpa.gnu.org/ and
;; https://elpa.nongnu.org/ respectively.
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;; Unless we've already fetched (and cached) the package archives,
;; refresh them.
(unless package-archive-contents
  (package-refresh-contents))

;; Add the :vc keyword to use-package, making it easy to install
;; packages directly from git repositories.
(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))
(require 'vc-use-package)

;; Minibuffer completion is essential to your Emacs workflow
(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  (read-buffer-completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (completion-styles '(basic substring partial-completion flex))
  :init
  (vertico-mode))

;; Improve the accessibility of Emacs documentation by placing
;; descriptions directly in your minibuffer. Give it a try:
;; "M-x find-file".
(use-package marginalia
  :after vertico
  :ensure t
  :init
  (marginalia-mode))

;; Adds intellisense-style code completion at point that works great
;; with LSP via Eglot.
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0)
  (corfu-auto-prefix 1)
  (completion-styles '(basic)))

;; Adds LSP support. Note that you must have the respective LSP
;; server installed on your machine to use it with Eglot. e.g.
;; rust-analyzer to use Eglot with `rust-mode'.
(use-package eglot
  :ensure nil
  :init 
  (setq eglot-events-buffer-size 0)
  :bind (("s-<mouse-1>" . eglot-find-implementation)
         ("C-c ." . eglot-code-action-quickfix))
  ;; Add your programming modes here to automatically start Eglot,
  ;; assuming you have the respective LSP server installed.
  :hook ((go-mode . eglot-ensure)
         (web-mode . eglot-ensure)
         (rust-mode . eglot-ensure))
  :config
  ;; You can configure additional LSP servers by modifying
  ;; `eglot-server-programs'. The following tells eglot to use TypeScript
  ;; language server when working in `web-mode'.
  (add-to-list 'eglot-server-programs
               '(web-mode . ("typescript-language-server" "--stdio"))))

;; Add extra context to Emacs documentation to help make it easier to
;; search and understand. This configuration uses the keybindings 
;; recommended by the package author.
(use-package helpful
  :ensure t
  :bind (("C-h f" . #'helpful-callable)
         ("C-h v" . #'helpful-variable)
         ("C-h k" . #'helpful-key)
         ("C-c C-d" . #'helpful-at-point)
         ("C-h F" . #'helpful-function)
         ("C-h C" . #'helpful-command)))

;; Evil
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-redo)
  (evil-set-leader nil (kbd "SPC"))
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-global-set-key 'motion ";" 'evil-ex)
  (evil-global-set-key 'motion ":" 'evil-repeat-find-char)
  (evil-global-set-key 'normal (kbd "<leader>fs") 'save-buffer)
  (evil-global-set-key 'motion "gh" 'evil-first-non-blank)
  (evil-global-set-key 'motion "gl" 'evil-last-non-blank)

  ;; window motions
  (evil-global-set-key 'motion "\C-h" 'evil-window-left)
  (evil-global-set-key 'motion "\C-j" 'evil-window-down)
  (evil-global-set-key 'motion "\C-k" 'evil-window-up)
  (evil-global-set-key 'motion "\C-l" 'evil-window-right)
  (evil-global-set-key 'motion (kbd "<leader>h") 'evil-window-split)
  (evil-global-set-key 'motion (kbd "<leader>v") 'evil-window-vsplit))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; An extremely feature-rich git client. Activate it with "C-c g".
(use-package magit
  :ensure t
  :bind (("C-c g" . magit-status)))

;; TypeScript, JS, and JSX/TSX support.
(use-package web-mode
  :ensure t
  :mode (("\\.ts\\'" . web-mode)
         ("\\.js\\'" . web-mode)
         ("\\.mjs\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :custom
  (web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  (web-mode-code-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-markup-indent-offset 2)
  (web-mode-enable-auto-quoting nil))
