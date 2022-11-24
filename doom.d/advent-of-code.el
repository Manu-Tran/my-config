;;; ../my-config/doom.d/advent-of-code.el -*- lexical-binding: t; -*-

;; Directory containing all the aoc problems
(defvar aoc-root-dir "/Users/emmanueltran/Programmation/aoc")

(defvar aoc-current-problem-part "1")
(defvar aoc-current-problem-day nil)
(defvar aoc-current-problem-year nil)
(defvar aoc-mode-map (make-sparse-keymap))
(defvar aocd-dir "/Users/emmanueltran/.config/aocd/google.Manu T..1522435")
(defvar aoc-inflight-timers '())

(defvar aoc-mode-hook nil)

(map! :localleader
      :map aoc-mode-map
      "f"  #'aoc/find-file
      :prefix "q"
      "t"  #'aoc/run-on-test
      "T"  #'aoc/run-on-test-file
      "i"  #'aoc/run-on-input
      "r"  #'aoc/reload-token
      "F"  #'aoc/find-problem
      "f"  #'aoc/find-problem-same-year
      "s"  #'aoc/submit
      "S"  #'aoc/submit-input-run
      "SPC" #'aoc/today
      "d" #'aoc/dev-phase
      "e" #'aoc/test-phase
      "c" #'aoc/switch-console
      "w" #'aoc/open-wrong-answers
      "b" #'aoc/open-webpage
      )

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

(defun aoc/download-readme(&optional bypass)
  "Download & parse the current problem statement by converting it to markdown"
  (when (or (not (file-exists-p (aoc/get-day-file "README.md"))) bypass)
  (shell-command
   (concat aoc-root-dir
           "/bin/fetch-readme.sh "
           aoc-current-problem-year " "
           aoc-current-problem-day " "
           aoc-root-dir))))

(defun aoc/check-if-part-two()
  "Check if the current problem is at part 2 by parsing the README.md"
  (setq aoc-current-problem-part (number-to-string (shell-command (concat aoc-root-dir "/bin/is-part-two.sh " (aoc/get-day-file "README.md"))))))

(defun aoc/download-input()
  "Download the input file using aocd for current problem"
  (when (not (file-exists-p (aoc/get-day-file "input.txt")))
    (shell-command (concat "aocd " aoc-current-problem-day " " aoc-current-problem-year "> " (aoc/get-day-file "input.txt")))))

(defun aoc/reload-token()
  "Reload the aoc token using aocd and put it in ~/.config/aocd/token"
  (interactive)
  (shell-command "aocd-token > ~/.config/aocd/token"))

(defun aoc/open-wrong-answers()
  (interactive)
  (find-file (concat aocd-dir "/" aoc-current-problem-year "_"
          ;; Pad the day number
          (if (>= 9 (length aoc-current-problem-day)) "0")
          aoc-current-problem-day
          ;; Convert the part
          (if (string-equal aoc-current-problem-part "2") "b" "a")
          "_bad_answers.txt"))
  )

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

(defun aoc/get-wrong-submitted-answer()
  "Fetch all the bad answers by fetching the right bad answer file"
  (interactive)
  (split-string
   (print (ignore-errors (shell-command-to-string (concat "cat \"" aocd-dir "/" aoc-current-problem-year "_"
          ;; Pad the day number
          (if (>= 9 (length aoc-current-problem-day)) "0")
          aoc-current-problem-day
          ;; Convert the part
          (if (string-equal aoc-current-problem-day "2") "b" "a")
          "_bad_answers.txt\" | sed -E 's/(\d*) .*/\1/' | tr '\\n' ' '")
  )))))

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

(defun aoc/submit-input-run()
  "Submit a solution for the current problem using aocd"
  (interactive)
  (shell-command-to-string (concat "echo -n \"...\" > " (aoc/get-day-file "last_output")))
  (aoc/run-on-input)
  (setq aoc/timers_retry 10)
  (add-to-list aoc-inflight-timers (run-with-timer 1 nil #'aoc/on-exec-timers)))

(defun aoc/run-on-test()
  "Run current code on test input file by passing the file in env"
  (interactive)
  (python-shell-send-string "import os; os.environ[\"AOC_INPUT\"] = \"test.txt\"")
  (python-shell-send-buffer)
  (aoc/switch-console))

(defun aoc/run-on-test-file()
  "Run current code on test input file by passing the file in env"
  (interactive)
  (ivy-read "Choose test file : "
            (directory-files (concat (aoc/get-day-file)) nil "test*")
            :sort t
            :action (lambda (file)
                      (python-shell-send-string (concat "import os; os.environ[\"AOC_INPUT\"] = \"" file "\""))
                      (python-shell-send-buffer)
                      (aoc/switch-console))))

(defun aoc/on-exec-timers()
  "Wait for python to finish computing by scheduling timers"
  (setq aoc-inflight-timers (butlast aoc-inflight-timers))
  (setq aoc/timers_max_retry (1- aoc/timers_retry))
  (when (not (eq 0 aoc/timers_retry)) (setq aoc_res (shell-command-to-string (concat "cat " (aoc/get-day-file "last_output"))))
  (if (or (not aoc_res) (string-equal aoc_res "..."))
      (add-to-list aoc-inflight-timers (run-with-timer 1 nil #'aoc/on-exec-timers))
    (progn
      (message (concat "Sending " aoc_res " as a solution..."))
      (aoc/submit-action aoc_res)))))

(defun aoc/run-on-input()
  "Run current code on true input file by passing the file in env"
  (interactive)
  (python-shell-send-string "import os; os.environ[\"AOC_INPUT\"] = \"input.txt\"")
  (python-shell-send-buffer)
  (aoc/switch-console))

(defun aoc/switch-to-second-part(&optional force)
  "Switch the workspace to the second part of the problem"
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
  (setq aoc-current-problem-day (format-time-string "%d"))
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
                                        (if day day (format-time-string "%d"))))
            )
  (aoc/setup-workspace))

(defun aoc/switch-console()
  "Switch to the python console in the other window"
  (interactive)
  (ignore-errors (evil-window-right 1))
  (ignore-errors (evil-window-down 1))
  (switch-to-buffer "*Python*")
  (evil-window-left 1)
  )

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
                                          (if day day (format-time-string "%d")))))
    (aoc/setup-workspace))

;; (defun aoc/setup-windows()
;;   (delete-other-windows)
;;   ;; right pane
;;   (find-file (aoc/get-day-file (concat "p" aoc-current-problem-part ".py")))
;;   (+evil/window-vsplit-and-follow)
;;   ;; up left pane
;;   (find-file (aoc/get-day-file "test.txt"))
;;   (find-file (aoc/get-day-file "input.txt"))
;;   (+evil/window-split-and-follow)
;;   ;; down left pane
;;   (find-file (aoc/get-day-file "README.md"))
;;   (switch-to-buffer "*Python*")
;;   (evil-window-left 1)
;;   )

(defun aoc/open-webpage()
  (interactive)
  (browse-url (concat "https://adventofcode.com/" aoc-current-problem-year "/day/" aoc-current-problem-day)))

(defun aoc/setup-workspace()
  ;; Init
  (message "Setting up workspace...")
  (run-python)
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

(defun aoc/dev-phase()
  ;; Switch to a 2 pane layout
  (interactive)
  (delete-other-windows)
  ;; right pane
  (find-file (aoc/get-day-file (concat "p" aoc-current-problem-part ".py")))
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
  (find-file (aoc/get-day-file (concat "p" aoc-current-problem-part ".py")))
  (+evil/window-vsplit-and-follow)
  ;; up left pane
  (find-file (aoc/get-day-file "input.txt"))
  (find-file (aoc/get-day-file "test.txt"))
  (+evil/window-split-and-follow)
  ;; down left pane
  (switch-to-buffer "*Python*")
  (evil-window-left 1)
  )

(add-to-list inferior-python-mode-hook #'aoc-mode)

(run-hooks 'aoc-mode-hook)

(define-minor-mode aoc-mode
  "For solving adventofcode problems"
  :keymap aoc-mode-map
  :lighter " aoc"
  )
