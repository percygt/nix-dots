;;; +elfeed.el -*- lexical-binding: t; -*-
(setq elfeed-goodies/entry-pane-size 0.5)

(evil-define-key 'normal elfeed-show-mode-map
  (kbd "J") 'elfeed-goodies/split-show-next
  (kbd "K") 'elfeed-goodies/split-show-prev)
(evil-define-key 'normal elfeed-search-mode-map
  (kbd "J") 'elfeed-goodies/split-show-next
  (kbd "K") 'elfeed-goodies/split-show-prev)

(define-advice elfeed-search--header (:around (oldfun &rest args))
  (if elfeed-db
      (apply oldfun args)
    "No database loaded yet"))

(advice-add  'elfeed-show-entry :after #'+process-elfeed-entry)

(defun +process-elfeed-entry (entry)
  "Process each type of entry differently.
  e.g., you may want to open HN entries in eww."
  (let ((url (elfeed-entry-link entry)))
    (pcase url
      ((pred (string-match-p "https\\:\\/\\/www.youtube.com\\/watch"))
       (youtube-sub-extractor-extract-subs url))
      (_ (+eww-open-in-other-window url)))))
;; this is Doom syntax, I'm sure you can figure out vanilla Emacs one
(map! (:map embark-url-map "e" #'+eww-open-in-other-window))

(defun +eww-open-in-other-window (url)
  "Use `eww-open-in-new-buffer' in another window."
  (interactive (list (car (eww-suggested-uris))))
  (other-window-prefix)  ; For emacs28 -- it's a hack, but why not?
  (eww-browse-url url :new-window))
