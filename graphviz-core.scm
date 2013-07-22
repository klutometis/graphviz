(define default-width (make-parameter 1600))

(define default-height (make-parameter 900))

(define default-font-size (make-parameter 48.0))

(define default-title (make-parameter #f))

(define (px->in px) (/ px 96))

(define (in->dot in) (* in 72))

(define linear-scale (make-parameter (in->dot 5)))

;;; Height and width are in pixels.
(define write-dot-preamble
  (case-lambda
   (()
    (write-dot-preamble (default-width)
                        (default-height)
                        (default-font-size)
                        (default-title)))
   ((width height font-size title)
    (display "digraph G {")
    (display "node [style=filled, fontname=monospace];")
    (display "edge [fontname=monospace];")
    (if (and width height)
        (begin
          (format #t "graph [fontsize=~a, ratio=fill];" font-size)
          ;; Phew: viewports are specified in points at 72 per inch;
          ;; size is specified in pixels at 96 per inch.
          (let ((width-in-inches (px->in width))
                (height-in-inches (px->in height)))
            (format #t "graph [viewport=\"~a,~a\", size=\"~a,~a!\"];"
                    (in->dot width-in-inches)
                    (in->dot height-in-inches)
                    width-in-inches
                    height-in-inches)))))))

(define (write-dot-postscript) (display "}"))

(define (write-node label x y)
  (format #t "~a [pos=\"~a,~a\"];"
          label
          (* x (linear-scale))
          (* y (linear-scale))))

(define (write-edge whence whither)
  (format #t "~a -> ~a;"
          whence
          whither))
