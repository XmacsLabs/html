(import (liii check))
(load (string-append (system-getenv "TEXMACS_HOME_PATH") "/plugins/html/progs/convert/html/htmltm-test.scm"))

(check (shtml->stm '(h1 "a")) => '(document (chapter* "a")))
(check (shtml->stm '(h2 "a")) => '(document (section* "a")))
(check (shtml->stm '(h3 "a")) => '(document (subsection* "a")))
(check (shtml->stm '(h4 "a")) => '(document (subsubsection* "a")))
(check (shtml->stm '(h5 "a")) => '(document (paragraph* "a")))
(check (shtml->stm '(h6 "a")) => '(document (subparagraph* "a")))

(tm-define (htmltm-test)
  (check-report)
  (display "Test suite of htmltm-test end\n"))
