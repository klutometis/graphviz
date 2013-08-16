@(egg "graphviz")
@(description "Some Graphviz abstractions")
@(author "Peter Danenberg")
@(email "pcd@roxygen.org")
@(username "klutometis")
@(noop)

(define default-width (make-parameter 1600))

(define default-height (make-parameter 900))

(define default-font-size (make-parameter 48.0))

(define default-title (make-parameter #f))

(define (px->in px) (/ px 96))

(define (in->dot in) (* in 72))

(define linear-scale (make-parameter (in->dot 5)))

(define default-node-attributes (make-parameter '()))

(define default-edge-attributes (make-parameter '()))

(define default-graph-attributes (make-parameter '()))

(define (attributes->string attributes)
  (string-join
   (map (match-lambda ((key . value) (format "~a=\"~a\"" key value))) attributes)
   ","))

;;; Height and width are in pixels.
(define write-dot-preamble
  @("Write a dot preamble."
    (width "Width in pixels")
    (height "Height in pixels")
    (font-size "Font-size in pt"))
  (case-lambda
   (()
    (write-dot-preamble (default-width)
                        (default-height)
                        (default-font-size)))
   ((width height font-size)
    (display "digraph G {")
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
  (format "~a,~a"
          (* x (linear-scale))
          (* y (linear-scale))))

(define write-node
  @("Write a node"
    (label "The node's label")
    (attributes "Other attributes of the node"))
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
    (attributes "Other attributes of the edge"))
  (case-lambda
   ((whence whither)
    (write-edge whence whither '()))
   ((whence whither attributes)
      (format #t "~a -> ~a [~a];"
          whence
          whither
          (attributes->string attributes)))))
