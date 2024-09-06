;;; cmp-cfg.el --- Org Mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package corfu
  :custom
  (corfu-cycle t)                 ; Allows cycling through candidates
  (corfu-auto t)                  ; Enable auto completion
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.1)
  (corfu-popupinfo-delay '(0.5 . 0.2))
  (corfu-preview-current 'insert) ; insert previewed candidate
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)      ; Don't auto expand tempel snippets
  ;; Optionally use TAB for cycling, default is `corfu-complete'.
  :bind (:map corfu-map
              ("M-SPC"      . corfu-insert-separator)
              ("TAB"        . corfu-next)
              ([tab]        . corfu-next)
              ("S-TAB"      . corfu-previous)
              ([backtab]    . corfu-previous)
              ("S-<return>" . corfu-insert)
              ("RET"        . nil))

  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode) ; Popup completion info
  :hook
  (eshell-mode . (lambda ()
                   (setq-local corfu-quit-at-boundary t
                               corfu-quit-no-match t
                               corfu-auto nil)
                   (corfu-mode))))

(use-package cape
  :after corfu
  :bind (("C-c p p" . completion-at-point)
         ("C-c p t" . complete-tag)
         ("C-c p d" . cape-dabbrev)
         ("C-c p f" . cape-file)
         ("C-c p s" . cape-elisp-symbol)
         ("C-c p e" . cape-elisp-block)
         ("C-c p a" . cape-abbrev)
         ("C-c p l" . cape-line)
         ("C-c p w" . cape-dict))
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  (when (eq system-type 'windows-nt)
    (plist-put kind-icon-default-style :height 0.8))
  (when (eq system-type 'gnu/linux)
    (plist-put kind-icon-default-style :height 0.7))
  (when (fboundp 'reapply-themes)
    (advice-add 'reapply-themes :after 'kind-icon-reset-cache)))

(use-package yasnippet
  :diminish yas-minor-mode
  :custom (yas-keymap-disable-hook
           (lambda () (and (frame-live-p corfu--frame)
                           (frame-visible-p corfu--frame))))
  :hook (after-init . yas-global-mode))
(use-package yasnippet-snippets :after yasnippet)
(use-package consult-yasnippet
  :bind ("M-*" . consult-yasnippet)
  :config
  (with-eval-after-load 'embark
    (defvar-keymap embark-yasnippet-completion-actions
      :doc "Keymap for actions for yasnippets."
      :parent embark-general-map
      "v" #'consult-yasnippet-visit-snippet-file)
    (push '(yasnippet . embark-yasnippet-completion-actions)
          embark-keymap-alist)))

(use-package which-key
  :init
  (which-key-mode)
  (which-key-setup-minibuffer)
  (which-key-define-key-recursively global-map [escape] 'ignore)
  :config
  (setq which-key-idle-delay 0.3)
  (setq which-key-prefix-prefix "◉ ")
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-min-display-lines 3
        which-key-max-display-columns nil))


(use-package nerd-icons-ibuffer
  :after (nerd-icons ibuffer)
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(provide 'cmp-cfg)
;;; cmp-cfg.el ends here
