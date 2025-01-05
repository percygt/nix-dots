;;; clipboard.el ---                                 -*- lexical-binding: t; -*-
(setq select-enable-clipboard nil)

(defadvice! +aiz-force-enable-clipboard (orig-fun &rest args)
  "enables clipboard sync for commands that benefit from it.
E.g. for commands that copy particularly useful text."
  :around '(+default/yank-buffer-path
            +default/yank-buffer-contents
            +default/yank-buffer-path-relative-to-project
            browse-at-remote-kill
            evil-collection-magit-yank-whole-line
            magit-copy-buffer-revision
            magit-copy-section-value
            emacs-everywhere-initialise
            emacs-everywhere-finish)
  (let ((select-enable-clipboard t))
    (apply orig-fun args)))

(evil-define-operator +aiz-evil-yank-to-system (beg end type register yank-handler)
  "Save the characters in motion into the kill-ring."
  :move-point nil
  :repeat nil
  (interactive "<R><x><y>")
  (let ((select-enable-clipboard t))
    (evil-yank beg end type register yank-handler)))

(evil-define-operator +aiz-evil-yank-line-to-system (beg end type register)
  "Save whole lines into the kill-ring."
  :motion evil-line-or-visual-line
  :move-point nil
  (interactive "<R><x>")
  (let ((select-enable-clipboard t))
    (evil-yank-line beg end type register)))

(define-key evil-normal-state-map "y" '+aiz-evil-yank-to-system)
(define-key evil-normal-state-map "Y" '+aiz-evil-yank-line-to-system)
(define-key evil-motion-state-map "y" '+aiz-evil-yank-to-system)
(define-key evil-motion-state-map "Y" '+aiz-evil-yank-line-to-system)
(global-set-key (kbd "s-c") '+aiz-evil-yank-to-system)

(defun +aiz-paste ()
  "paste from the system clipboard"
  (interactive)
  (let ((select-enable-clipboard t))
    (yank)))
(global-set-key [remap yank] 'jds-paste)
