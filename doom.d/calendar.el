;;; $DOOMDIR/calandar.el -*- lexical-binding: t; -*-

;; First day of the week
(setq calendar-week-start-day 1) ; 0:Sunday, 1:Monday

(defun my-open-calendar ()
  (interactive)
  (+workspace/rename "Calendar")
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; org-agenda source
    ;; (cfw:org-create-file-source "cal" "~/org/todo.org" "Cyan")  ; other org source
    ;; (cfw:howm-create-source "Blue")  ; howm source
    ;; (cfw:cal-create-source "Orange") ; diary source
    ;; (cfw:ical-create-source "Moon" "~/moon.ics" "Gray")  ; ICS source1
    (cfw:ical-create-source "gcal" "https://calendar.google.com/calendar/ical/emmanuel.tran%40gmail.com/private-8f3f3127757add2c0a04e66073e90949/basic.ics" "Blue") ; google calendar ICS
   )))
; To show French holidays (and only those) in your Emacs calendar,
; put the following lines into your .emacs:
;   (require 'french-holidays)
;   (setq calendar-holidays holiday-french-holidays)

(eval-when-compile
  (require 'calendar)
  (require 'holidays))

(defvar holiday-french-holidays nil
  "French holidays")

(setq holiday-french-holidays
      `((holiday-fixed 1 1 "Jour de l'an")
	(holiday-fixed 1 6 "Epiphanie")
	(holiday-fixed 2 2 "Chandeleur")
	(holiday-fixed 2 14 "Saint Valentin")
	(holiday-fixed 5 1 "Fête du travail")
	(holiday-fixed 5 8 "Commemoration de la capitulation de l'Allemagne en 1945")
	(holiday-fixed 6 21 "Fete de la musique")
	(holiday-fixed 7 14 "Fete nationale - Prise de la Bastille")
	(holiday-fixed 8 15 "Assomption (Religieux)")
	(holiday-fixed 11 11 "Armistice de 1918")
	(holiday-fixed 11 1 "Toussaint")
	(holiday-fixed 11 2 "Commemoration des fideles defunts")
	(holiday-fixed 12 25 "Noel")
        ;; fetes a date variable
	(holiday-easter-etc 0 "Paques")
        (holiday-easter-etc 1 "Lundi de Paques")
        (holiday-easter-etc 39 "Ascension")
        (holiday-easter-etc 49 "Pentecote")
        (holiday-easter-etc -47 "Mardi gras")
	(holiday-float 5 0 4 "Fete des meres")
	;; dernier dimanche de mai ou premier dimanche de juin si c'est le
	;; meme jour que la pentecote TODO
	(holiday-float 6 0 3 "Fete des peres"))) ;; troisieme dimanche de juin

(provide 'french-holidays)

(require 'french-holidays)
(setq calendar-holidays holiday-french-holidays)
