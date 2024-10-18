;;; +org-modern.el -*- lexical-binding: t; -*-
(with-eval-after-load 'org (global-org-modern-mode))
(after! org-modern
  (setq org-auto-align-tags nil)
  (setq org-tags-column nil)
  (setq org-agenda-tags-column 0)
  (setq org-modern-todo-faces '(("WAIT" warning :bold t :inverse-video t)))
  (setq org-modern-fold-stars (-iterate (pcase-lambda (pr)
                                          (let ((pad (make-string (length (car pr))
                                                                  32)))
                                            (cons (concat pad "▷")
                                                  (concat pad "▽"))))
                                        '("▶" . "▼")
                                        10))
  (setq org-modern-list nil))
