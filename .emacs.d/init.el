;;; init.el --- Emacs configuration

;;; Commentary:
;;; Should eventaully split into multiple files

;;; Code:

;; Hide GUI elements
(setq inhibit-startup-message t)
(when window-system
  (tooltip-mode -1)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))
(blink-cursor-mode t)
(setq blink-cursor-blinks 0) ;; Blink forever

;; Font
(set-frame-font "Hack-12")

;;
;; Package management
;;

(require 'package)

;; Disable loading some packages
(add-to-list 'package-load-list '(treemacs nil))
(add-to-list 'package-load-list '(which-key nil))
(add-to-list 'package-load-list '(doom-themes nil))
(add-to-list 'package-load-list '(base16-theme nil))

;;(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; Always download packages
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Paren settings
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

;;(global-prettify-symbols-mode)

(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

(setq vc-follow-symlinks t)

;; Disable emacs VC (I have git for that)
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Remove minor mode clutter
(use-package diminish
  :after (undo-tree eldoc abbrev page-break-lines autorevert)
  :config
  (diminish 'eldoc-mode)
  (diminish 'undo-tree-mode)
  (diminish 'abbrev-mode)
  (diminish 'auto-revert-mode)
  (diminish 'page-break-lines-mode))

;; Document key bindings
(use-package which-key
  :disabled
  :diminish
  :init
  (which-key-mode))

;; Enable external clipboard
(setq select-enable-clipboard t)

;; Keep custom settings in their own file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; Vim keybindings (evil)
(use-package evil
  :init
  (evil-mode 1))

(use-package evil-commentary
  :diminish
  :requires evil
  :config
  (evil-commentary-mode))

(use-package evil-goggles
  :diminish
  :requires evil
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

;; Build keybinds
(global-set-key (kbd "C-x m") (lambda () (interactive)(recompile nil)(other-window 1)))
(global-set-key (kbd "C-x M") (lambda () (interactive)(command-execute 'compile)(other-window 1)))

;; Project management
(use-package projectile
  :diminish
  :config
  (projectile-mode t))

;; Dashboard
(use-package dashboard
  :custom
  (dashboard-show-shortcuts nil)
  (dashboard-banner-logo-title "Welcome to Emacs!")
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
  :config
  (load-theme 'spacemacs-light t))

(use-package base16-theme
  :disabled
  :config
  (load-theme 'base16-bright t))

(use-package doom-themes
  :disabled
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  ;;(load-theme 'doom-tomorrow-night t)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

;; Autoselect help window
(setq help-window-select t)

;; Highlight line
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

;; Scroll settings
(setq scroll-margin 8
      scroll-step 8)

;; Modeline
(use-package spaceline
  :custom
  (spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  :init
  (spaceline-spacemacs-theme))

;; Editor autocompletion
(use-package company
  :diminish
  :custom
  (company-idle-delay 0)
  (company-minimum-prefix-length 3)
  (company-backends '(company-dabbrev-code))
  :bind (:map company-active-map
	      ("M-n" . nil)
	      ("M-p" . nil)
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous))
  :hook
  ((c-mode c++-mode glsl-mode) . company-mode))

;; Editor completion C backends
(use-package company-c-headers
  :after company
  :config
  (add-to-list 'company-backends 'company-c-headers))

(use-package company-irony
  :after (company irony)
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package irony
  :diminish
  :demand
  :hook
  ((c++-mode c-mode) . irony-mode)
  ((irony-mode-hook) . irony-cdb-autosetup-compile-options))

;; Indentation
(setq-default indent-tabs-mode nil)

;;
;; Languages
;;

(use-package cc-mode
  :custom
  (c-default-style "linux")
  (c-basic-offset 4)
  :config
  (add-hook 'c-mode-common-hook (lambda () (setq tab-width 4)))
  (advice-add 'c-update-modeline :around #'ignore))

(use-package glsl-mode)

(use-package company-glsl
  :after (company glsl-mode)
  :config
  (add-to-list 'company-backends 'company-glsl))

(use-package haskell-mode)

(use-package rust-mode)
(use-package flycheck-rust
  :after (rust-mode flycheck)
  :hook
  (flycheck-mode . flycheck-rust-setup))

;; Everything completion
(use-package ivy
  :demand
  :diminish
  :custom
  (ivy-height 15)
  (ivy-fixed-height-minibuffer t)
  (projectile-completion-system 'ivy)
  (enable-recursive-minibuffers t)
  (ivy-wrap t)
  (ivy-on-del-error-function nil)
  (ivy-initial-inputs-alist nil)
  (ivy-virtual-abbreviate 'full)
  (ivy-count-format "(%d/%d) ")
  (ivy-format-function #'ivy-format-function-line)
  :bind (("C-x B" . ivy-switch-buffer-other-window)
	 :map ivy-minibuffer-map
	 ([escape] . minibuffer-keyboard-quit))
  :config
  (ivy-mode t))

(use-package counsel
  :after ivy
  :diminish
  :config
  (counsel-mode t))

(use-package ivy-rich
  :after (ivy counsel)
  :custom
  (ivy-rich-path-style 'abbrev)
  :config
  (ivy-rich-mode 1)
  (ivy-set-display-transformer 'ivy-switch-buffer-other-window
			       'ivy-rich--ivy-switch-buffer-transformer))

;; File tree
;; TODO: fix width adjustment after opening
(use-package treemacs
  :disabled
  :custom
  (treemacs-width 20)
  :bind ("C-x t" . treemacs-select-window))

(use-package treemacs-projectile
  :requires (treemacs projectile))

(use-package treemacs-evil
  :requires (treemacs evil))

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
	       '(evil-normal-state-entry-hook . evil-flycheck-handle-evil-normal-state-entry))
  ;; Use C++ 17 standard
  (add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++17")))
  :hook
  (prog-mode . flycheck-mode))

;; Spell checking
;; Note: aspell and aspell-en packages must be installed
(use-package flyspell
  :custom
  (ispell-program-name (executable-find "aspell"))
  (ispell-list-command "--list"))

;; Git integration
(use-package magit
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  (global-set-key (kbd "C-x l") 'magit-log-current))

(use-package evil-magit
  :requires (magit evil))

(use-package diff-hl
  :config
  (diff-hl-margin-mode)
  (diff-hl-flydiff-mode)
  (global-diff-hl-mode))

;;; init.el ends here
