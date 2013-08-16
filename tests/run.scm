(use graphviz srfi-13 test)

(test-assert
 "Is the mic on?"
 (not (string-null?
       (with-output-to-string
         (lambda ()
           (write-dot-preamble)
           (write-node 'a '((label . 'not-a)))
           (write-node 'b '((label . 'not-b)))
           (write-edge 'a 'b '((label . 'heisenberg)))
           (write-dot-postscript))))))

(test-exit)
