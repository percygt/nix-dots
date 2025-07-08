;;; +spell.el -*- lexical-binding: t; -*-
(after! spell-fu
  ;; TODO workround for https://github.com/doomemacs/doomemacs/issues/6246
  (unless (file-exists-p ispell-personal-dictionary)
    (make-directory (file-name-directory ispell-personal-dictionary) t)
    (with-temp-file ispell-personal-dictionary
      (insert (format "personal_ws-1.1 %s 0\n" ispell-dictionary)))))
