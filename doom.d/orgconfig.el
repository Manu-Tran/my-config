
;;; orgconfig.el -*- lexical-binding: t; -*-

(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-day nil ;; i.e. today
      org-agenda-span 1
      org-agenda-start-on-weekday nil)
  (setq org-agenda-custom-commands
        '(("c" "Super view"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '(
                           (:name "Today"  ; Optionally specify section name
                            :time-grid t  ; Items that appear on the time grid
                            :todo "TODO")  ; Items that have this TODO keyword
                           (:name "Important"
                            ;; Single arguments given alone
                            :tag "vie"
                            )
                           (:name "Work"
                            :tag "work"
                            :todo "TODO"
                            )
                           ;; Groups supply their own section names when none are given
                           (:todo "RVWD" :order 8)  ; Set order of this section
                           (:todo "MYBE"
                            :order 9)
                           (:priority<= "B"
                            :order 1)
                           ))))))))
  :config
  (org-super-agenda-mode))
(use-package! org-super-agenda
  :after org-agenda
  :init
  :config
  (org-super-agenda-mode))
(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-tags-column 100 ;; from testing this seems to be a good value
      org-agenda-compact-blocks t)



(defun +org-init-capture-config-h ()
  (defvar +org-capture-file (expand-file-name "capture.org" org-directory))
  (defvar +org-todo-work-file (expand-file-name "work.org" org-directory))
  (defvar +org-todo-life-file (expand-file-name "life.org" org-directory))
  ;; (defvar +org-capture-todo-file (+org--capture-local-root "todo.org"))
  ;; (defvar +org-capture-notes-file "notes.org")
  ;; (defvar +org-capture-someday-file "someday.org")
  (setq org-capture-templates
        '(("t" "Personal todo" entry
           (file+headline +org-capture-file "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n%i\n%a" :prepend t)
          ("w" "Work todo" entry
           (file+headline +org-todo-work-file "Inbox")
           "* TODO %?\n%i" :prepend t)
          ("W" "Work Ticket todo" entry
           (file+headline +org-todo-work-file "Inbox")
           "* TODO %?\n%i\n** TODO Test on staging\n** TODO Merge on prod\n** TODO Deploy" :prepend t)
          ("l" "Life todo" entry
           (file+headline +org-todo-life-file "Inbox")
           "* TODO %?\n%i" :prepend t)
          ("e" "Tech todo" entry
           (file+headline +org-capture-file "Inbox-tech")
           "* TODO %?\n%i" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n%a" :prepend t)

          ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
          ;; {todo,notes,changelog}.org file is found in a parent directory.
          ;; Uses the basename from `+org-capture-todo-file',
          ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
          ("p" "Templates for projects")
          ("pt" "Project-local todo" entry  ; {project-root}/todo.org
           (file+headline +org-capture-project-todo-file "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("pn" "Project-local notes" entry  ; {project-root}/notes.org
           (file+headline +org-capture-project-notes-file "Inbox")
           "* %U %?\n%i\n%a" :prepend t)
          ("pc" "Project-local changelog" entry  ; {project-root}/changelog.org
           (file+headline +org-capture-project-changelog-file "Unreleased")
           "* %U %?\n%i\n%a" :prepend t)

          ;; Will use {org-directory}/{+org-capture-projects-file} and store
          ;; these under {ProjectName}/{Tasks,Notes,Changelog} headings. They
          ;; support `:parents' to specify what headings to put them under, e.g.
          ;; :parents ("Projects")
          ("o" "Centralized templates for projects")
          ("ot" "Project todo" entry
           (function +org-capture-central-project-todo-file)
           "* TODO %?\n %i\n %a"
           :heading "Tasks"
           :prepend nil)
          ("on" "Project notes" entry
           (function +org-capture-central-project-notes-file)
           "* %U %?\n %i\n %a"
           :heading "Notes"
           :prepend t)
          ("oc" "Project changelog" entry
           (function +org-capture-central-project-changelog-file)
           "* %U %?\n %i\n %a"
           :heading "Changelog"
           :prepend t)
          ))

  (setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "PROJ(p)"  ; A project, which usually contains other tasks
           "STRT(s)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           "HOLD(h)"  ; This task is paused/on hold because of me
           "RVWD(r)"  ; A task that is being reviewed
           "MYBE(m)"  ; A task that is not set or planned
           "|"
           "DONE(d)"  ; Task successfully completed
           "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "[ ](T)"   ; A task that needs doing
           "[-](S)"   ; Task is in progress
           "[?](W)"   ; Task is being held up or paused
           "|"
           "[X](D)")) ; Task was completed
        org-todo-keyword-faces
        '(("[-]"  . +org-todo-active)
          ("STRT" . +org-todo-active)
          ("RVWD" . +org-todo-onhold)
          ("MYBE" . +org-todo-onhold)
          ("[?]"  . +org-todo-onhold)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("PROJ" . +org-todo-project)))
  )

(add-hook! 'org-load-hook :append #'+org-init-capture-config-h)
