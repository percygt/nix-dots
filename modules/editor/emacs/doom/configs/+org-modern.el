;;; +org-modern.el -*- lexical-binding: t; -*-

(add-hook! 'org-mode-hook #'org-modern-mode)
(after! org-modern
  (setq org-modern-todo-faces org-todo-keyword-faces)
  (setq org-modern-fold-stars (-iterate (pcase-lambda (pr)
                                          (let ((pad (make-string (length (car pr))
                                                                  32)))
                                            (cons (concat pad "▷")
                                                  (concat pad "▽"))))
                                        '("▶" . "▼")
                                        10))
  )
