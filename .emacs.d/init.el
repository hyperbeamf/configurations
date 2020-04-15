;;;; It must be noted that this file is a cluttered mess
;;;; Abandon all hope beyond this point
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3") ; To be honest, I have no idea what this does and just saw it on the emacs subreddit as a fix for something
(package-initialize)
;; packages
;; Systems packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (eval-when-compile (require 'use-package)))
(use-package gnu-elpa-keyring-update
  :ensure t)
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox-dark-medium t))
(use-package mood-line
  :ensure t
  :config
  (mood-line-mode))
(use-package popwin
  :ensure t)
(use-package multiple-cursors
  :ensure t)
(use-package theme-magic ; Export theme to pywal
  :ensure t
  :config
  (require 'theme-magic)
  (theme-magic-export-theme-mode))
(use-package ivy
  :ensure t
  :config
  ;; Get ivy extras
  (use-package swiper
    :ensure t)
  (use-package counsel
    :ensure t)
  ;; Configure ivy
  (ivy-mode 1)
  (setq ivy-height 9)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "[%d|%d] "))
(use-package org
  :ensure t)
(use-package org-bullets
  :ensure t)
;;; Development packages
;; Begin the exceedingly large company config
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (add-hook 'after-init-hook 'global-company-mode)
  (use-package slime-company
    :ensure t))
(use-package company-irony
  :ensure t
  :config
  (require 'company)
  (add-to-list 'company-backends 'company-irony))
(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (add-hook 'emacs-lisp-mode-hook 'company-mode)
  (add-hook 'c-mode-hook 'company-mode)
  (add-hook 'lisp-mode-hook 'company-mode)
  (add-hook 'scheme-mode-hook 'company-mode))
;; End the exceedingly large company config
(use-package yasnippet
  :ensure t
  :config
  (use-package yasnippet-snippets
    :ensure t)
  (yas-reload-all))
(add-hook 'emacs-lisp-mode-hook 'yas-minor-mode)
(add-hook 'c-mode-hook 'yas-minor-mode)
(add-hook 'lisp-mode-hook 'yas-minor-mode)
(add-hook 'scheme-mode-hook 'yas-minor-mode)
(use-package projectile
  :ensure t)
(use-package project-explorer ;TODO: Remove, possibly?
  :ensure t)
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
(use-package magit
  :ensure t)
(use-package slime
  :ensure t)
(use-package paredit
  :ensure t)
(use-package yaml-mode
  :ensure t
  :mode (("\\.yml\\'" . yaml-mode)))
(use-package geiser
  :ensure t)
(use-package sml-mode
  :ensure t)
(use-package diminish ; Prevent cluttering of mode line via cluttering of init.el
  :ensure t
  :config
  (require 'diminish)
  (diminish 'theme-magic-export-theme-mode)
  (diminish 'yas-global-mode)
  (diminish 'ivy-mode))
;; Don't make stupid backup files
(setq make-backup-files nil)
;; Require
(require 'multiple-cursors)
(require 'dired-x)
;;; Word killing function I stole from something
(defun custom/kill-inner-word ()
  (interactive)
  (forward-char 1)
  (backward-word)
  (kill-word 1))
;; Bindings
(global-set-key (kbd "C-s")     'swiper-isearch)
(global-set-key (kbd "M-x")     'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "M-y")     'counsel-yank-pop)
(global-set-key (kbd "C-c M-c") 'mc/edit-lines)
(global-set-key (kbd "C-c C-z") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c C-x") 'mc/mark-previous-like-this)
;;(global-set-key (kbd "C-c C-e") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c v")   'enlarge-window)
(global-set-key (kbd "C-x g")   'magit-status)
(global-set-key (kbd "C-c r")   'project-manager-open)
(global-set-key (kbd "C-c w k") 'custom/kill-inner-word)
(global-unset-key (kbd "C-r"))
(global-unset-key (kbd "C-x c"))
(global-unset-key (kbd "C-x ^"))
;;; Fix yes or no query
(defalias 'yes-or-no-p 'y-or-n-p)
;;; Dired
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'top)
;;; org-mode
;; Org-Bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;; Normal org customs
(setq org-hide-emphasis-markers t
      org-fontify-done-headline t
      org-hide-leading-stars t
      org-pretty-entities t
      org-odd-levels-only t)
;;;; Programming stuff
;; C-Mode
(setq-default c-basic-offset 2
              c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))
;; Projectile
(require 'projectile)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)
(setq projectile-project-search-path '("~/dev/"))
;; CL
(slime-setup '(slime-fancy slime-quicklisp slime-asdf slime-company))
(setq inferior-lisp-program "sbcl")
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))
(add-hook 'emacs-lisp-mode-hook (lambda ()
				  (setq indent-tabs-mode nil)
				  (paredit-mode +1)))
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'slime-repl-mode-hook (lambda ()
                                  (paredit-mode +1)
                                  (override-slime-repl-bindings-with-paredit)))

;; Perl
(defalias 'perl-mode 'cperl-mode)
;;;; End programming things
;;; Popwin
(require 'popwin)
(popwin-mode 1)
;; Project-Manager Popwin
(push "*project-explorer*" popwin:special-display-config)
;; Slime Popwin
(push "*slime-apropos*" popwin:special-display-config)
(push "*slime-macroexpansion*" popwin:special-display-config)
(push "*slime-description*" popwin:special-display-config)
(push '("*slime-compilation*" :noselect t) popwin:special-display-config)
(push "*slime-xref*" popwin:special-display-config)
(push '(sldb-mode :stick t) popwin:special-display-config)
(push 'slime-repl-mode popwin:special-display-config)
(push 'slime-connection-list-mode popwin:special-display-config)
;; Fix the annoying bell
(setq ring-bell-function 'ignore)
;; remove tool bar, menu bar, scroll bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (gruvbox-dark-medium)))
 '(custom-safe-themes
   (quote
    ("aded61687237d1dff6325edb492bde536f40b048eab7246c61d5c6643c696b7f" "939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a" "1a212b23eb9a9bedde5ca8d8568b1e6351f6d6f989dd9e9de7fba8621e8ef82d" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default)))
 '(hl-todo-keyword-faces
   (quote
    (("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f"))))
 '(newsticker-url-list
   (quote
    (("unixporn" "https://www.reddit.com/r/unixporn/.rss" nil nil nil))))
 '(package-selected-packages
   (quote
    (mood-line gruvbox-theme yaml-mode company-irony counsel ivy slime-company geiser nix-mode diminish yasnippet-snippets company theme-magic sml-mode markdown-mode project-explorer projectile multiple-cursors magit rainbow-mode org-bullets paredit slime spacemacs-theme use-package gnu-elpa-keyring-update popwin)))
 '(pdf-view-midnight-colors (quote ("#b2b2b2" . "#292b2e"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "NATH" :family "Office Code Pro Medium")))))
