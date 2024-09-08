;;; common-cfg.el --- Common Config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package multiple-cursors
  :after (evil)
  :evil-bind ((:map (leader-map)
		    ("nn" . mc/mark-next-like-this)
		    ("np" . mc/mark-previous-like-this)
		    ("na" . mc/mark-all-like-this))))

(provide 'common-cfg)
;;; common-cfg.el ends here