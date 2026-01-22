;;; ../my-config/doom.d/advent-of-code.el -*- lexical-binding: t; -*-

;; Directory containing all the aoc problems
(defvar aoc-root-dir "/Users/emmanueltran/Programmation/aoc")

(defvar aoc-current-problem-part "1")
(defvar aoc-current-problem-day nil)
(defvar aoc-current-problem-year nil)
(defvar aoc-mode-map (make-sparse-keymap))
(defvar aocd-dir "/Users/emmanueltran/.config/aocd/manu")
(defvar aoc/timers-retry 0)
(defvar aoc/last-run-file nil)


(defvar aoc-mode-hook nil)

(map! :localleader
      :map aoc-mode-map
      "f" #'aoc/find-file
      "r" #'aoc/run-on-same-file
      "c" #'aoc/switch-console
      "d" #'aoc/dev-phase
      "e" #'aoc/test-phase
      :prefix "q"
      "t" #'aoc/run-on-test
      "T" #'aoc/run-on-test-file
      "i" #'aoc/run-on-input
      "I" #'aoc/run-buffer-on-input
      "r" #'aoc/run-on-same-file
      "R" #'aoc/reload-token
      "F" #'aoc/find-problem
      "f" #'aoc/find-problem-same-year
      "s" #'aoc/submit
      "S" #'aoc/submit-input-run
      "SPC" #'aoc/today
      "d" #'aoc/dev-phase
      "e" #'aoc/test-phase
      "c" #'aoc/switch-console
      "w" #'aoc/open-wrong-answers
      "b" #'aoc/open-webpage
      )

;;; ================================== Utilities ===================================================

(defun aoc/find-file()
  "Find a file in the current problem dir"
  (interactive)
  (counsel-find-file nil (aoc/get-day-file)))

(defun aoc/get-day-file(&optional file)
  "Get the path of the a file in the current problem directory"
  (concat aoc-root-dir "/" aoc-current-problem-year "/day" aoc-current-problem-day "/" file))

(defun aoc/move-python-in-current-problem()
  "Move the current python shell to the current problem directory"
  (interactive)
  ;; (print (concat "import os; os.chdir(" (aoc/get-day-file nil) ")"))
  (python-shell-send-string (concat "import os; os.chdir(\"" (aoc/get-day-file nil) "\")")))

(defun aoc/check-if-part-two()
  "Check if the current problem is at part 2 by parsing the README.md"
  (setq aoc-current-problem-part (number-to-string (shell-command (concat aoc-root-dir "/bin/is-part-two.sh " (aoc/get-day-file "README.md"))))))

(defun aoc/pad-day-number-if-needed()
  (if (>= 1 (length aoc-current-problem-day)) "0" ""))

(defun aoc/format-current-day()
  (string-clean-whitespace (format-time-string "%e")))

(defun aoc/open-webpage()
  (interactive)
  (browse-url (concat "https://adventofcode.com/" aoc-current-problem-year "/day/" aoc-current-problem-day)))

;;; ================================== IO/Submit ===================================================

(defun aoc/download-readme(&optional bypass)
  "Download & parse the current problem statement by converting it to markdown"
  (when (or (not (file-exists-p (aoc/get-day-file "README.md"))) bypass)
    (shell-command
     (concat aoc-root-dir
             "/bin/fetch-readme.sh "
             aoc-current-problem-year " "
             aoc-current-problem-day " "
             aoc-root-dir))))

(defun aoc/download-input()
  "Download the input file using aocd for current problem"
  (when (not (file-exists-p (aoc/get-day-file "input.txt")))
    (shell-command (concat "aocd " aoc-current-problem-day " " aoc-current-problem-year "> " (aoc/get-day-file "input.txt")))))

(defun aoc/reload-token()
  "Reload the aoc token using aocd and put it in ~/.config/aocd/token"
  (interactive)
  (shell-command "aocd-token > ~/.config/aocd/token"))

(defun aoc/submit-action(solution)
  "Confirm the sent solution and submit it"
  (when (and solution (y-or-n-p (concat "Confirm sending : " solution)))
    (progn (shell-command
            (concat aoc-root-dir "/bin/aocd-submit "
                    aoc-current-problem-year " "
                    aoc-current-problem-day " "
                    aoc-current-problem-part " "
                    "\"" solution "\""))
           (aoc/download-readme t)
           (when (not (string-equal aoc-current-problem-part "2"))
             (progn
               (aoc/check-if-part-two)
               (when (string-equal aoc-current-problem-part "2") (aoc/switch-to-second-part)))))
    ))

(defun aoc/submit()
  "Submit a solution for the current problem using aocd"
  (interactive)
  (ivy-read "Enter solution : " (aoc/get-wrong-submitted-answer) :action #'aoc/submit-action))

;;; ================================== Error handling ==============================================

(defun aoc/open-wrong-answers()
  (interactive)
  (find-file (concat aocd-dir "/" aoc-current-problem-year "_"
                     ;; Pad the day number
                     (aoc/pad-day-number-if-needed)
                     aoc-current-problem-day
                     ;; Convert the part
                     (if (string-equal aoc-current-problem-part "2") "b" "a")
                     "_bad_answers.txt"))
  )

(defun aoc/get-wrong-submitted-answer()
  "Fetch all the bad answers by fetching the right bad answer file"
  (interactive)
  (split-string
   (print (ignore-errors (shell-command-to-string (concat "cat \"" aocd-dir "/" aoc-current-problem-year "_"
                                                          ;; Pad the day number
                                                          (aoc/pad-day-number-if-needed)
                                                          aoc-current-problem-day
                                                          ;; Convert the part
                                                          (if (string-equal aoc-current-problem-day "2") "b" "a")
                                                          "_bad_answers.txt\" 2&>1 | sed -E 's/(\d*) .*/\1/' | tr '\\n' ' '")
                                                  )))))

;;; ========================================= Run code =============================================

(defun aoc/run-on-input(&optional submit current-buffer)
  "Run current code on true input file by passing the file in env"
  (interactive)
  (setq aoc/last-run-file "input.txt")
  (python-shell-send-string (concat "import os; os.environ[\"AOC_INPUT\"] = \"input.txt\"; os.environ[\"RUN_MODE\"] = " (if submit "\"SUBMIT\"" "\"DRY_RUN\"")))
  (if current-buffer (python-shell-send-buffer) (python-shell-send-file (aoc/get-code-file)))
  (aoc/switch-console))

(defun aoc/run-on-same-file(&optional current-buffer)
  "Run current code on last used file by passing the file in env"
  (interactive)
  (when aoc/last-run-file
        (python-shell-send-string (concat "import os; os.environ[\"AOC_INPUT\"] = \"" aoc/last-run-file "\"; os.environ[\"RUN_MODE\"] = \"DRY_RUN\""))
        (if current-buffer (python-shell-send-buffer) (python-shell-send-file (aoc/get-code-file)))
        (aoc/switch-console)))

(defun aoc/run-buffer-on-input()
  "Run current code on true input file by passing the file in env"
  (interactive)
  (aoc/run-on-input nil t))

(defun aoc/submit-input-run()
  "Submit a solution for the current problem using aocd"
  (interactive)
  (shell-command-to-string (concat "echo -n \"...\" > " (aoc/get-day-file "last_output")))
  (aoc/run-on-input t)
  (setq aoc/timers-retry 10)
  (run-with-timer 1 nil #'aoc/on-exec-timers))

(defun aoc/run-on-test(&optional file)
  "Run current code on test input file by passing the file in env"
  (interactive)
  (when (not file) (setq file "test.txt"))
  (setq aoc/last-run-file file)
  (python-shell-send-string (concat "import os; os.environ[\"AOC_INPUT\"] = \"" file "\"; os.environ[\"RUN_MODE\"] = \"DRY_RUN\""))
  (python-shell-send-file (aoc/get-code-file))
  (aoc/switch-console))

(defun aoc/run-on-test-file()
  "Run current code on test input file by passing the file in env"
  (interactive)
  (ivy-read "Choose test file : "
            (directory-files (concat (aoc/get-day-file)) nil "test*")
            :sort t
            :action (lambda (file)
                      (aoc/run-on-test file))))

(defun aoc/on-exec-timers()
  "Wait for python to finish computing by scheduling timers"
  (setq aoc/timers-retry (1- aoc/timers-retry))
  (if (eq 0 aoc/timers-retry) (message "Timeout exceeded..."))
  (when (not (eq 0 aoc/timers-retry))
    (setq aoc_res (shell-command-to-string (concat "cat " (aoc/get-day-file "last_output"))))
    (if (or (not aoc_res) (string-equal aoc_res "..."))
        (run-with-timer 1 nil #'aoc/on-exec-timers)
      (progn
        (message (concat "Sending " aoc_res " as a solution..."))
        (aoc/submit-action aoc_res)))))

;;; ========================================= Setup Workspace ======================================

(defun aoc/switch-to-second-part(&optional force)
  "Switch the workspace to the second part of the problem"
  (interactive)
  (when (or force (not (file-exists-p (aoc/get-day-file "p2.py"))))
    (copy-file
     (aoc/get-day-file "p1.py") (aoc/get-day-file "p2.py")))
  (setq aoc-current-problem-part "2")
  (aoc/dev-phase)
  )

(defun aoc/today()
  "Setup today's advent of code problem"
  (interactive)
  (setq aoc-current-problem-year (format-time-string "%Y"))
  (setq aoc-current-problem-day (aoc/format-current-day))
  (setq aoc-current-problem-part "1")
  (aoc/setup-workspace))

(defun aoc/find-problem()
  "Setup a advent of code problem"
  (interactive)
  (ivy-read "Choose year (default : this year) : "
            (cl-map 'list #'number-to-string (number-sequence 2015 2022))
            :sort t
            :action (lambda (year) (setq aoc-current-problem-year
                                         (if year year (format-time-string "%Y"))))
            )
  (ivy-read "Choose day (default : today) : "
            (cl-map 'list #'number-to-string (number-sequence 1 25))
            :sort t
            :action (lambda (day) (setq aoc-current-problem-day
                                        (if day day (aoc/format-current-day))))
            )
  (aoc/setup-workspace))

(defun aoc/force-boilerplate-reload()
  "Force copying the boilerplate to the current problem dir"
  (interactive)
  (if (string-equal aoc-current-problem-part "1") (aoc/setup-boilerplate t) (aoc/switch-to-second-part t)))

(defun aoc/setup-boilerplate(&optional force)
  "Copy the boilerplate to the current problem dir"
  (when (or force (not (file-exists-p (aoc/get-day-file "p1.py"))))
    (copy-file
     (concat aoc-root-dir "/boilerplate/boilerplate.py") (aoc/get-day-file "p1.py") force)
    (make-symbolic-link
     (concat aoc-root-dir "/boilerplate/helper.py") (aoc/get-day-file "helper.py") t)))


(defun aoc/find-problem-same-year()
  "Setup a advent of code problem of the same year as already set"
  (interactive)
  (when (not aoc-current-problem-year)
    (ivy-read "Choose year (default : this year) : "
              (cl-map 'list #'number-to-string (number-sequence 2015 2022))
              :sort t
              :action (lambda (year) (setq aoc-current-problem-year
                                           year))))
  (ivy-read "Choose day (default : today) : "
            (cl-map 'list #'number-to-string (number-sequence 1 25))
            :sort t
            :action (lambda (day) (setq aoc-current-problem-day
                                        (if day day (aoc/format-current-day)))))
  (aoc/setup-workspace))

(defun aoc/setup-workspace()
  ;; Init
  (message "Setting up workspace...")
  ;; Run Python and mark the buffer as part of the project
  (run-python)
  (doom-mark-buffer-as-real-h)
  (aoc/reload-token)

  ;; Setup
  (message "Downloading README...")
  (aoc/download-readme)
  (message "Downloading input...")
  (aoc/download-input)
  (aoc/setup-boilerplate)
  (aoc/check-if-part-two)
  (aoc/move-python-in-current-problem)
  (aoc/open-webpage)
  (aoc/dev-phase)
  )

(defun aoc/get-code-file(&optional part)
  "Get the filepath of the current code file"
  (if part
      (aoc/get-day-file (concat "p" part ".py"))
    (aoc/get-day-file (concat "p" aoc-current-problem-part ".py"))
    )
  )


;;; ========================================= Layout =============================================

(defun aoc/switch-console()
  "Switch to the python console in the other window"
  (interactive)
  (ignore-errors (evil-window-right 1))
  (ignore-errors (evil-window-down 1))
  (switch-to-buffer "*Python*")
  (doom-mark-buffer-as-real-h)
  (evil-window-left 1)
  )

(defun aoc/dev-phase()
  ;; Switch to a 2 pane layout
  (interactive)
  (delete-other-windows)
  ;; right pane
  (find-file (aoc/get-code-file))
  (+evil/window-vsplit-and-follow)
  ;; up left pane
  (find-file (aoc/get-day-file "input.txt"))
  (find-file (aoc/get-day-file "test.txt"))
  (find-file (aoc/get-day-file "README.md"))
  (search-forward (if (string-equal aoc-current-problem-part "1") "Day" "Part Two"))
  (evil-scroll-line-to-top (evil-ex-current-line))
  )

(defun aoc/test-phase()
  ;; Switch to a 3 pane layout
  (interactive)
  (delete-other-windows)
  ;; right pane
  (find-file (aoc/get-code-file))
  (+evil/window-vsplit-and-follow)
  ;; up left pane
  (find-file (aoc/get-day-file "input.txt"))
  (find-file (aoc/get-day-file "test.txt"))
  (+evil/window-split-and-follow)
  ;; down left pane
  (switch-to-buffer "*Python*")
  (evil-window-left 1)
  )

;;; ============================== Minor mode configuration ========================================

(after! inferior-python-mode
  (add-hook 'inferior-python-mode-hook 'aoc-mode))

(run-hooks 'aoc-mode-hook)

(define-minor-mode aoc-mode
  "For solving adventofcode problems"
  :keymap aoc-mode-map
  :lighter " aoc"
  )

(provide 'aoc-mode)
;;; advent-of-code.el ends here
