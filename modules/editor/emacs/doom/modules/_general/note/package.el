;; -*- no-byte-compile: t; -*-

(package! org-appear)
(package! org-cliplink)
(package! org-ql)
(package! orgtbl-aggregate)
(package! page-break-lines)
(package! poporg)
(package! gnuplot)

(package! citar)
(package! all-the-icons)
(package! citar-org-roam)

(package! nursery
  :recipe (:host github :repo "chrisbarrett/nursery"
           :files ("lisp/*.el")))

(package! ox-gfm)

;; (when (modulep! +modern)
;;   (package! org-modern))
