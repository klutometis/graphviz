@(egg "graphviz")
@(description "Some Graphviz abstractions")
@(author "Peter Danenberg")
@(email "pcd@roxygen.org")
@(username "klutometis")

(define default-width (make-parameter 1600))

(define default-height (make-parameter 900))

(define default-font-size (make-parameter 48.0))

(define default-title (make-parameter #f))

(define (px->in px) (/ px 96))

(define (in->dot in) (* in 72))

(define linear-scale (make-parameter (in->dot 5)))

;;; Height and width are in pixels.
(define write-dot-preamble
  @("Write a dot preamble."
    (width "Width in pixels")
    (height "Height in pixels")
    (font-size "Font-size in pt")
    (title "Title of the graph"))
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

(define (write-dot-postscript)
  @("Write the dot postscript")
  (display "}"))

(define (write-node label x y)
  @("Write a node"
    (label "The node's label")
    (x "The x-coordinate of the node")
    (y "The y-coordinate of the node"))
  (format #t "~a [pos=\"~a,~a\"];"
          label
          (* x (linear-scale))
          (* y (linear-scale))))

(define (write-edge whence whither)
  @("Write an edge"
    (whence "The label whence")
    (whither "The lable whither"))
  (format #t "~a -> ~a;"
          whence
          whither))
