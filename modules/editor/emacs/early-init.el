;;; early-init.el --- early in the morning -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(defvar user-emacs-config-directory
  (concat (getenv "XDG_CONFIG_HOME") "/emacs")
  "Emacs config directory.")

(defvar user-emacs-data-directory
  (concat (getenv "XDG_DATA_HOME") "/emacs")
  "Emacs local home directory.")

(defvar user-emacs-cache-directory
  (concat (getenv "XDG_CACHE_HOME") "/emacs")
  "Home directory.")

(defvar notes-directory
  (concat (getenv "HOME") "/data/notes")
  "My notes.")


(add-to-list 'load-path (expand-file-name "config/" user-emacs-config-directory))
(add-to-list 'load-path (expand-file-name "var/packages/nursery-2024-09-07/lisp/" user-emacs-data-directory))

;; from doom early-init
(setq gc-cons-threshold most-positive-fixnum)
(setq load-prefer-newer noninteractive)
(when (getenv-internal "DEBUG")
  (setq init-file-debug t
        debug-on-error t))

;; In Emacs 27+, package initialization occurs before `user-init-file' is
;; loaded, but after `early-init-file'. We want to keep from loading at startup.
(setq package-enable-at-startup nil)

;; Set some variables.
(setq
 initial-scratch-message nil
 inhibit-startup-screen t ;; Don't show the welcome splash screen.
 ;; package-native-compile t ;; native compile packages
 idle-update-delay 1.0
 comp-deferred-compilation nil
 native-comp-async-report-warnings-errors nil ; Stop showing compilation warnings on startup
 ;; pop-up-windows nil
 highlight-nonselected-windows nil
 inhibit-compacting-font-caches t
 )

;; Disabling bidi (bidirectional editing stuff)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)  ; emacs 27 only - disables bidirectional parenthesis

(setq-default cursor-in-non-selected-windows nil)

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
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)
(when (featurep 'ns)
  (push '(ns-transparent-titlebar . t) default-frame-alist))
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

(setq frame-resize-pixelwise           t  ; fine resize
      frame-inhibit-implied-resize     t)

(advice-add #'x-apply-session-resources :override #'ignore)

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-data-directory))))

(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))
(add-hook 'window-setup-hook 'on-after-init)
(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))

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

(unless (or (daemonp) noninteractive)
  ;; Emacs really shouldn't be displaying anything until it has fully started
  ;; up. This saves a bit of time.
  (setq-default inhibit-redisplay t
                inhibit-message t)
  (add-hook 'window-setup-hook
            (lambda ()
              (setq-default inhibit-redisplay nil
                            inhibit-message nil)
              (redisplay)))

  ;; Site files tend to use `load-file', which emits "Loading X..." messages in
  ;; the echo area, which in turn triggers a redisplay. Redisplays can have a
  ;; substantial effect on startup times and in this case happens so early that
  ;; Emacs may flash white while starting up.
  (define-advice load-file (:override (file) silence)
    (load file nil 'nomessage))

  ;; Undo our `load-file' advice above, to limit the scope of any edge cases it
  ;; may introduce down the road.
  (define-advice startup--load-user-init-file (:before (&rest _) init-emacs)
    (advice-remove #'load-file #'load-file@silence)))

(provide 'early-init)
;;; early-init ends here
