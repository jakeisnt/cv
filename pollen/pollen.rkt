#lang racket/base

;; this is a rudimentary expression language for customizing resumes
;; embedded in pollen!

(require racket/date racket/string racket/list txexpr pollen/setup net/url)
(provide (all-defined-out))

;; setup submodule: provides define statements for values to override
;; drop default prefix and just name the targets
(module setup racket/base
  (provide (all-defined-out))
  (define poly-targets '(html txt ltx pdf)))

;; summary text at the top of the resume
;; usually quickly describes job title and interests
(define (summary . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "summary")) elements)]
    [(txt) elements]
    [(ltx pdf) (apply string-append `("\n\\begin{cvparagraph} " ,@elements "\n\\end{cvparagraph}"))]))

;; head of the document; holds title information.
(define (head . elements)
  (define summary (last elements))
  (define header-items (all-but-last elements))
  (define split-len (/ (length header-items) 2))
  (define left (take header-items split-len ))
  (define right (drop  header-items split-len))
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "head"))
                    `((div ((id "halign"))
                          (div ((id "sleft")) ,@left)
                          (div ((id "sright")) ,@right))
                        ,summary))]
    [(txt) elements]
    [(ltx pdf) (apply string-append elements)]))

;; top of the document; typically the name
(define (heading . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "heading")) elements)]
    [(txt) (list "=== "(map string-upcase elements) " ===")]
    [(ltx pdf) (apply string-append elements)]))

;; job title or designation; typically a subheader
(define (title . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "title")) elements)]
    [(txt) `("*" ,@elements "*")]
    [(ltx pdf) (apply string-append elements)]))

;; the main body of the document
(define (body . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "body")) elements)]
    [(txt) `("-------------------------\n" ,@elements)]
    [(ltx pdf) (apply string-append elements)]))

;; a social link with a service name and username provided by urlstring
;; assumes form of e.g. http://servicename.com/i/j/k/username
(define (link urlstr)
  (define urlstruct (string->url urlstr))
  (define service (cadr (reverse (string-split (url-host urlstruct) "."))))
  (define username (path/param-path (car (reverse (url-path urlstruct)))))
  (define urlname `(,service ": " ,username))
  (case (current-poly-target)
    [(html) (txexpr 'div `((id "social-link"))
                    `(,service ": " (a ((href ,urlstr)) ,username)))]
    [(txt) (list "- " urlname " (" urlstr ")")]
    [(ltx pdf) (apply string-append urlname)]))

;; a section of the document
(define (section . elements)
  (define sectitle (first elements))
  (define secbody (rest elements))
  (case (current-poly-target)
    [(html) (txexpr 'section '((id "section"))
                    `((div ((id "sectitle")) ,sectitle)
                      ,@secbody))]
    [(txt) `("\n" ,@elements "---")]
    [(ltx pdf) (apply string-append
                      `("\\cvsection{" ,sectitle "}\n"
                         "\\begin{cventries}"
                         ,@secbody
                         "\\end{cventries}"))]))

;; an individual experience on the resume
(define (experience . elements)
  (define head (all-but-last elements))
  (define ttl (first head))
  (define org (second head))
  (define dt (third head))
  (define body (last elements))
  (case (current-poly-target)
    [(html)
     (txexpr 'div '((id "experience"))
                    `((div ((id "exphead"))
                          ,@(map (lambda (el) (list 'div el)) head))
                      ,body))]
    [(txt) `("--\n" ,@elements "\n")]
    [(ltx pdf) (apply string-append
                      `("\\cventroo\n"
                        "{\n" ,@(mapca (lambda (a) (string-append a "\\")) head) "}"
                        "{" ,body "}"))]))


;; "small experience" - no multiple headers
(define (smexp . elements)
  (define head (all-but-last elements))
  (define body (last elements))
  (define ttl (first head))
  (case (current-poly-target)
    [(html)
     (txexpr 'div '((id "experience"))
                    `((div ((id "exphead"))
                          ,@(map (lambda (el) (list 'div el)) head))
                      ,body))]
    [(txt) `("--\n" ,@elements "\n")]
    [(ltx pdf) (apply string-append
                      `("\\cventroo"
                        "{" ,@head "}"
                        "{" ,body "}\n"))]))

;; the body of an experience
;; typically contains things accomplished during the experience
(define (expbody . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "expbody")) elements)]
    [(txt) elements]
    [(ltx pdf)
     (define nelem (expand-until-list elements))
     (apply string-append
                      `("\n\\begin{cvitems}\n"
                         ,@nelem
                        "\\end{cvitems}"))]))

;; bullet point in the body of an experience
(define (expbullet . elements)
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "expbullet")) elements)]
    [(txt) `("- " ,@elements "")]
    [(ltx pdf)
     (define elem (expand-until-list elements))
     (apply string-append `("\\item{ " ,@elem "}"))]))

;; a list of experiences, skills or otherwise
;; these are distinct from bullets. bullets are full length parts of a description,
;; while these list elements are for showing in a list inline.
(define (explist . elements)
  (define ls (mapca (lambda (a) (string-append a " + ")) (rm-newlines elements)))
  (case (current-poly-target)
    [(html) (txexpr 'div '((id "explist")) ls)]
    [(txt) ls]
    [(ltx pdf) ls]))

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
    [(txt) `("" ,@elements "")] ;; should bbe  \\date{
    [(ltx pdf) (apply string-append `("" ,@elements ""))]))

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

;; produce the list with all but its last element
(define (all-but-last ls)
  (reverse (cdr (reverse ls))))

;; expand the first item of the list until we hit a string
(define (expand-first ls)
  (if (string? ls) ls (expand-first (first ls))))

(define (expand-until-list ls)
  (if (string? (first ls)) ls (expand-until-list (first ls))))
