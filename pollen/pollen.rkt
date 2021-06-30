#lang racket/base

(require racket/date racket/string racket/list txexpr pollen/setup net/url)
(provide (all-defined-out))

;; setup submodule: provides define statements for values to override
;; drop default prefix and just name the targets
(module setup racket/base
  (provide (all-defined-out))
  (define poly-targets '(html txt ltx pdf)))

(define (get-date)
  (date->string (current-date)))

;; head of the document; holds title information.
(define (head . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "docheader")) elements)]
    [(txt) elements]
    [(ltx pdf) (apply string-append `("{\\huge " ,@elements "}"))]))

;; top of the document; typically the name
(define (heading . elements)
  (case (current-poly-target)
    [(html) (txexpr 'h2 empty elements)]
    [(txt) (list "=== "(map string-upcase elements) " ===")]
    [(ltx pdf) (apply string-append `("{\\huge " ,@elements "}"))]))

;; job title or designation; typically a subheader
(define (title . elements)
  (case (current-poly-target)
    [(html) (txexpr 'h3 empty elements)]
    [(txt) `("*" ,@elements "*")]
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]))

;; the main body of the document
(define (body . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "body")) elements)]
    [(txt) `("-------------------------\n" ,@elements)]))

;; a social link with a service name and username provided by urlstring
;; assumes form of e.g. http://servicename.com/i/j/k/username
(define (link urlstr)
  (define urlstruct (string->url urlstr))
  (define service (cadr (reverse (string-split (url-host urlstruct) "."))))
  (define username (path/param-path (car (reverse (url-path urlstruct)))))
  (define urlname (list service ": " username))
  (case (current-poly-target)
    [(html) (txexpr 'a (list (list 'href urlstr)) urlname)]
    [(txt) (list "- " urlname " (" urlstr ")")]))

(define (section . elements)
  (case (current-poly-target)
    [(html) (txexpr 'section empty elements)]
    [(txt) `("\n" ,@elements "---")]
    [(ltx pdf) (apply string-append `("{\\huge " ,@elements "}"))]))

(define (emph . elements)
  (case (current-poly-target)
    [(html) (txexpr 'strong empty elements)]
    [(txt) `("**" ,@elements "**")]
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]))

;; an individual experience on the resume
(define (experience . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "experience")) elements)]
    [(txt) `("--\n" ,@elements "\n")]
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]))

;; the header of this experience
;; typically encludes place, role and time period
(define (exphead . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "exphead")) (map (lambda (el) (list 'div el)) elements))]
    [(txt) (add-newlines (map (lambda (a) (list "|" a)) (rm-newlines elements))) ]
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]))

;; the body of an experience
;; typically contains things accomplished during the experience
(define (expbody . elements)
  (case (current-poly-target)
    [(html) (txexpr 'p empty elements)]
    [(txt) elements]
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]))

;; bullet point in the body of an experience
(define (expbullet . elements)
  (case (current-poly-target)
    [(html) (txexpr 'li empty elements)]
    [(txt) `("- " ,@elements "")]
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]))

;; a list of experiences, skills or otherwise
(define (explist . elements)
  (define ls (mapca (lambda (a) (string-append a " + ")) (rm-newlines elements)))
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "explist")) ls)]
    [(txt) ls]
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]))

;; container for a sidebar (shown separately from a main body)
(define (sidebar . elements)
  (case (current-poly-target)
    [(html) (txexpr 'h3 empty elements)]
    [(txt) `("**" ,@elements "**")]
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]))

;; formatting for a date and time period
;; should have enough information to display date however possible (racket datetime thing?)

;; accepts either:
;; racket date object
;; iso 8601 formatted date string
;; produces a date in a good format? maybe give it specific flags?
;; for now it will just rerender what it was given
(define (date . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "date")) elements)]
    [(txt) `("" ,@elements "")]
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]))

;; --- helper functions
;; map but skip the last element of the list
(define (mapca fn ls)
  (cond
    [(empty? (rest ls)) ls]
    [(cons? ls) (cons (fn (first ls)) (mapca fn (rest ls)))]))

;; remove newline strings from list
(define (rm-newlines ls)
  (filter (lambda (s) (not (and (string? s) (string=? s "\n")))) ls))

;; add newline strings after every element in the list
(define (add-newlines ls)
  (foldr (lambda (e rst) (cons e (cons "\n" rst))) '() ls))
