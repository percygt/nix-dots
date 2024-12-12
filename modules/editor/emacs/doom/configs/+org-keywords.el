(setq org-todo-keywords
      '((sequence "TODO(t)" "INPROG(i)" "PROJ(p)" "STORY(s)" "WAIT(w@/!)" "|" "DONE(d@/!)" "KILL(k@/!)")
        (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)"))
      ;; The triggers break down to the following rules:

      ;; - Moving a task to =KILLED= adds a =killed= tag
      ;; - Moving a task to =WAIT= adds a =waiting= tag
      ;; - Moving a task to a done state removes =WAIT= and =HOLD= tags
      ;; - Moving a task to =TODO= removes all tags
      ;; - Moving a task to =NEXT= removes all tags
      ;; - Moving a task to =DONE= removes all tags
      org-todo-state-tags-triggers
      '(("KILL" ("killed" . t))
        ("HOLD" ("hold" . t))
        ("WAIT" ("waiting" . t))
        (done ("waiting") ("hold"))
        ("TODO" ("waiting") ("cancelled") ("hold"))
        ("NEXT" ("waiting") ("cancelled") ("hold"))
        ("DONE" ("waiting") ("cancelled") ("hold")))

      ;; This settings allows to fixup the state of a todo item without
      ;; triggering notes or log.
      org-treat-S-cursor-todo-selection-as-state-change nil)
