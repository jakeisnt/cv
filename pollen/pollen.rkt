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
    [(ltx pdf) (apply string-append `("{\\huge " ,@elements "}"))]
    [(txt) elements]
    [(html) (txexpr 'h2 empty elements)]))

;; top of the document; typically the name
(define (heading . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\huge " ,@elements "}"))]
    [(txt) (list "=== "(map string-upcase elements) " ===")]
    [(html) (txexpr 'h2 empty elements)]))

;; job title or designation; typically a subheader
(define (title . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("*" ,@elements "*")]
    [(html) (txexpr 'h3 empty elements)]))

(define (body . elements)
  `("-------------------------\n" ,@elements))

;; a social link with a service name and username provided by urlstring
;; assumes form of e.g. http://servicename.com/i/j/k/username
(define (link urlstr)
  (define urlstruct (string->url urlstr))
  (define service (cadr (reverse (string-split (url-host urlstruct) "."))))
  (define username (path/param-path (car (reverse (url-path urlstruct)))))
  (list "- " service ": " username "  (" urlstr ")"))

(define (section . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\huge " ,@elements "}"))]
    [(txt) `("\n" ,@elements "---")]
    [(html) (txexpr 'section empty elements)]))

(define (emph . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("**" ,@elements "**")]
    [(html) (txexpr 'strong empty elements)]))

;; an individual experience on the resume
(define (experience . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("--\n" ,@elements "\n")]
    [(html) (txexpr 'strong empty elements)]))

;; the header of this experience
;; typically encludes place, role and time period
(define (exphead . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt)
     (add-newlines (map (lambda (a) (list "|" a)) (rm-newlines elements)))
     ]
    [(html) (txexpr 'strong empty elements)]))

;; the body of an experience
;; typically contains things accomplished during the experience
(define (expbody . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) elements]
    [(html) (txexpr 'strong empty elements)]))

;; bullet point in the body of an experience
(define (expbullet . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("- " ,@elements "")]
    [(html) (txexpr 'strong empty elements)]))

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

;; a list of experiences, skills or otherwise
(define (explist . elements)
  (print elements)
  ; (print (map (lambda (a) (string-append a " + ")) elements))) */
  (mapca (lambda (a) (string-append a " + "))
         (rm-newlines elements)))

;; container for a sidebar (shown separately from a main body)
(define (sidebar . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("**" ,@elements "**")]
    [(html) (txexpr 'h3 empty elements)]))

;; formatting for a date and time period
;; should have enough information to display date however possible (racket datetime thing?)
(define (date . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("**" ,@elements "**")]
    [(html) (txexpr 'h3 empty elements)]))

