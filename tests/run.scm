(use graphviz srfi-13 test)

(test-assert
 "Is the mic on?"
 (not (string-null? (with-output-to-string write-dot-preamble))))
