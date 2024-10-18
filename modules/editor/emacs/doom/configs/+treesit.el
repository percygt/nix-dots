;;; +treesit.el -*- lexical-binding: t; -*-

(require 'map)
(require 'pcase)

;;; Tree-sitter
;; Remap major modes to use treesit modes, including in org-mode.

(setq treesit-font-lock-level 4)
(defconst +treesit-mode-remaps
  '((:orig-mode c-mode :treesit-mode c-ts-mode :org-src ("C"))
    (:orig-mode c++-mode :treesit-mode c++-ts-mode :org-src ("cpp" "c++"))
    (:orig-mode c-or-c++-mode :treesit-mode c-or-c++-ts-mode)
    (:orig-mode cmake :treesit-mode cmake-ts-mode :org-src ("cmake"))
    (:orig-mode conf-toml-mode :treesit-mode toml-ts-mode :org-src ("conf-toml" "toml"))
    (:orig-mode toml-mode :treesit-mode toml-ts-mode :org-src ("toml"))
    (:orig-mode nix-mode :treesit-mode nix-ts-mode :org-src ("nix"))
    (:orig-mode lua-mode :treesit-mode lua-ts-mode :org-src ("lua"))
    (:orig-mode css-mode :treesit-mode css-ts-mode :org-src ("css"))
    (:orig-mode go-mode :treesit-mode go-ts-mode :org-src ("go"))
    (:orig-mode csharp-mode :treesit-mode csharp-ts-mode :org-src ("csharp"))
    (:orig-mode dockerfile-mode :treesit-mode dockerfile-ts-mode :org-src ("dockerfile"))
    (:orig-mode java-mode :treesit-mode java-ts-mode :org-src ("java"))
    (:orig-mode js-mode :treesit-mode js-ts-mode :org-src "js")
    (:orig-mode json-mode :treesit-mode json-ts-mode :org-src "json")
    (:orig-mode python-mode :treesit-mode python-ts-mode :org-src ("python" "py"))
    (:orig-mode rust-mode :treesit-mode rust-ts-mode :org-src ("rust"))
    (:orig-mode sh-mode :treesit-mode bash-ts-mode)
    (:orig-mode typescript-mode :treesit-mode typescript-ts-mode :org-src ("ts" "typescript"))
    (:orig-mode yaml-mode :treesit-mode yaml-ts-mode :org-src ("yml" "yaml"))))

(mapc (pcase-lambda ((map :orig-mode :treesit-mode :org-src))
        ;; (set-keymap-parent (concat (format "%s" treesit-mode) "-map") (concat (format "%s" orig-mode) "-map"))
        (after! files
          (add-to-list 'major-mode-remap-alist (cons orig-mode treesit-mode)))
        (after! org-src
          (dolist (src-type (-list org-src))
            (let ((treesit-sans-suffix (intern (string-remove-suffix "-mode" (format "%s" treesit-mode)))))
              (setf (alist-get src-type org-src-lang-modes) treesit-sans-suffix)))))
      +treesit-mode-remaps)

;; `bash-ts-mode' falls back to sh-mode, so we don't want to use
;; major-mode-remap-alist to set it.

(setq auto-mode-alist
      (seq-map (pcase-lambda (`(,pat . ,mode))
                 (cons pat (if (equal mode 'sh-mode)
                               'bash-ts-mode
                             mode)))
               auto-mode-alist))

(add-to-list 'auto-mode-alist '("CMakeLists\\'" . cmake-ts-mode))
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("/go\\.mod\\'" . go-mod-ts-mode))
(add-to-list 'auto-mode-alist '("\\.y[a]?ml\\'" . yaml-ts-mode))

