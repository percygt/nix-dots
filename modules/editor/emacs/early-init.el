;;; early-init.el --- early in the morning -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(add-to-list 'load-path (concat (getenv "XDG_CONFIG_HOME") "/emacs/config/"))
;; Language stuff
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8-unix)

;; Garbage collection
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
      bidi-inhibit-bpa t)

;; In Emacs 27+, package initialization occurs before `user-init-file' is
;; loaded, but after `early-init-file'. We want to keep from loading at startup.
(setq package-enable-at-startup nil)

(when (and (fboundp 'startup-redirect-eln-cache)
           (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (startup-redirect-eln-cache
   (convert-standard-filename
    (concat (getenv "XDG_CACHE_HOME") "/emacs/eln-cache/"))))

(advice-add #'x-apply-session-resources :override #'ignore)

(provide 'early-init)
;;; early-init.el ends here
