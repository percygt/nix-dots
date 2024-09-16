;;; nursery-cfg.el --- Nursery Config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package org-roam-review
  :ensure nil
  :config
  (add-to-list 'display-buffer-alist
               '("\\*org-roam-review\\*"
                 (display-buffer-full-frame)))
  :commands (org-roam-review
	         org-roam-review-list-by-maturity
	         org-roam-review-list-recently-added)
  ;; Optional - tag all newly-created notes as seedlings.
  :hook (org-roam-capture-new-node . org-roam-review-set-seedling)
  ;; Optional - keybindings for applying Evergreen note properties.
  :general
  (global-definer
    "r"  '(org-roam-review :wk "Review"))
  (global-definer
    :keymaps 'org-mode-map
    "e"  '(nil :wk "Evergreen")
    "ea" '(org-roam-review-accept :wk "accept")
    "ed" '(org-roam-review-bury :wk "bury")
    "ex" '(org-roam-review-set-excluded :wk "set excluded")
    "eb" '(org-roam-review-set-budding :wk "set budding")
    "es" '(org-roam-review-set-seedling :wk "set seedling")
    "ee" '(org-roam-review-set-evergreen :wk "set evergreen"))
  ;; ;; Optional - bindings for evil-mode compatability.
  :general
  (:states '(normal) :keymaps 'org-roam-review-mode-map
	       "TAB" 'magit-section-cycle
	       "g r" 'org-roam-review-refresh)
  )
(use-package org-format
  :ensure nil
  :hook (org-mode . org-format-on-save-mode))

(use-package org-roam-search
  :ensure nil
  :commands (org-roam-search))

(use-package org-roam-links
  :ensure nil
  :config
  (add-to-list 'display-buffer-alist
               '("\\*org-roam-links\\*"
                 (display-buffer-full-frame)))
  :general
  (global-definer
    :keymaps '(org-mode-map)
    "wl" 'org-roam-links)
  :commands (org-roam-links))

(use-package org-roam-dblocks
  :ensure nil
  :hook (org-mode . org-roam-dblocks-autoupdate-mode))

(use-package org-roam-rewrite
  :ensure nil
  :commands (org-roam-rewrite-rename
             org-roam-rewrite-remove
             org-roam-rewrite-inline
             org-roam-rewrite-extract))

(use-package org-capture-detect
  :ensure nil
  :after org-roam)

(use-package org-roam-links
  :ensure nil
  :after org-roam
  :demand t)

(use-package org-roam-lazy-previews
  :ensure nil
  :after org-roam
  :demand t)

(use-package org-roam-slipbox
  :ensure nil
  :after org-roam
  :demand t
  :config
  (org-roam-slipbox-buffer-identification-mode +1)
  (org-roam-slipbox-tag-mode +1))

(provide 'nursery-cfg)
;;; nursery-cfg.el ends here
