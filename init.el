;; - C-h f function: describe function
;; - C-h o symbol: describe symbol
;; - C-h v variable: describe variable
;;
;; M-x eval-buffer: reload init.el without saving it

;; Performance tweaks for modern machines
(setq gc-cons-threshold 100000000)
(setq read-process-outout-max (* 1024 1024)) ;; 1mb

;; Hide UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

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

(savehist-mode t)

(recentf-mode t) ;; remembering recent edited file

;(setq show-paren-style 'expression)

;; Add unique buffer names in the minibuffer where there are many
;; identical files. This is super useful if you rely on folders for
;; organization and have lots of files with the same name,
;; e.g. foo/index.ts and bar/index.ts.
(require 'uniquify)



;;;───────────────────── Plugins ─────────────────────

(require 'package)

;; Add MELPA, an unofficial (but well-curated) package registry to the
;; list of accepted package registries. By default Emacs only uses GNU
;; ELPA and NonGNU ELPA, https://elpa.gnu.org/ and
;; https://elpa.nongnu.org/ respectively.
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))


;(unless (package-installed-p 'use-package)
;  (package-refresh-contents)
;  (package-install 'use-package))
;(require 'use-package)

;(defun move-key (keymap-from keymap-to key)
;  "Moves key binding from one keymap to another, deleting from the old location. "
;  (define-key keymap-to key (lookup-key keymap-from key))
;  (define-key keymap-from key nil))

;;; Evil
;(use-package evil
;  :ensure t
;  :config
;  (evil-mode)
  
;  (move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
;  (move-key evil-motion-state-map evil-normal-state-map " ")
  
;  (evil-define-key 'normal 'global
;    "j" 'evil-next-visual-line
;    "k" 'evil-previous-visual-line)
  
;  (evil-define-key '(normal visual) 'global
;    ";" 'evil-ex
;    ":" 'evil-repeat-find-char))

;;; key-chord
;(use-package key-chord
;  :ensure t
;  :config
;  (key-chord-mode 1)

;  (key-chord-define evil-normal-state-map ",." 'evil-force-normal-state)
;  (key-chord-define evil-visual-state-map ",." 'evil-change-to-previous-state)
;  (key-chord-define evil-insert-state-map ",." 'evil-normal-state)
;  (key-chord-define evil-replace-state-map ",." 'evil-normal-state))

;;; undo-tree
;(use-package undo-tree
;  :ensure t
;  :config
;  (global-undo-tree-mode))
