#lang racket/base

(require racket/date racket/string txexpr pollen/setup net/url)
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
    [(txt) (map string-upcase elements)]
    [(html) (txexpr 'h2 empty elements)]))

;; job title or designation; typically a subheader
(define (title . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("*" ,@elements "*")]
    [(html) (txexpr 'h3 empty elements)]))

(define (link urlstr)
  (define urlstruct (string->url urlstr))
  ;; (print urlstruct) */
  (define service (cadr (reverse (string-split (url-host urlstruct) "."))))
  (define username (path/param-path (car (reverse (url-path urlstruct)))))
  (print service)
  (print username)
  (list service ": " username "  (" urlstr ")"))

(define (section . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\huge " ,@elements "}"))]
    [(txt) `("\n" ,@elements " ---")]
    [(html) (txexpr 'section empty elements)]))

(define (emph . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("**" ,@elements "**")]
    [(html) (txexpr 'strong empty elements)]))

;; 'experience' section
(define (experience . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("--\n" ,@elements "\n")]
    [(html) (txexpr 'strong empty elements)]))

(define (exphead . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("" ,@elements "")]
    [(html) (txexpr 'strong empty elements)]))

(define (expbody . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("- " ,@elements "")]
    [(html) (txexpr 'strong empty elements)]))


(define (sidebar . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("**" ,@elements "**")]
    [(html) (txexpr 'h3 empty elements)]))

(define (date . elements)
  (case (current-poly-target)
    [(ltx pdf) (apply string-append `("{\\bf " ,@elements "}"))]
    [(txt) `("**" ,@elements "**")]
    [(html) (txexpr 'h3 empty elements)]))
