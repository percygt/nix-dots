;;; +org-roam-capture.el -*- lexical-binding: t; -*-
(require 'doct)
(after! org-roam
  (defun doct-org-roam-convert (groups)
    "Convert GROUPS of templates to `org-roam' compatible templates."
    (setq doct-templates
          (mapcar (lambda (template)
                    (if-let* ((props (nthcdr (if (= (length template) 4) 2 5) template))
                              (org-roam-props (plist-get (plist-get props :doct) :org-roam)))
                        `(,@template ,@org-roam-props)
                      template))
                  (doct-flatten-lists-in groups))))

  (defun doct-org-roam--target-file (value)
    "Convert declaration's :file VALUE and extensions to capture template syntax."
    (let (type target)
      ;; TODO: This doesn't catch :olp used together with :datetree
      (when-let ((olp (doct--get :olp)))
        (push :olp type)
        (push olp target))
      (if-let ((head (doct--get :head)))
          (progn
            (push :head type)
            (push (pcase head
                    ((pred stringp) (if (doct--expansion-syntax-p head)
                                        (doct--replace-template-strings
                                         head)
                                      head))
                    ((pred functionp) (doct--fill-template (funcall head)))
                    ((pred doct--list-of-strings-p)
                     (mapconcat (lambda (element)
                                  (if (doct--expansion-syntax-p element)
                                      (doct--fill-template element)
                                    element))
                                head "\n")))
                  target))
        (when-let ((datetree (doct--get :datetree)))
          (push :datetree type)
          (push datetree target)))
      (push :file type)
      (push (doct--type-check :file value '(stringp doct--variable-p)) target)
      `(,(intern (mapconcat (lambda (keyword)
                              (substring (symbol-name keyword) 1))
                            (delq nil type) "+"))
        ,@(delq nil target))))

  (defun doct-org-roam--target ()
    "Convert declaration's target to template target."
    (let ((doct-exclusive-target-keywords '(:file :node)))
      (pcase (doct--first-in doct-exclusive-target-keywords)
        ('nil (signal 'doct-no-target `(,doct-exclusive-target-keywords nil ,doct--current)))
        (`(:id ,id) `(id ,(doct--type-check :id id '(stringp))))
        (`(:file ,file) (doct-org-roam--target-file file)))))

  (defun doct-org-roam--compose-entry (keys name parent)
    "Return a template suitable for `org-roam-capture-templates'.
  The list is of the form: (KEYS NAME type target template additional-options...).
  `doct--current-plist' provides the type, target template and additional options.
  If PARENT is non-nil, list is of the form (KEYS NAME)."
    `(,keys ,name
      ,@(unless parent
          `(,(doct--entry-type)
            ,(doct--template)
            :target ,(doct-org-roam--target)
            ,@(doct--additional-options)))
      :doct ( :doct-name ,name
                         ,@(cdr doct--current)
                         ,@(when-let ((custom (doct--custom-properties)))
                             `(:doct-custom ,custom)))))

  (defun doct-org-roam (declarations)
    "Convert DECLARATIONS to `org-roam-capture-templates'.
  DECLARATIONS must be of the same form that `doct' expects with
  one addition: the :org-roam keyword.
  The :org-roam keyword's value must be a plist mapping `org-roam''s
  template syntax extensions (e.g. :file-name :head) to their appropriate values.
  Note this does validate the :org-roam plist's values or keywords."

    ;;TODO: we should preserve doct-after-conversion-functions
    ;;in case user already has other functions set.
    (let ((doct-after-conversion-functions (append '(doct-org-roam-convert)
                                                   doct-after-conversion-functions)))
      (cl-letf (((symbol-function 'doct--compose-entry) #'doct-org-roam--compose-entry))
        (doct declarations))))
  (setq org-roam-completion-system 'default
        org-roam-capture-templates
        (doct-org-roam
         `(:group "Org Roam"
           :file "%<%Y%m%d%H%M%S>-${slug}.org"
           :icon ("nf-oct-inbox" :set "octicon" :color "yellow")
           :head "#+title: ${title}\n"
           :unnarrowed t
           :function ignore ;org-roam hardcodes target file logic
           :type plain
           :children
           (
            ("Default"
             :keys "d"
             :template "%?"
             :file "%(expand-file-name \"pages\" org-roam-directory)/${slug}.org")
            ))))
  )
