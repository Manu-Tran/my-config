;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "bindings")
(setq auth-sources '("~/.authinfo.gpg"))

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Emmanuel Tran (Manu)"
      user-mail-address "emmanuel.tran@gmail.com")

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

;; (setq doom-font (font-spec :family "monospace" :size 12))
(setq doom-font (font-spec :family "JetBrains Mono" :size 11))
;; (setq doom-font (font-spec :family "Fira Code" :size 14))

(menu-bar-mode t)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq doom-modeline-window-width-limit fill-column)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type 'relative)
;; (setq display-line-numbers-type 'nil)
(setq display-line-numbers 'relative)
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-current-absolute t)

;; Completion Stuff =============================================================

;; Delay for completion
(setq company-idle-delay 0.5
      company-minimum-prefix-length 3)
;;
(setq lsp-java-format-settings-url "file://Users/emmanuel.tran/dd/eclipse-java-google-style-format.xml")
(setq lsp-java-format-settings-profile "GoogleStyle")
(setq lsp-ui-sideline-delay 0.7)
(setq lsp-ui-doc-delay 0.5)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-idle-delay 0.500)



;; Language of the grammar checking
(setq langtool-default-language "fr-FR")

;; Fill Column At 80th character
(require 'fill-column-indicator)

(setq fci-rule-width 3)
;; (setq fci-rule-color "darkblue")

(defun sanityinc/fci-enabled-p () (symbol-value 'fci-mode))

(defvar sanityinc/fci-mode-suppressed nil)
(make-variable-buffer-local 'sanityinc/fci-mode-suppressed)

(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible"
  (let ((fci-enabled (sanityinc/fci-enabled-p)))
    (when fci-enabled
      (setq sanityinc/fci-mode-suppressed fci-enabled)
      (turn-off-fci-mode))))

(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed"
  (when (and sanityinc/fci-mode-suppressed
             (null popup-instances))
    (setq sanityinc/fci-mode-suppressed nil)
    (turn-on-fci-mode)))


(add-hook! 'prog-mode 'fci-mode)
(add-hook! 'python-mode-local-vars-hook #'fci-mode)
(defun my-flycheck-python-setup ()
  (flycheck-add-next-checker 'lsp 'python-flake8))

;; These MODE-local-vars-hook hooks are a Doom thing. They're executed after
;; MODE-hook, on hack-local-variables-hook. Although `lsp!` is attached to
;; python-mode-local-vars-hook, it should occur earlier than my-flycheck-setup
;; this way:
;;
;; Hook Stuff ==================================================================
(add-hook 'lsp-after-initialize-hook (lambda
                                       ()
                                       (flycheck-add-next-checker 'lsp 'python-flake8)))
(add-hook 'python-mode-hook 'conda-env-autoactivate-mode)
;; (conda-env-activate 'base)


; (let ((langs '("american" "francais")))
;       (setq lang-ring (make-ring (length langs)))
;       (dolist (elem langs) (ring-insert lang-ring elem)))

; (defun cycle-ispell-languages ()
;   (interactive)
;   (let ((lang (ring-ref lang-ring -1)))
;     (ring-insert lang-ring lang)
;     (ispell-change-dictionary lang)))

;; (setq projectile-project-search-path '~/Programmation/)

;; Datadog Linting =============================================================

;; Remove trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Indent with spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; UTF-8 EVERYWHERE!!!
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Run Prettier on save
;; (add-hook 'before-save-hook 'prettier-before-save)

;; Configure Prettier to match the CLI settings
(setq prettier-js-args '(
  "--print-width" "80"
  "--tab-width" "4"
  "--single-quote" "true"
))

;; Key stuff ====================================================================

(setq which-key-idle-delay 0.4)

;; Mac Option Enabler
(setq ns-alternate-modifier 'none)
(setq mac-option-modifier 'none)

;; Calendar stuff ==============================================================

(load! "calendar.el")

;; Evil stuff ==================================================================
(require 'evil-replace-with-register)
(setq evil-replace-with-register-key (kbd "gr"))
(evil-replace-with-register-install)
(evil-ex-define-cmd "q[uit]" 'kill-current-buffer)
(evil-ex-define-cmd "wq" 'doom/save-and-kill-buffer)
;; (defun my-evil-quit (old-fun &rest args)
;;   (if (eq major-mode 'lisp-interaction-mode)
;;     (message "hi!")
;;     (apply old-fun args)))

;; (advice-add #'evil-quit :around #'my-evil-quit)

(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

(define-key evil-normal-state-map (kbd "gj") 'evil-next-line)
(define-key evil-normal-state-map (kbd "gk") 'evil-previous-line)

;; Org stuff ====================================================================

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Workflow configuration
(load! "orgconfig")

(require 'ob-ipython)

;;; display/update images in the buffer after I evaluate
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
(setq yas-snippet-dirs (append yas-snippet-dirs '("~/.doom.d/my-snippets")))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (julia . t)
   (python . t)
   (ipython . t)
   (jupyter . t)))
(setq ob-async-no-async-languages-alist '("ipython"))

(defvar hexcolour-keywords
   '(("#[abcdef[:digit:]]\\{6\\}"
      (0 (put-text-property (match-beginning 0)
                            (match-end 0)
                            'face (list :background
                                        (match-string-no-properties 0)))))))
(defun hexcolour-add-to-font-lock ()
  (font-lock-add-keywords nil hexcolour-keywords))

;; Select window between frames
(after! ace-window
  (setq aw-scope 'global))

;;;
;;; Keybinds

(use-package jupyter)
(use-package ob-async)
(use-package conda
  :init
  (setq conda-anaconda-home (expand-file-name "~/opt/miniconda3"))
  (setq conda-env-home-directory (expand-file-name "~/opt/miniconda3")))


(load! "~/Programmation/emacs-jupyter/jupyter-client.el")
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;; (use-package nlinum-relative
;;   :config
;;   (nlinum-relative-setup-evil)
;;   (add-hook 'prog-mode-hook 'nlinum-relative-mode)
;; )


; (use-package! org-dropbox
;   :init
;   :config
;   (setq org-dropbox-note-dir "~/org/sync")
;   (setq org-dropbox-datetree-file "~/org/sync/reference.org")
;   )

(server-force-delete)
(server-start)
