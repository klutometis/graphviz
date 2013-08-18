(use graphviz srfi-13 test)

(test-assert
 "Is the mic on?"
 (not (string-null?
       (with-output-to-string
         (lambda ()
           (write-graph-preamble)
           (write-node 'a '((label . a)))
           (write-node 'b '((label . not-a)))
           (write-edge 'a 'b '((label . heisenberg)))
           (write-graph-postamble))))))

(test-exit)
