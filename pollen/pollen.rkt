#lang racket/base

(require racket/date txexpr)
(provide (all-defined-out))

(define (get-date)
  (date->string (current-date)))

(define (heading . elements)
  (txexpr 'h2 empty elements))

(define (emph . elements)
  (txexpr 'strong empty elements))
