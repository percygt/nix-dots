;;; +org-roam-nursery.el -*- lexical-binding: t; -*-
(after! org-roam
  (require 'org-roam-review)
  (require 'org-roam-dblocks))

(after! org-roam
  (add-to-list 'display-buffer-alist
               '("\\*org-roam-review\\*"
                 (display-buffer-full-frame)
                 (display-buffer-reuse-window))))

(map! :after org-roam
      :map org-roam-review-mode-map
      :n "/" #'org-roam-review-modify-tags
      :n "TAB" #'magit-section-cycle
      :n "g r" #'org-roam-review-refresh)

(map! :after org-roam
      :map org-roam-review-mode-map
      :leader
      :prefix ("e" . "Evergreen")
      :n [remap evil-next-line] #'evil-next-visual-line
      :n [remap evil-previous-line] #'evil-previous-visual-line)

(map! :after org-roam
      :map (org-roam-review-mode-map org-mode-map)
      :leader
      :prefix ("e" . "Evergreen")
      :n :desc "Accept" "r" #'org-roam-review-accept
      :n :desc "Forgot" "f" #'org-roam-review-forgot
      :n :desc "Bury" "u" #'org-roam-review-bury
      :n :desc "Set excluded" "x" #'org-roam-review-set-excluded
      :n :desc "Set memorise" "m" #'org-roam-review-set-memorise
      :n :desc "Set budding" "b" #'org-roam-review-set-budding
      :n :desc "Set seedling" "s" #'org-roam-review-set-seedling
      :n :desc "Set evergreen" "e" #'org-roam-review-set-evergreen)

(after! org-roam
  (setq org-roam-dblocks-auto-refresh-tags `("MOC"))
  (add-hook! 'org-mode-hook #'org-roam-dblocks-autoupdate-mode)
  (add-hook! 'org-roam-capture-new-node-hook #'org-roam-review-set-seedling))

(use-package! org-roam-slipbox
  :after org-roam
  :demand t
  :config
  (org-roam-slipbox-buffer-identification-mode +1)
  (org-roam-slipbox-tag-mode +1))

(use-package! org-roam-search
  :commands (org-roam-search))

;; (use-package org-format
;;   :ensure nil
;;   :custom
;;   (org-format-blank-lines-before-subheadings 0)
;;   :hook (org-mode . org-format-on-save-mode))

(use-package org-roam-links
  :config
  (add-to-list 'display-buffer-alist
               '("\\*org-roam-links\\*"
                 (display-buffer-full-frame)))
  :commands (org-roam-links))


;; (use-package org-roam-rewrite
;;   :commands (org-roam-rewrite-rename
;;              org-roam-rewrite-remove
;;              org-roam-rewrite-inline
;;              org-roam-rewrite-extract))

;; (use-package org-capture-detect
;;   :ensure nil
;;   :after org-roam)


(use-package org-roam-lazy-previews
  :after org-roam
  :demand t)

(use-package org-roam-slipbox
  :after org-roam
  :demand t
  :config
  (org-roam-slipbox-buffer-identification-mode +1)
  (org-roam-slipbox-tag-mode +1))
