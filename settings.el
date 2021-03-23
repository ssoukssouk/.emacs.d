(require 'package)

(setq package-enable-at-startup nil) ;; tells emacs not to load any packages before starting up
;; the following lines tell emacs where on the internet to look up
;; for new packages.
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")
                         ;; ("marmalade" . "http://marmalade-repo.org/packages/")
			 ))
(package-initialize) ; guess what this one does ?

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

(require 'use-package) ; guess what this one does too ?
;; (setq use-package-always-ensure t) ;; Cette commande permet d’éviter les ensure t

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (doom-modeline doom-themes counsel evil which-key avy use-package general))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
(setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
      url-history-file (expand-file-name "url/history" user-emacs-directory))

;; Use no-littering to automatically set common paths to the new user-emacs-directory
(use-package no-littering
  :ensure t)

;; Keep customization settings in a temporary file (thanks Ambrevar!)
(setq custom-file
      (if (boundp 'server-socket-dir)
          (expand-file-name "custom.el" server-socket-dir)
        (expand-file-name (format "emacs-custom-%s.el" (user-uid)) temporary-file-directory)))
(load custom-file t)

(setq delete-old-versions -1 )		; delete excess backup versions silently
(setq version-control t )		; use version control
(setq vc-make-backup-files t )		; make backups file even when in version controlled dir
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ) ; which directory to put backups file
;;(setq vc-follow-symlinks t )				       ; don't ask for confirmation when opening symlinked file
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ) ;transform backups file name
;; (setq inhibit-startup-screen t )	; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore )	; silent bell when you make a mistake
;;(setq coding-system-for-read 'utf-8 )	; use utf-8 by default
;;(setq coding-system-for-write 'utf-8 )
;;(setq sentence-end-double-space nil)	; sentence SHOULD end with only a point.
(setq default-fill-column 80)		; toggle wrapping text at the 80th character
(setq initial-scratch-message "Welcome in Emacs") ; print a default message in the empty scratch buffer opened at startup
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Désactive la barre de menu 

;; (set-frame-parameter (selected-frame) 'alpha '(90 . 90))
;; (add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Scrolling
(setq mouse-wheel-scroll-amount '(2((shift) . 2))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 2) ;; keyboard scroll one line at a time

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  (setq doom-modeline-height 25)
  (setq doom-modeline-major-mode-icons nil)
  (setq doom-modeline-major-mode-icons nil)
)

(use-package doom-themes
  :ensure t
  :init (load-theme 'doom-one t))

(use-package avy :ensure t
  :commands (avy-goto-word-1))

(use-package counsel :ensure t)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)

(use-package ranger :ensure t)
(setq ranger-show-hidden t) 
(setq ranger-show-literal nil) 
(setq ranger-parent-depth 4)
(setq ranger-width-parents 0.07)
     (require  'general)
     (general-define-key 
     :keymaps 'ranger-mode-map
     :prefix "SPC"
     "d" 'ranger-toggle-dotfiles

     "e" '(:ignore t :which-key "mark")
     "ec" '(ranger-copy :which-key "copy")
     "ep" '(ranger-paste :which-key "paste")
     "eu" '(dired-unmark-all-marks :which-key "unmark-all")
     "et" '(dired-mark-unmarked-files :which-key "mark-all")
     "ed" '(dired-do-delete :which-key "delete")

     "n" '(ranger-paste :which-key "paste")
     )
     (general-define-key 
     :keymaps 'ranger-mode-map
     "e" 'ranger-toggle-mark
     "n" 'dired-create-directory
     )

;;Exit insert mode by pressing  and then j quickly
(use-package key-chord :ensure t)
(require 'key-chord)
(key-chord-mode 1)

(use-package evil :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-set-leader nil (kbd "SPC"))
  ;; Use visual line motions even outside of visual-line-mode buffers
  (define-key evil-normal-state-map "s" 'evil-previous-visual-line)
  (define-key evil-normal-state-map "t" 'evil-next-visual-line)
  
  (define-key evil-visual-state-map "s" 'evil-previous-visual-line)
  (define-key evil-visual-state-map "t" 'evil-next-visual-line)

  (define-key evil-normal-state-map "S" 'evil-scroll-line-up)
  (define-key evil-normal-state-map "T" 'evil-scroll-line-down)

  (define-key evil-normal-state-map "D" 'scroll-half-page-up)
  (define-key evil-normal-state-map "U" 'scroll-half-page-down)

  (define-key evil-normal-state-map "r" 'evil-forward-char)
  (define-key evil-normal-state-map "c" 'evil-backward-char)

  (define-key evil-normal-state-map "é" 'evil-forward-word-begin)
  (define-key evil-normal-state-map "e" 'evil-forward-word-end)
  (define-key evil-normal-state-map "b" 'evil-backward-word-begin)
  (define-key evil-normal-state-map "h" 'evil-replace)

  (define-key ranger-mode-map "t" 'ranger-next-file)
  (define-key ranger-mode-map "s" 'ranger-prev-file)
  (define-key ranger-mode-map "c" 'ranger-up-directory)
  (define-key ranger-mode-map "r" 'ranger-find-file)

  ;; (define-key ranger-mode-map "t" 'dired-goto-subdir)
  ;; (define-key ranger-mode-map "s" 'dired-prev-file)
  ;; (define-key ranger-mode-map "c" 'dired-up-directory)
  ;; (define-key ranger-mode-map "r" 'dired-find-file)
)

(setq key-chord-two-keys-delay 0.6)
(key-chord-define evil-insert-state-map "gq" 'evil-normal-state)
;; (key-chord-define evil-normal-state-map "uu" 'evil-scroll-page-up)
;; (key-chord-define evil-insert-state-map "dd" 'evil-scroll-page-down)

(use-package which-key :ensure t)
(require 'which-key)
(which-key-mode)
(which-key-setup-minibuffer)
(setq which-key-max-display-columns 6)

(use-package general :ensure t
  :config
  (general-evil-setup t)
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"

    ;; simple command
    "'"   '(iterm-focus :which-key "iterm")
    "?"   '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
    "/"   'counsel-ag
    "TAB" '(switch-to-prev-buffer :which-key "prev buffer")
    "SPC" '(avy-goto-word-or-subword-1  :which-key "go to char")

    ;; Applications
    "a" '(:ignore t :which-key "Applications")
    "ar" 'ranger
    "ad" 'dired

    ;; bind to simple key press
    "b"   '(:ignore t :which-key "buffers")
    "bb"  'ivy-switch-buffer  ; change buffer, chose using ivy
    "bd"  'kill-current-buffer ;Ferme le buffer 
    "be"  'eval-buffer
    "/"   'counsel-git-grep   ; find string in git project

    ;; bind to double key press
    "f"   '(:ignore t :which-key "files")
    "ff"  'counsel-find-file
    "fs"  'save-buffer

    ;; windows
    "é"   '(:ignore t :which-key "windows")
    "é TAB"'evil-window-next
    "éd"  'evil-window-delete
    "éD"  'delete-other-windows
    "és"  'evil-window-vsplit

    ;; toggles
    "t"  '(:ignore t :which-key "toggles")
    "tw" 'whitespace-mode
    "tt" '(counsel-load-theme :which-key "choose theme")
    "tx" 'text-scale-adjust

    ;;quit
    "q"  '(:ignore q :which-key "quit")
    "qq"  'evil-quit-all
    "qs"  'evil-save-and-quit

    ;;undo-tree
    "u" '(:ignore u :which-key "undo")
    "ut" 'undo-tree-visualize
    "uq" 'undo-tree-visualizer-quit

    ;;jump
    "j"   '(:ignore t :which-key "jump")
    "jj"  '(avy-goto-char :which-key "jump to char")
    "jé"  '(avy-goto-word-0 :which-key "jump to word")
    "jl"  '(avy-goto-line :which-key "jump to line")

    ;;functions
    "x"   '(:ignore t :which-key "fun")
    "xf"  '(describe-function :which-key "desc-fun")
    "xv"  '(describe-variable :which-key "descr-var")
    "xk"  '(describe-package :which-key "descr-pack")
    "xp"  '(check-parens :which-key "check-parens")
    "xc"  '(clm/toggle-command-log-buffer :which-key "cmd-log")

    ;; commenter une sélection
    "#"   '(comment-or-uncomment-region :which-key "comment")
    ))

(use-package minions :ensure t
  :hook (doom-modeline-mode . minions-mode))

(use-package doom-modeline :ensure t
  :after eshell     ;; Make sure it gets hooked after eshell
  :hook (after-init . doom-modeline-init)
  :custom-face
  (mode-line ((t (:height 0.85))))
  (mode-line-inactive ((t (:height 0.85))))
  :custom
  (doom-modeline-height 15)
  (doom-modeline-bar-width 6)
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-mu4e nil)
  (doom-modeline-irc nil)
  (doom-modeline-minor-modes t)
  (doom-modeline-persp-name nil)
  (doom-modeline-buffer-file-name-style 'truncate-except-project)
  (doom-modeline-major-mode-icon nil))

(use-package undo-tree :ensure t
  :init
  (global-undo-tree-mode 1))
       ;; (general-define-key 
       ;; :keymaps 'undo-tree-mode-map
       ;; "s" 'undo-tree-undo
       ;; "t" 'undo-tree-redo
       ;; )
(use-package beacon :ensure t
  :init
  (beacon-mode t)
  )

(defun scroll-half-page-down ()
  "scroll down the page"
  (interactive)
  (scroll-down (/ (window-body-height) 3)))

(defun scroll-half-page-up ()
  "scroll up the page"
  (interactive)
  (scroll-up (/ (window-body-height) 3)))

(use-package command-log-mode
:ensure t
:init (command-log-mode))

;; (use-package visual-basic-mode
;; :ensure t)

(use-package dashboard
  :ensure t
  :init
  (progn
     (setq dashboard-items '((recents  . 5)
			(bookmarks . 5)))
     (setq dashboard-center-content t)
  ;; (setq dashboard-startup-banner 'logo)


     (setq dashboard-startup-banner 'logo)
     (setq dashboard-set-heading-icons t)
     (setq dashboard-set-file-icons t)
  )
  :config
  (dashboard-setup-startup-hook)
  )

  (general-define-key 
  :keymaps 'dashboard-mode-map
  "e" 'dashboard-jump-to-bookmark
  "n" 'dashboard-jump-to-recent-files
   )
;;(require 'evil)
;;(define-key evil-dashboard-state-map "e" 'dashboard-jump-to-recent-files)

(use-package org-bullets
  :ensure t)
  (org-bullets-mode 1)
       ;; (general-define-key 
       ;; :states '(normal visual insert emacs)
       ;; :prefix ","
       ;; "d" 'ranger-
       ;; toggle-dotf
;; iles

;; ;
					; org-end-of-subtree
;; org-backward-heading-same-level
;; org-insert-heading-after-current 
;; org-insert-heading-respect-content
;; org-insert-link
;; org-time-stamp

       ;; "e" '(:ignore t :which-key "mark")
       ;; "ec" '(ranger-copy :which-key "copy")
       ;; "ep" '(ranger-paste :which-key "paste")
       ;; "eu" '(dired-unmark-all-marks :which-key "unmark-all")
       ;; "et" '(dired-mark-unmarked-files :which-key "mark-all")
       ;; "ed" '(dired-do-delete :which-key "delete")

       ;; "n" '(ranger-paste :which-key "paste")
       ;;)

(use-package all-the-icons
  :ensure t
  :init 
  )
