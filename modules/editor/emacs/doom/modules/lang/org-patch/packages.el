;;; lang/org-patch/packages.el -*- no-byte-compile: t; -*-
(package! org :built-in t)
(package! doct
  :recipe (:host github :repo "progfolio/doct")
  :pin "5cab660dab653ad88c07b0493360252f6ed1d898")
(package! org-protocol-capture-html
  :recipe (:host github :repo "alphapapa/org-protocol-capture-html"))
(package! org-modern)
(package! org-ql)
(package! org-project-capture)
(package! org-projectile)
(package! writeroom-mode)
(package! org-super-agenda)
