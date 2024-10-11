;;; general-cfg.el ---  General.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package general
  :demand t
  :preface
  (defun switch-to-recent-buffer ()
    (interactive)
    (switch-to-buffer (other-buffer (current-buffer))))
  (defun kill-this-buffer ()  ; for the menu bar
    "Kill the current buffer.
When called in the minibuffer, get out of the minibuffer
using `abort-recursive-edit'."
    (interactive)
    (cond
     ;; Don't do anything when `menu-frame' is not alive or visible
     ;; (Bug#8184).
     ((not (menu-bar-menu-frame-live-and-visible-p)))
     ((menu-bar-non-minibuffer-window-p)
      (kill-buffer (current-buffer)))
     (t
      (abort-recursive-edit))))
  :config
  (general-override-mode)
  (general-auto-unbind-keys)
  (general-create-definer global-definer
    :keymaps 'override
    :states '(insert normal hybrid motion visual operator emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (general-create-definer local-definer
    :keymaps 'override
    :states '(insert normal hybrid motion visual operator emacs)
    :prefix ","
    :global-prefix "C-,")
  (general-create-definer normal-definer
    :keymaps 'override
    :states '(normal))

  (normal-definer
    "D" 'kill-this-buffer)
  (global-definer
    "!" 'shell-command
    ":" 'eval-expression
    "l" 'load-file
    "." 'switch-to-recent-buffer
    "u"  '(nil :wk "Utils")
    "u." 'repeat
    )

  (general-create-definer global-leader
    :keymaps 'override
    :states '(insert normal hybrid motion visual operator)
    :prefix "SPC m"
    :non-normal-prefix "C-SPC m"
    "" '( :ignore t
  	      :which-key
  	      (lambda (arg)
  	        (cons (cadr (split-string (car arg) " "))
  		          (replace-regexp-in-string "-mode$" "" (symbol-name major-mode))))))
  )

(provide 'general-cfg)
;;; general-cfg.el ends here
