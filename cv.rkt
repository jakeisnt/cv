#lang at-exp racket/base

;; mostly from https://www.asumu.xyz/docs/cv.rkt

(require pict
         ppict
         racket/class
         racket/draw
         slideshow-text-style)

;; First set up the DC so we can get the size
(define dc
  (new pdf-dc%
       [as-eps #f]
       [interactive #f]
       [output "cv.pdf"]))

(define-values (width height) (send dc get-size))

;; factor margins in
(define-values (width* height*)
  (values (* (/ 7.5 8.5) width) (* (/ 9 11) height)))

(with-text-style
  #:defaults [#:face "Overpass, Light"
              #:size 16]
  ([t #:line-sep 3]
   [h1 #:face "Bebas Neue, Bold" #:size 28]
   [h2 #:face "Overpass, Bold"]
   [h3 #:face "Overpass"]
   [tt  #:face "Inconsolata"])

  ;; for breaking up sections
  (define hr
    (vl-append (blank 1 5)
               (colorize (hline (* (/ 7.5 8.5) width) 1) "Gray")
               (blank 1 5)))

  (define page-1
    (ppict-do (blank width* height*)
      #:go (coord 1 0 'rt)
      @tt{jake@"@"isnt.online
          http://jake.isnt.online}
      #:go (coord 0.73 -0.005 'rt)
      #:go (coord 0 0 'lt)
      @h1{Jacob Chvatal}
      (blank 1 20)
      (linewidth 2 (hline (* (/ 7.5 8.5) width) 1))
      (blank 1 20)
      @t[#:line-sep 0]{
         @h2{Education}
         @hr
         @h3{BSc in Computer Science}
         Northeastern University, expected 2022
      }
      @blank[1 20]
      @h2{Employment}
      @hr
      @(ppict-do (blank width* (pict-height @h3{R}))
         #:go (coord 0 0 'lt) @h3{Software Engineer}
         #:go (coord 0.35 0 'lt) @h3{Igalia SL}
         #:go (coord 1 0 'rt) @h3{2016-Current})
      @blank[1 10]
      @t[#:line-sep 0]{
         ▸  Contributing to WebAssembly implementations in web browsers.
         @blank[1 3]
         ▸  Implemented high-speed user-space networking using Snabb & LuaJIT.
      }
      @blank[1 20]
      @(ppict-do (blank width* (pict-height @h3{R}))
         #:go (coord 0 0 'lt) @h3{Research Assistant}
         #:go (coord 0.35 0 'lt) @h3{Northeastern University}
         #:go (coord 1 0 'rt) @h3{2010-2016})
      @blank[1 10]
      @t[#:line-sep 0]{
         ▸  Designed & implemented a gradual type system to allow users to add optional
              type annotations for OO code in Typed Racket. In production use at a startup.
         @blank[1 3]
         ▸  Led a team designing a novel performance evaluation method for gradual typing.
              Evaluation method led to performance gains, one user reported 20% speedup.
         @blank[1 3]
         ▸  Supervised two MS students in adding features to Typed Racket. The two topics
              are support for first-class modules and for contracts/higher-order assertions.
      }
      @blank[1 20]
      @h2{Free/Open Source Software Development}
      @hr
      @t{▸  Have maintained 10+ libraries, 2 tools, and have contributed to many projects.
         ▸  Core developer for the Racket language & maintains a Racket PPA for Ubuntu.
         @(blank 1 4)
         Github:  http://github.com/takikawa}
      (blank 1 20)
      @h2{Community Service and Leadership}
      @hr
      @t{▸  Organized RacketCon 2013. Managed audio/visual for RacketCon in 2014, 2015.
         ▸  Local organizer for IFL 2014 conference in Boston.
         ▸  Program committee member for the FOOL 2014 workshop.
         ▸  Artifact evaluation committee member for the OOPSLA 2015 conference.}
      (blank 1 20)
      @h2{Languages, Technologies, and Tools}
      @hr
      @t{▸  Racket, Scheme, Java, C, Haskell
         ▸  Git, Subversion, Vim, Emacs, Linux, Docker, Packer}))

  (send dc start-doc "start")
  (send dc start-page)
  (draw-pict page-1 dc (* (/ 0.5 8.5) width) (* (/ 0.75 11) height))
  (send dc end-page)
  (send dc end-doc))
