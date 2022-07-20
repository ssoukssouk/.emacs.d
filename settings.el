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
(require 'org)

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
(setq org-clock-sound "~/.emacs.d/downloads/ding.wav")
(setq display-line-numbers 'relative)

;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
(setq user-emacs-directory (expand-file-name "~/.emacs.d/bin/emacs/")
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
;; (setq kept-old-versions 2 )	;number of oldest versions to keep when a new numbered backup is made
;; (setq kept-new-versions 2 ) ;number of newest versions to keep when a new numbered backup is made. Includes the new backup.
;; (setq backup-directory-alist `(("." . "~/.emacs.d/tmp/backups")) ) ; which directory to put backups file
;; (setq vc-follow-symlinks t )				       ; don't ask for confirmation when opening symlinked file
;; (setq auto-save-file-name-transforms '((".*" "~/.emacs.d/tmp/auto-save-list/" t)) ) ;transform backups file name

;; (setq inhibit-startup-screen t )	; inhibit useless and old-school startup screen
(setq ring-bell-function 'ignore )	; silent bell when you make a mistake

(setq coding-system-for-read 'utf-8 )	; use utf-8 by default
;;(setq coding-system-for-write 'utf-8 )
;;(setq sentence-end-double-space nil)	; sentence SHOULD end with only a point.
;;(setq default-fill-column 80)		; toggle wrapping text at the 80th character
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

(use-package smooth-scrolling
:ensure t
:init
(smooth-scrolling-mode t)
)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  (setq doom-modeline-height 25)
  (setq doom-modeline-major-mode-icons nil)
  (setq doom-modeline-major-mode-icons nil)
)

(use-package doom-themes
  :ensure t
  :init (load-theme 'doom-old-hope t))

(use-package cycle-themes
   :ensure t
   :init (setq cycle-themes-theme-list
          '('doom-one 'doom-molokai 'doom-snazzy 'doom-old-hope 'doom-henna 'doom-peacock))
   :config (cycle-themes-mode))

(use-package which-key
  :diminish which-key-mode
  :init
  (which-key-mode)
  (which-key-setup-minibuffer)
  :config
  (setq which-key-idle-delay 0.3)
  (setq which-key-prefix-prefix "")
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-min-display-lines 6
        which-key-max-display-columns nil))

(use-package general)

(general-define-key
 :states '(normal motion visual)
 :keymaps 'override
 :prefix "SPC"

 ;; Top level functions
 "/" '(counsel-git-grep :which-key "grep")
 ";" '(spacemacs/deft :which-key "deft")
 ":" '(project-find-file :which-key "p-find file")
 "." '(counsel-find-file :which-key "find file")
 "," '(counsel-recentf :which-key "recent files")
 "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
 "SPC" '(avy-goto-char  :which-key "go to char")
 "x" '(counsel-M-x :which-key "M-x")
 "q" '(save-buffers-kill-terminal :which-key "quit emacs")
 "r" '(jump-to-register :which-key "registers")
 "c" 'org-capture

;; "Applications"
"a" '(nil :which-key "applications")
"ao" '(org-agenda :which-key "org-agenda")
;"am" '(mu4e :which-key "mu4e")
"aC" '(calc :which-key "calc")
;"ac" '(org-capture :which-key "org-capture")
;"aqq" '(org-ql-view :which-key "org-ql-view")
;"aqs" '(org-ql-search :which-key "org-ql-search")

;"ab" '(nil :which-key "browse url")
;"abf" '(browse-url-firefox :which-key "firefox")
;"abc" '(browse-url-chrome :which-key "chrome")
;"abx" '(xwidget-webkit-browse-url :which-key "xwidget")
;"abg" '(jib/er-google :which-key "google search")

"ar" 'ranger
"ad" 'dired

;; Buffers
"b" '(nil :which-key "buffer")
"bb" '(counsel-switch-buffer :which-key "switch buffers")
"bd" '(evil-delete-buffer :which-key "delete buffer")
;;"bs" '(jib/switch-to-scratch-buffer :which-key "scratch buffer")
;;"bm" '(jib/kill-other-buffers :which-key "kill other buffers")
"bi" '(clone-indirect-buffer  :which-key "indirect buffer")
"br" '(revert-buffer :which-key "revert buffer")
"bn" '(evil-buffer-new :which-key "new")

;; Files
"f" '(nil :which-key "files")
"fb" '(counsel-bookmark :which-key "bookmarks")
"ff" '(counsel-find-file :which-key "find file")
"fn" '(spacemacs/new-empty-buffer :which-key "new file")
"fr" '(counsel-recentf :which-key "recent files")
"fR" '(rename-file :which-key "rename file")
"fs" '(save-buffer :which-key "save buffer")
"fS" '(evil-write-all :which-key "save all buffers")
"fo" '(reveal-in-osx-finder :which-key "reveal in finder")
;; "fO" '(jib/open-buffer-file-mac :which-key "open buffer file")

;; macros
"m"  '(:ignore t :which-key "macros")
"ms" 'weekly-schedule
"mj" 'archive-jour
"mt" 'gotoday
"ml" 'listecocher
"md" 'flush-empty-lines

;; Help/emacs
"h" '(nil :which-key "help/emacs")

"hv" '(counsel-describe-variable :which-key "des. variable")
"hb" '(counsel-descbinds :which-key "des. bindings")
"hM" '(describe-mode :which-key "des. mode")
"hf" '(counsel-describe-function :which-key "des. func")
"hF" '(counsel-describe-face :which-key "des. face")
"hk" '(describe-key :which-key "des. key")

"hed" '((lambda () (interactive) (jump-to-register 67)) :which-key "edit dotfile")

"hm" '(nil :which-key "switch mode")
"hme" '(emacs-lisp-mode :which-key "elisp mode")
"hmo" '(org-mode :which-key "org mode")
"hmt" '(text-mode :which-key "text mode")

"hp" '(nil :which-key "packages")
"hpr" 'package-refresh-contents
"hpi" 'package-install
"hpd" 'package-delete

;; Help/emacs
"x" '(nil :which-key "text")
"xr" '(anzu-query-replace :which-key "find and replace")
"xs" '(yas-insert-snippet :which-key "insert yasnippet")

;; Toggles
"t" '(nil :which-key "toggles")
"tv" '(visual-line-mode :which-key "visual line mode")
"tn" '(display-line-numbers-mode :which-key "display line numbers")
"ta" '(mixed-pitch-mode :which-key "variable pitch mode")
;;"tC" '(visual-fill-column-mode :which-key "visual fill column mode")
;;"tw" '(writeroom-mode :which-key "writeroom-mode")
"tR" '(read-only-mode :which-key "read only mode")
"tI" '(toggle-input-method :which-key "toggle input method")
;;"tr" '(display-fill-column-indicator-mode :which-key "fill column indicator")
"tm" '(hide-mode-line-mode :which-key "hide modeline mode")
"tw" '(whitespace-mode :which-key "white space")
"th" '(counsel-load-theme :which-key "choose theme")
"tf" '(toggle-frame-fullscreen :which-key "fullscreen")
"tt" '(toggle-transparency :which-key "transparancy")
"tx" '(hydra-text-scale/body :which-key "scale text")
"tc" '(toggle-truncate-lines :which-key "truncate-lines")

;; Windows
"é" '(nil :which-key "window")
;;"ém" '(jib/toggle-maximize-buffer :which-key "maximize buffer")
"éN" '(make-frame :which-key "make frame")
"éd" '(evil-window-delete :which-key "delete window")
"é-" '(split-window-vertically :which-key "split below")
"é/" '(split-window-horizontally :which-key "split right")
"él" '(evil-window-right :which-key "evil-window-right")
"éh" '(evil-window-left :which-key "evil-window-left")
"éj" '(evil-window-down :which-key "evil-window-down")
"ék" '(evil-window-up :which-key "evil-window-up")
"éz" '(text-scale-adjust :which-key "text zoom")
"é TAB" '(evil-window-next :wich-key "next")
"éD"  'delete-other-windows
"és"  'evil-window-vsplit

;; Jump
"j"   '(:ignore t :which-key "jump")
"jj"  '(avy-goto-char :which-key "jump to char")
"jé"  '(avy-goto-word-0 :which-key "jump to word")
"jl"  '(avy-goto-line :which-key "jump to line")

;;undo-tree
"u" '(:ignore u :which-key "undo")
"ut" 'undo-tree-visualize
"uq" 'undo-tree-visualizer-quit

;;dashboard
"d"   '(:ignore t :which-key "dash")
"dk" 'dashboard-jump-to-bookmarks
"dr" 'dashboard-jump-to-recent-files

;; commenter une sélection
"#"   '(comment-or-uncomment-region :which-key "comment")

"i" '(nil :which-key "switch")
"it" '(jb-hydra-theme-switcher/body :which-key "themes")
"if" '(jb-hydra-variable-fonts/body :which-key "mixed-pitch face")
"ié" '(jb-hydra-window/body :which-key "window control")

;(define-key ranger-mode-map "t" 'ranger-next-file)
;(define-key ranger-mode-map "s" 'ranger-prev-file)
;(define-key ranger-mode-map "c" 'ranger-up-directory)
;(define-key ranger-mode-map "r" 'ranger-find-file)

;; Subtree
  "s" '(:ignore t :which-key "Subtree")
  "sn" 'org-narrow-to-subtree
   "sw" 'widen
) ;; End SPC prefix block

;; All-mode keymaps
(general-def
  :keymaps 'override

  ;; Emacs --------
  "M-x" 'counsel-M-x
  "ß" 'evil-window-next ;; option-s
  "Í" 'other-frame ;; option-shift-s
  "C-S-B" 'counsel-switch-buffer
  "∫" 'counsel-switch-buffer ;; option-b
  "s-o" 'jb-hydra-window/body

  ;; Remapping normal help features to use Counsel version
  "C-h v" 'counsel-describe-variable
  "C-h o" 'counsel-describe-symbol
  "C-h f" 'counsel-describe-function
  "C-h F" 'counsel-describe-face

  ;; Editing ------
  "M-v" 'simpleclip-paste
  "M-V" 'evil-paste-after ;; shift-paste uses the internal clipboard
  "M-c" 'simpleclip-copy
  "M-u" 'capitalize-dwim ;; Default is upcase-dwim
  "M-U" 'upcase-dwim ;; M-S-u (switch upcase and capitalize)
  "M-z" 'undo-fu-only-undo
  "M-S" 'undo-fu-only-redo

  ;; Utility ------
  "C-c c" 'org-capture
  "C-c a" 'org-agenda
  "C-s" 'swiper ;; Large files will use grep (faster)
  "s-\"" 'ispell-word ;; that's super-shift-'
  ;;"M-+" 'jib/calc-speaking-time
  "C-'" 'avy-goto-char-2

  "C-x C-b" 'bufler-list

  ;; super-number functions
  "s-1" 'mw-thesaurus-lookup-dwim
  "s-!" 'mw-thesaurus-lookup
  "s-2" 'ispell-buffer
  "s-3" 'revert-buffer
  ;;"s-4" '(lambda () (interactive) (counsel-file-jump nil jib/dropbox))
  ;;"s-5" '(lambda () (interactive) (counsel-rg nil jib/dropbox))
  "s-6" 'org-capture
  )

(general-def
 :keymaps 'emacs
  "C-w C-q" 'kill-this-buffer
 )

;; Non-insert mode keymaps
(general-def
  :states '(normal visual motion)
  "gc" 'comment-dwim
  "u" 'undo-fu-only-undo
  "U" 'undo-fu-only-redo
  "gC" 'comment-line
  "|" '(lambda () (interactive) (org-agenda nil "k")) ;; Opens my n custom org-super-agenda view
  "C-|" '(lambda () (interactive) (org-agenda nil "j")) ;; Opens my m custom org-super-agenda view

  "s" 'evil-previous-visual-line
  "t" 'evil-next-visual-line

  "T" 'scroll-half-page-up
  "S" 'scroll-half-page-down

  "r" 'evil-forward-char
  "c" 'evil-backward-char

  "é" 'evil-forward-word-begin
  "e" 'evil-forward-word-end
  "b" 'evil-backward-word-begin
  "h" 'evil-replace
  )

;; Insert keymaps
;; Many of these are emulating standard Emacs bindings in Evil insert mode, such as C-a, or C-e.
(general-def
  :states '(insert)
  "C-a" 'evil-beginning-of-visual-line
  "C-e" 'evil-end-of-visual-line
  "C-S-a" 'evil-beginning-of-line
  "C-S-e" 'evil-end-of-line
  "C-n" 'evil-next-visual-line
  "C-p" 'evil-previous-visual-line
  )

   ;;(define-key evil-insert-state-map (kbd "M-«") "<")
   ;;(define-key evil-insert-state-map (kbd "M-»") ">")
   ;;(define-key evil-insert-state-map (kbd "M-(") "[")
   ;;(define-key evil-insert-state-map (kbd "M-)") "]")
   ;;(define-key evil-insert-state-map (kbd "M-b") "|")
   ;;(define-key evil-insert-state-map (kbd "M-ê") "\\")
   ;;(define-key evil-insert-state-map (kbd "M-à") "/")
   ;;(define-key evil-insert-state-map (kbd "M-y") "{")
   ;;(define-key evil-insert-state-map (kbd "M-x") "}")
   ;;(define-key evil-insert-state-map (kbd "M-p") "&")
   ;;(define-key evil-insert-state-map (kbd "M-n") "~")
   ;;(define-key evil-insert-state-map (kbd "M-e") "€")

(use-package ranger :ensure t)
(setq ranger-show-hidden t) 
(setq ranger-show-literal nil) 
(setq ranger-parent-depth 4)
(setq ranger-width-parents 0.07)
     (require 'general)
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
     "r" 'ranger-show-drives
     "q" 'ranger-close
     )
     ;;(general-define-key 
     ;;:keymaps 'ranger-mode-map
     ;;"e" 'ranger-toggle-mark
     ;;)

(use-package evil
  :init
  ;; (setq evil-want-keybinding t)
  (setq evil-want-fine-undo t)
  (setq evil-want-keybinding nil)
  (setq evil-want-Y-yank-to-eol t)
  :config

  (evil-set-initial-state 'dashboard-mode 'motion)
  (evil-set-initial-state 'debugger-mode 'motion)
  (evil-set-initial-state 'pdf-view-mode 'motion)
  (evil-set-initial-state 'bufler-list-mode 'emacs)
  (evil-set-initial-state 'inferior-python-mode 'emacs)
  (evil-set-initial-state 'term-mode 'emacs)

  ;; ----- Keybindings
  ;; I tried using evil-define-key for these. Didn't work.
  ;; (define-key evil-motion-state-map "/" 'swiper)
  (define-key evil-window-map "\C-q" 'evil-delete-buffer) ;; Maps C-w C-q to evil-delete-buffer (The first C-w puts you into evil-window-map)
  (define-key evil-window-map "\C-w" 'kill-this-buffer)
  (define-key evil-motion-state-map "\C-b" 'evil-scroll-up) ;; Makes C-b how C-u is

  ;; ----- Setting cursor colors
  (setq evil-emacs-state-cursor    '("#649bce" box))
  (setq evil-normal-state-cursor   '("#ebcb8b" box))
  (setq evil-operator-state-cursor '("#ebcb8b" hollow))
  (setq evil-visual-state-cursor   '("#677691" box))
  (setq evil-insert-state-cursor   '("#eb998b" (bar . 2)))
  (setq evil-replace-state-cursor  '("#eb998b" hbar))
  (setq evil-motion-state-cursor   '("#ad8beb" box))

  (evil-mode 1))

(evil-define-key 'motion help-mode-map "q" 'kill-this-buffer)
(evil-define-key 'motion calendar-mode-map "q" 'kill-this-buffer)

;;Exit insert by pressing  g and q quickly
  (use-package key-chord :ensure t)
  (require 'key-chord)
  (key-chord-mode 1)
  (setq key-chord-two-keys-delay 0.6)
  (key-chord-define evil-insert-state-map "gq" 'evil-normal-state)

(use-package hydra
   :defer t)

 ;; This Hydra lets me swich between variable pitch fonts. It turns off mixed-pitch 
 ;; WIP
 (defhydra jb-hydra-variable-fonts (:pre (mixed-pitch-mode 0)
				      :post (mixed-pitch-mode 1))
   ("t" (set-face-attribute 'variable-pitch nil :family "Times New Roman" :height 160) "Times New Roman")
   ("g" (set-face-attribute 'variable-pitch nil :family "EB Garamond" :height 160 :weight 'normal) "EB Garamond")
   ;; ("r" (set-face-attribute 'variable-pitch nil :font "Roboto" :weight 'medium :height 160) "Roboto")
   ("n" (set-face-attribute 'variable-pitch nil :slant 'normal :weight 'normal :height 160 :width 'normal :foundry "nil" :family "Nunito") "Nunito")
   )

 (defhydra jb-hydra-theme-switcher (:hint nil)
   "
      Dark                ^Light^
 ----------------------------------------------
 _1_ one              _z_ one-light 
 _2_ vivendi          _x_ operandi
 _3_ molokai          _c_ jake-plain
 _4_ snazzy           _v_ flatwhite
 _5_ old-hope         _b_ opera-light 
 _6_ henna                ^
 _7_ kaolin-galaxy        ^
 _8_ peacock              ^
 _9_ jake-plain-dark      ^
 _0_ monokai-machine      ^
 _-_ xcode                ^
 _q_ quit                 ^
 ^                        ^
 "

   ;; Dark
   ("1" (load-theme 'doom-one) "one")
   ("2" (load-theme 'modus-vivendi) "modus-vivendi")
   ("3" (load-theme 'doom-molokai) "molokai")
   ("4" (load-theme 'doom-snazzy) "snazzy")
   ("5" (load-theme 'doom-old-hope) "old-hope")
   ("6" (load-theme 'doom-henna) "henna")
   ("7" (load-theme 'kaolin-galaxy) "kaolin-galaxy")
   ("8" (load-theme 'doom-peacock) "peacock")
   ("9" (load-theme 'jake-doom-plain-dark) "jake-plain-dark")
   ("0" (load-theme 'doom-monokai-machine) "monokai-machine")
   ("-" (load-theme 'doom-xcode) "xcode")

   ;; Light
   ("z" (load-theme 'doom-one-light) "one-light")
   ("x" (load-theme 'modus-operandi) "modus-operandi")
   ("c" (load-theme 'jake-doom-plain) "jake-plain")
   ("v" (load-theme 'doom-flatwhite) "flatwhite")
   ("b" (load-theme 'doom-opera-light) "opera-light")
   ("q" nil))

 ;; I think I need to initialize windresize to use its commands
 ;;(windresize)
 ;;(windresize-exit)

 ;;(use-package windresize)

 ;; All-in-one window managment. Makes use of some custom functions,
 ;; `ace-window' (for swapping), `windmove' (could probably be replaced
 ;; by evil?) and `windresize'.
 ;; inspired by https://github.com/jmercouris/configuration/blob/master/.emacs.d/hydra.el#L86
 ;;(defhydra jb-hydra-window (:hint nil)
;;    "
;; Movement      ^Split^            ^Switch^        ^Resize^
;; ----------------------------------------------------------------
;; _M-<left>_  <   _/_ vertical      _b_uffer        _<left>_  <
;; _M-<right>_ >   _-_ horizontal    _f_ind file     _<down>_  ↓
;; _M-<up>_    ↑   _m_aximize        _s_wap          _<up>_    ↑
;; _M-<down>_  ↓   _c_lose           _[_backward     _<right>_ >
;; _q_uit          _e_qualize        _]_forward     ^
;; ^               ^               _K_ill         ^
;; ^               ^                  ^             ^
;; "
    ;; Movement
    ;;("M-<left>" windmove-left)
    ;;("M-<down>" windmove-down)
    ;;("M-<up>" windmove-up)
    ;;("M-<right>" windmove-right)

    ;; Split/manage
    ;;("-" jib/split-window-vertically-and-switch)
    ;;("/" jib/split-window-horizontally-and-switch)
    ;;("c" evil-window-delete)
    ;;("d" evil-window-delete)
    ;;("m" delete-other-windows)
    ;;("e" balance-windows)

    ;; Switch
    ;;("b" counsel-switch-buffer)
    ;;("f" counsel-find-file)
    ;;("P" project-find-file)
    ;;("s" ace-swap-window)
    ;;("[" previous-buffer)
    ;;("]" next-buffer)
    ;;("K" kill-this-buffer)

    ;; Resize
    ;;("<left>" windresize-left)
    ;;("<right>" windresize-right)
    ;;("<down>" windresize-down)
    ;;("<up>" windresize-up)


    ;;("q" nil))

 (defhydra hydra-text-scale (:timeout 4)
 "scale text"
 ("t" text-scale-increase "in")
 ("s" text-scale-decrease "out")
 ("e" nil "finished" :exit t))
 (fset 'yes-or-no-p  'y-or-n-p)

(use-package undo-fu)

;; (use-package minions :ensure t
  ;;   :hook (doom-modeline-mode . minions-mode))

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
(setq doom-modeline-icon nil)

(use-package undo-tree :ensure t
    :init
    (global-undo-tree-mode 1))

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

(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (if (eq
     (if (numberp alpha)
	 alpha
       (cdr alpha)) ; may also be nil
     100)
    (set-frame-parameter nil 'alpha '(85 . 50))
      (set-frame-parameter nil 'alpha '(100 . 100)))))

(use-package org-bullets
  :ensure t)
(org-bullets-mode 1)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(general-define-key 
 :states '(normal visual emacs)
 :prefix ","

 "e" '(org-end-of-subtree :which-key "end-subtree")
 "h" '(outline-up-heading :which-key "prev-heading")

 "i" '(:ignore t :which-key "insert")
 "it" '(org-time-stamp :which-key "timestamp")
 "is" '(org-insert-heading-respect-content :which-key "heading")
 "il" '(org-insert-link :which-key "link")

 "o" '(:ignore t :which-key "org")
 "oc" '(org-toggle-checkbox :which-key "check")
 "oa" '(org-agenda :which-key "agenda")
 "os" '(org-schedule :which-key "schedule")
 )
(setq org-log-done nil)
(setq org-agenda-files '("~/tasks.org"))

(fset 'weekly-schedule
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([121 121 112 112 112 112 112 112 112 114 114 114 114 114 114 114 114 114 114 114 114 S-down S-down S-down S-down S-down S-down S-down S-down S-down S-down S-down S-down S-down S-down S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up S-up up S-up S-up S-up S-up S-up S-up up S-up S-up S-up S-up S-up up S-up S-up S-up S-up up S-up S-up S-up up S-up S-up up S-up 111 1 backspace backspace backspace backspace escape 1 105 42 42 42 32] 0 "%d")) arg)))


(fset 'archive-jour
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([1 134217848 111 114 103 32 100 101 109 111 116 101 32 115 117 98 116 114 101 101 return 115 tab 116] 0 "%d")) arg)))

(fset 'gotoday
   [?g ?g ?O escape ?, ?i ?t return ?d ?d ?/ ?\C-y escape])

(fset 'listecocher
   [?i ?- ?  ?  escape ?\C-q ?1 ?3 ?3 return ?i ?i backspace ?  ?  escape ?\C-q ?1 ?3 ?5 return ?o escape])

(fset 'flush-empty-lines
   [?\M-x ?f ?l ?u ?s ?h ?  ?l ?i ?n ?e ?s return ?^ ?$ return])
