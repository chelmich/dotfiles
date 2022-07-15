;;; init.el --- Emacs configuration

;;; Code:

;; Hide GUI elements
(setq inhibit-startup-message t)
(when window-system
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;; Initialize package system
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Disable annoying bell
(setq ring-bell-function 'ignore)

;; Blink the cursor forever
(blink-cursor-mode t)
(setq blink-cursor-blinks 0)

;; Autoselect help window
(setq help-window-select t)

;; Line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Show trailing whitespace
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

;; Indentation
(setq-default indent-tabs-mode nil)

;; Scroll settings
(setq scroll-margin 8)
(setq scroll-step 8)
(setq mouse-wheel-scroll-amount '(3))
(setq mouse-wheel-progressive-speed nil)
(setq scroll-preserve-screen-position t)
(setq scroll-error-top-bottom t)

;; Highlight matching parens
(use-package paren
  :custom
  (show-paren-delay 0)
  :config
  (show-paren-mode t))

;; Complete parens
(use-package elec-pair
  :config
  (setq electric-pair-pairs '((?\{ . ?\})
                              (?\( . ?\))
                              (?\[ . ?\])
                              (?\" . ?\")))
  :hook
  (prog-mode . electric-pair-local-mode))

;; Disable automatic backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

(setq vc-follow-symlinks t)

;; Revert to reflect changed files
(use-package autorevert
  :diminish auto-revert-mode
  :config
  (global-auto-revert-mode))

;; Remove minor mode clutter
(use-package diminish
  :config
  (diminish 'abbrev-mode))

(use-package eldoc
  :diminish eldoc-mode)

;; Enable external clipboard
(setq select-enable-clipboard t)

;; Set the font
(when (eq system-type 'windows-nt)
  (set-frame-font "Consolas-11" nil t))

;; Keep custom settings in their own file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Recent files
(use-package recentf
  :config
  (add-to-list 'recentf-exclude "/elpa"))

;; Vim bindings
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (evil-mode 1))

(use-package evil-collection
  :after evil)

(use-package evil-commentary
  :diminish
  :requires evil
  :config
  (evil-commentary-mode))

(use-package evil-goggles
  :diminish
  :requires evil
  :custom
  (evil-goggles-pulse nil)
  (evil-goggles-duration 0.15)
  :config
  (evil-goggles-mode))

;; Build keybinds
(global-set-key (kbd "C-x m")
                (lambda () (interactive)(recompile nil)(other-window 1)))
(global-set-key (kbd "C-x M")
                (lambda () (interactive)(command-execute 'compile)(other-window 1)))

;; Undo history management
(use-package undo-tree
  :after evil
  :diminish
  :custom
  (undo-tree-auto-save-history nil)
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))

;; Project management
(use-package projectile
  :diminish
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode t))

;; Show lines instead of ^L
(use-package page-break-lines
  :diminish
  :config
  (global-page-break-lines-mode))

;; Dashboard
(use-package dashboard
  :custom
  (dashboard-show-shortcuts nil)
  (dashboard-center-content t)
  (dashboard-set-init-info t)
  (dashboard-set-footer nil)
  (dashboard-items '((recents . 10)
                     (projects . 5)
                     (bookmarks . 5)))
  :config
  (dashboard-setup-startup-hook))

;; Colorscheme
(use-package spacemacs-common
  :ensure spacemacs-theme
  :custom
  (spacemacs-theme-comment-bg nil)
  (spacemacs-theme-underline-parens nil)
  :custom-face
  (ivy-highlight-face ((t (:inherit bold))))
  (ivy-minibuffer-match-face-1 ((t (:inherit nil))))
  (diff-hl-change ((t (:background "#d1dcdf"))))
  (diff-hl-delete ((t (:background "#eed9d2"))))
  (diff-hl-insert ((t (:background "#dae6d0"))))
  (evil-goggles-yank-face ((t (:background "#f6f1e1" :foreground "#b1951d"))))
  (evil-goggles-indent-face ((t (:background "#d1dcdf" :foreground "#3a81c3"))))
  (evil-goggles-join-face ((t (:background "#d1dcdf" :foreground "#3a81c3"))))
  :config
  (load-theme 'spacemacs-light t))

;; Highlight the current line
(use-package hl-line
  :preface
  (defvar-local was-hl-line-mode-on nil)
  (defun hl-line-on-maybe ()
    "Turn on 'hl-line-mode' if it was on previously."
    (if was-hl-line-mode-on (hl-line-mode +1)))
  (defun hl-line-off-maybe ()
    "Turn off 'hl-line-mode' if it was on previously."
    (if was-hl-line-mode-on (hl-line-mode -1)))

  :custom
  (hl-line-sticky-flag nil)
  (global-hl-line-sticky-flag nil)

  :config
  (when window-system (add-hook 'prog-mode-hook 'hl-line-mode))

  (add-hook 'hl-line-mode-hook
            (lambda () (if hl-line-mode (setq was-hl-line-mode-on t))))

  (add-hook 'evil-visual-state-entry-hook 'hl-line-off-maybe)
  (add-hook 'evil-visual-state-exit-hook 'hl-line-on-maybe))

;; Modeline
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; Editor autocompletion
(use-package company
  :diminish
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 3)
  (company-backends '(company-dabbrev-code
                      company-elisp))
  (company-selection-wrap-around t)
  :bind (:map company-active-map
              ("M-n" . nil)
              ("M-p" . nil)
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)
              ("C-s" . counsel-company))
  :hook
  ((c-mode c++-mode) . company-mode)
  (glsl-mode . company-mode)
  (emacs-lisp-mode . company-mode))

;;
;; Languages
;;

;; C/C++
(use-package cc-mode
  :custom
  (c-default-style "personal")
  :config
  (c-add-style "personal"
               '("java"
                 (c-basic-offset . 4)
                 (c-offsets-alist
                  (access-label . -))))
  (advice-add 'c-update-modeline :around #'ignore))

;; C/C++ completion backends
(use-package company-c-headers
  :after company
  :config
  (add-to-list 'company-backends 'company-c-headers))

;; Only use irony on Linux
(when (eq system-type 'gnu/linux)
  (use-package company-irony
    :after (company irony)
    :config
    (add-to-list 'company-backends 'company-irony))

  (use-package irony
    :diminish
    :demand
    :hook
    ((c++-mode c-mode) . irony-mode)
    ((irony-mode-hook) . irony-cdb-autosetup-compile-options)))

;; GLSL
(use-package glsl-mode)
(use-package company-glsl
  :after (company glsl-mode)
  :config
  (add-to-list 'company-backends 'company-glsl))

;; Haskell
(use-package haskell-mode)

;; Rust
(use-package rust-mode)
(use-package flycheck-rust
  :after (rust-mode flycheck))

;; Everything completion
(use-package ivy
  :demand
  :diminish
  :custom
  (ivy-wrap t)
  (ivy-on-del-error-function 'ignore)
  (ivy-initial-inputs-alist nil)
  (ivy-virtual-abbreviate 'full)
  (ivy-count-format "%d/%d ")
  (ivy-format-function #'ivy-format-function-line)
  :bind (("C-x B" . ivy-switch-buffer-other-window)
         ("C-c C-r" . ivy-resume)
         :map ivy-minibuffer-map
         ([escape] . minibuffer-keyboard-quit))
  :config
  (ivy-mode t))

(use-package counsel
  :after ivy
  :diminish
  :config
  (counsel-mode t))

;; Incremental search using ivy
(use-package swiper
  :after ivy
  :bind ("C-s" . swiper))

;; Syntax checking
(use-package flycheck
  :diminish
  :after evil
  :config
  ;; Don't recheck after a newline
  (setq flycheck-check-syntax-automatically
        (delq 'new-line flycheck-check-syntax-automatically))

  (defun evil-flycheck-handle-evil-normal-state-entry ()
    "Handle switching to normal state in evil."
    (flycheck-buffer-automatically 'evil-normal-state))

  (add-to-list 'flycheck-check-syntax-automatically 'evil-normal-state)
  (add-to-list 'flycheck-hooks-alist
               '(evil-normal-state-entry-hook . evil-flycheck-handle-evil-normal-state-entry)))

;; Spell checking
;; Note: aspell and aspell-en packages must be installed
(use-package flyspell
  :if (eq system-type 'gnu/linux)
  :custom
  (ispell-program-name (executable-find "aspell"))
  (ispell-list-command "--list"))

;; Git integration
(use-package magit
  :after (evil evil-collection)
  :bind (("C-x g" . magit-status)
         ("C-x l" . magit-log-current))
  :config
  (evil-collection-magit-setup))

;; Preview VC diffs in the fringe
;; FIXME: diff doesn't refresh after commit
(use-package diff-hl
  :config
  (global-diff-hl-mode))

;;; init.el ends here
