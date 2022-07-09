(ns cv.core
  (:require [quil.core :as q]
            [quil.middleware :as m]))

(defn mm-to-px
  "Convert millimeters to pixels"
  [mm]
  (/ (* mm 72) 25.4))

(defn in-to-mm
  "Convert inches to millimeters"
  [in]
  (* in 25.4))

(defn in-to-px
  "Convert inches to pixels"
  [in]
  (mm-to-px (in-to-mm in)))

(comment
  (let [xs (q/available-fonts)]
    (first (filter #(re-find #"(?i)" %) xs))))


(def a4 {:width (mm-to-px 210)
         :height (mm-to-px 297)})

(def us-paper {:width (in-to-px 8.5)
               :height (in-to-px 11)})

(defn draw! []
  (q/background 255)
  (q/fill 0 255 255)
  (let [angle 3.14
        x (* 150 (q/cos angle))
        y (* 150 (q/sin angle))]
    (q/with-translation [(/ (q/width) 2)
                         (/ (q/height) 2)]
      (q/ellipse x y 100 100)))
  (q/text-mode :shape)
  (q/text-font (q/create-font "Open Sans" 32))
  (q/text-align :left :top)
  (q/text "hello! this is some test text.!" 10 10) ;; Address card
  (q/text-mode :model))
;; reset back to :model if you wanted.  )

(q/sketch
 :draw (fn []
         (q/do-record (q/create-graphics (:width a4) (:height a4) :pdf "out.pdf")
                      (draw!))
         (q/exit)))


(defn -main [& args])
