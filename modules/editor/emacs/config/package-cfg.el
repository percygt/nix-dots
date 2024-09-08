;;; package-cfg.el --- Package Config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(use-package use-package
  :custom
  (use-package-verbose t)
  (use-package-minimum-reported-time 0.001)

  :config
  (add-to-list 'use-package-keywords :evil-bind t)

  (defun use-package-normalize/:evil-bind (name keyword args)
    "Custom use-keyword :evil-bind. I use this to provide something similar to ':bind',
but with additional two features that I miss from the default implementation:

1. Integration with 'evil-define-key', so I can extend the keymap declaration
   to specify one or more evil states that the binding should apply to.

2. The ability to detect keymaps that aren't defined as prefix commands. This
   allows me to define a binding to a keymap variable, eg. maybe I want '<leader>h'
   to trigger 'help-map'. This fails using the default ':bind', meaning that I
   have to fall back to calling 'bind-key' manually if I want to assign a
   prefix.

The expected form is slightly different to 'bind':

((:map (KEYMAP . STATE) (KEY . FUNC) (KEY . FUNC) ...)
 (:map (KEYMAP . STATE) (KEY . FUNC) (KEY . FUNC) ...) ...)

STATE is the evil state. It can be nil or omitted entirely. If given, it should be an
argument suitable for passing to 'evil-define-key' -- meaning a symbol like 'normal', or
a list like '(normal insert)'."
    (setq args (car args))
    (unless (listp args)
      (use-package-error ":evil-bind expects ((:map (MAP . STATE) (KEY . FUNC) ..) ..)"))
    (dolist (def args args)
      (unless (and (eq (car def) :map)
                   (consp (cdr def))
                   (listp (cddr def)))
        (use-package-error ":evil-bind expects ((:map (MAP . STATE) (KEY . FUNC) ..) ..)"))))

  (defun use-package-handler/:evil-bind (name _keyword args rest state)
    "Handler for ':evil-bind' use-package extension. See 'use-package-normalize/:evil-bind' for full docs."
    (let ((body (use-package-process-keywords name rest
                  (use-package-plist-delete state :evil-bind))))
      (use-package-concat
       `((with-eval-after-load ',name
           ,@(mapcan
              (lambda (entry)
                (let ((keymap (car (cadr entry)))
                      (state (cdr (cadr entry)))
                      (bindings (cddr entry)))
                  (mapcar
                   (lambda (binding)
                     (let ((key (car binding))
                           (val (if (and (boundp (cdr binding)) (keymapp (symbol-value (cdr binding))))
                                    ;; Keymaps need to be vars without quotes
                                    (cdr binding)
                                  ;; But functions need to be quoted symbols
                                  `(quote ,(cdr binding)))))
                       ;; When state is provided, use evil-define-key. Otherwise fall back to bind-key.
                       (if state
                           `(evil-define-key ',state ,keymap (kbd ,key) ,val)
                         `(bind-key ,key ,val ,keymap))))
                   bindings)))
              args)))
       body))))
(provide 'package-cfg)
;;; package-cfg.el ends here