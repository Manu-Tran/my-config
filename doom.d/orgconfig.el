;;; orgconfig.el -*- lexical-binding: t; -*-

;; (use-package! org-super-agenda
;;   :commands (org-super-agenda-mode))
;; (after! org-agenda
;;   (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-tags-column 100 ;; from testing this seems to be a good value
      org-agenda-compact-blocks t)

(setq org-agenda-custom-commands
      '(("o" "Overview"
         ((agenda "" ((org-agenda-span 'day)
                      (org-super-agenda-groups
                       '((:name "Today"
                                :time-grid t
                                :date today
                                :todo "TODAY"
                                :scheduled today
                                :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:name "Work"
                                 :tag "work"
                                 :children t
                                 :order 1)
                          (:name "Important"
                                 :tag "Important"
                                 :priority "A"
                                 :order 6)
                          (:name "Due Today"
                                 :deadline today
                                 :order 2)
                          (:name "Due Soon"
                                 :deadline future
                                 :order 8)
                          (:name "Overdue"
                                 :deadline past
                                 :face error
                                 :order 7)
                          (:name "Issues"
                                 :tag "Issue"
                                 :order 12)
                          (:name "Emacs"
                                 :tag "Emacs"
                                 :order 13)
                          (:name "Projects"
                                 :tag "Project"
                                 :order 14)
                          (:name "Research"
                                 :tag "Research"
                                 :order 15)
                          (:name "To read"
                                 :tag "Read"
                                 :order 30)
                          (:name "Waiting"
                                 :todo "WAITING"
                                 :order 20)
                          (:name "Trivial"
                                 :priority<= "E"
                                 :tag ("Trivial" "Unimportant")
                                 :todo ("SOMEDAY" )
                                 :order 90)
                          (:discard (:tag ("Chore" "Routine" "Daily")))))))))))

(defvar +org-capture-file (expand-file-name "capture.org" org-directory))
(defvar +org-todo-work-file (expand-file-name "work.org" org-directory))
(defvar +org-todo-life-file (expand-file-name "life.org" org-directory))

(setq org-startup-folded t)
;; (defvar +org-capture-todo-file (+org--capture-local-root "todo.org"))
;; (defvar +org-capture-notes-file "notes.org")
;; (defvar +org-capture-someday-file "someday.org")

(setq org-capture-templates
      '(("t" "Personal todo" entry
         (file+headline +org-capture-file "Inbox")
         "* TODO %?\n%i\n%a" :prepend t)
        ("n" "Personal notes" entry
         (file+headline +org-capture-notes-file "")
         "* %u %?\n%i\n%a" :prepend t)
        ("X" "Work todo capture" entry
         (file+headline +org-todo-work-file "Inbox"))
        ("x" "Work todo today capture" entry
         (file+headline +org-todo-work-file "Today")
         "%i" :prepend t)
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
         "PROG(s)"  ; A task that is in progress
         "WAIT(w)"  ; Something external is holding up this task
         "HOLD(h)"  ; This task is paused/on hold because of me
         "RVWD(r)"  ; A task that is being reviewed
         "DPLY(d)"  ; A task being deployed
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
        ("PROG" . +org-todo-active)
        ("RVWD" . +org-todo-onhold)
        ("MYBE" . +org-todo-onhold)
        ("DPLY" . +org-todo-onhold)
        ("[?]"  . +org-todo-onhold)
        ("WAIT" . +org-todo-onhold)
        ("HOLD" . +org-todo-onhold)
        ("PROJ" . +org-todo-project)))


(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
        :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
        :unnarrowed t)
       ("t" "task" plain "%?"
        :target (file+head "task/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
        :unnarrowed t)
       ("T" "task_new" plain
           "#+title: ${title}\n\n%[~/org/templates/task.org]"
           :target (file "task/%<%Y%m%d%H%M%S>-${slug}.org")
           :unnarrowed t)
       ("m" "meeting" plain "* Meeting Notes\n%?"
        :target (file+head "meeting/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
        :unnarrowed t)
       ("p" "project" plain "* Pitch\n%?"
        :target (file+head "project/${slug}.org" "#+title: ${title}\n")
        :unnarrowed t)
       ;; ("i" "interview" plain
       ;;  (file "~/org/templates/interview.org")
       ;;  :if-new (file+head "interview/%<%Y%m%d%H%M%S>-${slug}.org" "")
       ;;  :head "#+TITLE: ${title}\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n\n"
       ;;  :unnarrowed t)
       ("i" "interview" plain
           "%[~/org/templates/interview.org]"
           :target (file "interview/%<%Y-%m-%d-%H>.org")
           :unnarrowed t)
       ;; ("i" "interview" plain
       ;;  "%?"
       ;;  :target (file "interview/${slug}.org" "%[~/org/templates/interview.org]")
       ;;  :unnarrowed t)
       ))

(defun my/interview-today ()
  (interactive)
  (let* ((today (format-time-string "%Y-%m-%d"))
         (timestamp (format-time-string "%Y-%m-%d-%H"))
         (interview-file (expand-file-name (format "interview/%s.org" timestamp) org-roam-directory))
         (template (assoc "i" org-roam-capture-templates)))
    ;; Create the interview file
    (org-roam-capture-
     :node (org-roam-node-create :title today)
     :templates (list template)
     :props '(:finalize find-file))
    ;; Add todo to work inbox
    (save-excursion
      (with-current-buffer (find-file-noselect +org-todo-work-file)
        (goto-char (point-min))
        (when (re-search-forward "^\\* Inbox" nil t)
          (org-end-of-subtree)
          (insert (format "\n* TODO Review interview [[file:%s][%s]]" interview-file timestamp))
          (save-buffer))))))
