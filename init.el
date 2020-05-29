(setq inhibit-startup-screen t) ;; maybe I should look for another useful startup screen?

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)

(menu-bar-mode -1) ;; disable menu bar
(tool-bar-mode -1) ;; disable tool bar
(scroll-bar-mode -1) ;; disable scroll bar

(global-hl-line-mode) ;; highlight the current line
(global-display-line-numbers-mode) ;; display line number

(blink-cursor-mode -1) ;; disable cursor blinking

(global-auto-revert-mode) ;; revert changes in buffer if associated file changed

(electric-pair-mode) ;; close brackets
(show-paren-mode) ;; highlight matched brackets
(setq show-paren-style 'expression)

;;───────────────────── Plugins ─────────────────────

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(when (< emacs-major-version 27)
  (package-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(defun move-key (keymap-from keymap-to key)
  "Moves key binding from one keymap to another, deleting from the old location. "
  (define-key keymap-to key (lookup-key keymap-from key))
  (define-key keymap-from key nil))

;; Evil
(use-package evil
  :ensure t
  :config
  (evil-mode)
  
  (move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
  (move-key evil-motion-state-map evil-normal-state-map " ")
  
  (evil-define-key 'normal 'global
    "j" 'evil-next-visual-line
    "k" 'evil-previous-visual-line)
  
  (evil-define-key '(normal visual) 'global
    ";" 'evil-ex
    ":" 'evil-repeat-find-char))

;; key-chord
(use-package key-chord
  :ensure t
  :config
  (key-chord-mode 1)

  (key-chord-define evil-normal-state-map ",." 'evil-force-normal-state)
  (key-chord-define evil-visual-state-map ",." 'evil-change-to-previous-state)
  (key-chord-define evil-insert-state-map ",." 'evil-normal-state)
  (key-chord-define evil-replace-state-map ",." 'evil-normal-state))

;; undo-tree
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))
