;;; +org-roam-nursery.el -*- lexical-binding: t; -*-

(after! org-roam
  (set-popup-rule! "^\\*org-roam-review\\*" :slot 2 :side 'bottom :size 40 :modeline nil :select t :quit t))

(after! org-roam
  (require 'org-roam-review)
  (require 'org-roam-dblocks)
  )

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
  (unless (not (derived-mode-p 'org-capture-mode))
    (add-hook! 'org-mode-hook #'org-roam-dblocks-autoupdate-mode)))

;; (use-package org-format
;;   :ensure nil
;;   :custom
;;   (org-format-blank-lines-before-subheadings 0)
;;   :hook (org-mode . org-format-on-save-mode))

(use-package! org-roam-search
  :commands (org-roam-search))

;; (use-package org-roam-links
;;   :config
;;   (add-to-list 'display-buffer-alist
;;                '("\\*org-roam-links\\*"
;;                  (display-buffer-full-frame)))
;;   :general
;;   (global-definer
;;    :keymaps '(org-mode-map)
;;    "wl" 'org-roam-links)
;;   :commands (org-roam-links))


;; (use-package org-roam-rewrite
;;   :commands (org-roam-rewrite-rename
;;              org-roam-rewrite-remove
;;              org-roam-rewrite-inline
;;              org-roam-rewrite-extract))

;; (use-package org-capture-detect
;;   :ensure nil
;;   :after org-roam)

;; (use-package org-roam-links
;;   :ensure nil
;;   :after org-roam
;;   :demand t)

;; (use-package org-roam-lazy-previews
;;   :ensure nil
;;   :after org-roam
;;   :demand t)

;; (use-package org-roam-slipbox
;;   :ensure nil
;;   :after org-roam
;;   :demand t
;;   :config
;;   (org-roam-slipbox-buffer-identification-mode +1)
;;   (org-roam-slipbox-tag-mode +1))
