;;; early-init.el --- early in the morning -*- lexical-binding: t; -*-

;;; Commentary:
;; Provides early initialization for Emacs 27.1+ Do not initialize the
;; package manager.  This is done in `init.el'.  The optimization of
;; the early init comes from both Doom Emacs' config as well as Prot's
;; config.
;; See https://github.com/hlissner/doom-emacs/blob/develop/early-init.el
;; See https://protesilaos.com/dotemacs/

;;; Code:
(defvar user-emacs-data-directory
  (concat (getenv "XDG_DATA_HOME") "/emacs"))

;; Defer garbage collection further back in the startup process
(setq gc-cons-threshold most-positive-fixnum)

;; [From DOOM] PERF: Don't use precious startup time checking mtime on elisp bytecode.
;;   Ensuring correctness is 'doom sync's job, not the interactive session's.
;;   Still, stale byte-code will cause *heavy* losses in startup efficiency.
(setq load-prefer-newer noninteractive)

;; In Emacs 27+, package initialization occurs before `user-init-file' is
;; loaded, but after `early-init-file'. We want to keep from loading at startup.
(setq package-enable-at-startup nil)

;; Set some variables.
(setq tab-width 4 ;; Set tab-size to 4 spaces
      initial-scratch-message nil
      inhibit-startup-screen t ;; Don't show the welcome splash screen.
      indent-tabs-mode nil ;; Always indent with spaces
      package-native-compile t ;; native compile packages
      native-comp-async-report-warnings-errors nil 	; Stop showing compilation warnings on startup
      native-comp-jit-compilation nil)

;; Prevent the glimpse of un-styled Emacs by disabling these UI elements early.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(mode-line-format . 0) default-frame-alist)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)              ; give some breathing room
(global-hl-line-mode 1)           ; Highlight the current line to make it more visible
(global-subword-mode 1)

(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist))

(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))
;; Create a package-quickstart.el
(setq package-quickstart t)

;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we easily halve startup times with fonts that are
;; larger than the system default.
(setq frame-resize-pixelwise           t  ; fine resize
      frame-inhibit-implied-resize     t)

;; Ignore X resources; its settings would be redundant with the other settings
;; in this file and can conflict with later config (particularly where the
;; cursor color is concerned).
(advice-add #'x-apply-session-resources :override #'ignore)


;;;
;;; Put all backup files in a single place
;;;
;; (let ((backup-dir (concat user-emacs-data-directory "/backup")))
;;   (unless (file-directory-p backup-dir)
;;     (mkdir backup-dir t))
;;   (setq backup-directory-alist (cons (cons "." backup-dir) nil)))

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-data-directory))))

;;;
;;; Background opacity Set
;;;
(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))
(add-hook 'window-setup-hook 'on-after-init)
(set-frame-parameter nil 'alpha-background 70)
(add-to-list 'default-frame-alist '(alpha-background . 70))

;; Makes *scratch* empty.
(setq initial-scratch-message "")

;; Removes *scratch* from buffer after the mode has been set.
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;; Removes *messages* from the buffer.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

(provide 'early-init)
;;; early-init ends here
