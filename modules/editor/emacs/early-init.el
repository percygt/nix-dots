
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
;; (add-to-list 'load-path (expand-file-name "var/packages/nursery-2024-09-07/lisp/" user-emacs-data-directory))

;; language stuff
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)

;; garbage collection
(setq read-process-output-max (* 64 1024)
      process-adaptive-read-buffering nil
      gc-cons-threshold most-positive-fixnum)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 32 1024 1024))))

;; Prevent the glimpse of un-styled Emacs by disabling these UI elements early.
(push '(ns-use-native-fullscreen . t) default-frame-alist)
(push '(ns-transparent-titlebar . t) default-frame-alist)
(push '(ns-appearance . dark) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(mode-line-format . 0) default-frame-alist)
(push '(fullscreen . maximized) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(alpha-background . 80) default-frame-alist)

(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t
      frame-title-format nil
      truncate-lines nil
      truncate-partial-width-windows t
      indicate-buffer-boundaries '((bottom . right))
      inhibit-splash-screen t
      inhibit-startup-buffer-menu t
      inhibit-startup-message t
      inhibit-startup-screen t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil
      load-prefer-newer noninteractive
      auto-mode-case-fold nil
      bidi-inhibit-bpa t
      site-run-file nil)

;; In Emacs 27+, package initialization occurs before `user-init-file' is
;; loaded, but after `early-init-file'. We want to keep from loading at startup.
(setq package-enable-at-startup nil
      package-quickstart nil)

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (convert-standard-filename
    (expand-file-name  "var/eln-cache/" user-emacs-data-directory))))

(advice-add #'x-apply-session-resources :override #'ignore)

(provide 'early-init)
;;; early-init ends here
