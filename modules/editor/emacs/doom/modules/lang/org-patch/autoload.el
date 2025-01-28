;;; lang/org-patch/autoload.el -*- lexical-binding: t; -*-
;; (defun +org-capture/replace-brackets (link)
;;   (mapconcat
;;    (lambda (c)
;;      (pcase (key-description (vector c))
;;        ("[" "(")
;;        ("]" ")")
;;        (_ (key-description (vector c)))))
;;    link))

(defun +org-capture/created-property ()
  (org-set-property "CREATED" (format-time-string (org-time-stamp-format :long :inactive)))
  (insert " ")
  (insert " ")
  (backward-char)
  )

(defun +org-capture/ensure-heading (args &optional initial-level)
  (if (not args)
      (widen)
    (let* (
           (initial-level (or initial-level 1))
           (headings (if (= initial-level 1) (cdr args) args))
           )
      (if (and (re-search-forward (format org-complex-heading-regexp-format
                                          (regexp-quote (car headings)))
                                  nil t)
               (= (org-current-level) initial-level))
          (progn
            (beginning-of-line)
            (org-narrow-to-subtree))
        (goto-char (point-max))
        (unless (and (bolp) (eolp)) (insert "\n"))
        (insert (make-string initial-level ?*)
                " " (car headings) "\n")
        (when (= initial-level 1)
          (org-set-property "CATEGORY" (car args)))
        (beginning-of-line 0))

      (+org-capture/ensure-heading (cdr headings) (1+ initial-level))
      )))

(defun +org-capture/open-project (project-root)
  (if (require 'projectile nil 'noerror)
      (projectile-switch-project-by-name project-root)
    (project-switch-project project-root)
    )
  )
(defun +org-capture/project-file ()
  (let* (
         (doct (org-capture-get :doct))
         (file (expand-file-name +org-capture-projects-file org-directory))
         (project-root
          (projectile-completing-read "Project: " (projectile-relevant-known-projects))
          )
         (project-name
          (file-name-nondirectory (directory-file-name project-root))
          )
         (project-link (org-link-make-string
                        (format "elisp:(+org-capture/open-project \"%s\")" project-root)
                        project-name))
         )
    (set-buffer (org-capture-target-buffer file))
    (org-capture-put-target-region-and-position)
    (widen)
    (goto-char (point-min))
    ;; Find or create the project headling
    (+org-capture/ensure-heading
     (append (org-capture-get :parents)
             (list project-name project-link
                   (if doct
                       (let ((heading (plist-get doct :heading))) heading)
                     (org-capture-get :heading)
                     )
                   )))
    ))

(defun +org-capture/project-projectile()
  (progn
    (require 'org-project-capture)
    (let* ((category
            (org-projectile-completing-read
             "Select which project:"))
           (category-location
            (apply 'occ-get-category-heading-location '(category)))
           )
      (if category-location
          (progn
            (goto-char category-location)
            )
        (occ-insert-at-end-of-file)
        (org-set-property "CATEGORY" category)
        (insert (org-project-capture-build-heading category))
        )))
  )
(defun +org-capture/www-get-page-title (url)
  (let ((title))
    (with-current-buffer (url-retrieve-synchronously url)
      (goto-char (point-min))
      (re-search-forward "<title>\\([^<]*\\)</title>" nil t 1)
      (setq title (match-string 1))
      (goto-char (point-min))
      (re-search-forward "charset=\\([-0-9a-zA-Z]*\\)" nil t 1)
      (decode-coding-string title (intern (match-string 1))))))

  ;;; from: https://abelstern.nl/posts/emacs-quick-capture/
(defun +org-capture/quick-capture ()
  (defun +org-capture/place-template-dont-delete-windows (oldfun args)
    (cl-letf (((symbol-function 'org-switch-to-buffer-other-window) 'switch-to-buffer))
      (apply oldfun args)))
  (defun +org-capture/delete-frame-after-capture ()
    (delete-frame)
    (remove-hook 'org-capture-after-finalize-hook '+org-capture/delete-frame-after-capture)
    )
  (set-frame-name "emacs org capture")
  (add-hook 'org-capture-after-finalize-hook '+org-capture/delete-frame-after-capture)
  (+org-capture/place-template-dont-delete-windows 'org-capture nil))
