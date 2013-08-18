@(egg "graphviz")
@(description "Some Graphviz abstractions")
@(author "Peter Danenberg")
@(email "pcd@roxygen.org")
@(username "klutometis")
@(noop)

(define default-width
  @("Default width for graphs")
  (make-parameter 1600))

(define default-height
  @("Default width for graphs")
  (make-parameter 900))

(define default-font-size
  @("Default font-size for graphs")
  (make-parameter 48.0))

(define (px->in px) (/ px 96))

(define (in->dot in) (* in 72))

(define linear-scale (make-parameter (in->dot 5)))

(define default-node-attributes
  @("Default node attributes"
    (@example-no-eval
     (default-node-attributes '((font . monospace)))))
  (make-parameter '()))

(define default-edge-attributes
  @("Default edge attributes"
    (@example-no-eval
     (default-edge-attributes '((dir . none)))))
  (make-parameter '()))

(define default-graph-attributes
  @("Default graph attributes"
    (@example-no-eval
     (default-graph-attributes '((splines . true)))))
  (make-parameter '()))

(define (attributes->string attributes)
  (string-join
   (map (match-lambda ((key . value) (format "~a=\"~a\"" key value))) attributes)
   ","))

;;; Height and width are in pixels.
(define write-graph-preamble
  @("Write a graph preamble."
    (graph-attributes "Attributes of the graph")
    (width "Width in pixels")
    (height "Height in pixels")
    (font-size "Font-size in pt")
    (@example-no-eval
     (write-graph-preamble '((splines-true)))
     (write-node a '((label . "Big bang")))
     (write-node b '((label . "Today")))
     (write-edge a b '((label . "Entropy gradient")))
     (write-graph-postamble)))
  (case-lambda
   (()
    (write-graph-preamble '()))
   ((graph-attributes)
    (write-graph-preamble graph-attributes
                          (default-width)
                          (default-height)
                          (default-font-size)))
   ((graph-attributes width height font-size)
    (display "digraph G {")
    (unless (null? graph-attributes)
      (format #t "graph [~a];"
              (attributes->string graph-attributes)))
    (unless (null? (default-graph-attributes))
      (format #t "graph [~a];"
              (attributes->string (default-graph-attributes))))
    (unless (null? (default-node-attributes))
      (format #t "node [~a];"
              (attributes->string (default-node-attributes))))
    (unless (null? (default-edge-attributes))
      (format #t "edge [~a];"
              (attributes->string (default-edge-attributes))))
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

(define (pos x y)
  @("For placing nodes at specific positions in a unit graph using the {{pos}}
 attribute, apply a linear scaling."
    (x "The x position")
    (y "The y position"))
  (format "~a,~a"
          (* x (linear-scale))
          (* y (linear-scale))))

(define write-node
  @("Write a node"
    (label "The node's label")
    (attributes "Attributes of the node"))
  (case-lambda
   ((label) (write-node label '()))
   ((label attributes)
    (format #t "~a [~a];"
            label
            (attributes->string attributes)))))

(define write-edge
  @("Write an edge"
    (whence "The label whence")
    (whither "The lable whither")
    (attributes "Attributes of the edge"))
  (case-lambda
   ((whence whither)
    (write-edge whence whither '()))
   ((whence whither attributes)
      (format #t "~a -> ~a [~a];"
          whence
          whither
          (attributes->string attributes)))))
