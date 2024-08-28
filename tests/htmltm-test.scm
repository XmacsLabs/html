
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : htmltm-test.scm
;; DESCRIPTION : Test suite for htmltm
;; COPYRIGHT   : (C) 2002  David Allouche
;;                   2024  Darcy Shen
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(import (liii check))

(texmacs-module (convert html htmltm-test)
  (:use (convert html htmltm) (convert tools xmltm)
        (convert tools sxml) (convert tools sxhtml)))

(define (sxml-postorder t proc)
  (let sub ((t t))
    (cond ((string? t) t)
          ((sxml-top-node? t) (sxml-set-content t (map sub (sxml-content t))))
          ((sxml-control-node? t) t)
          (else (proc (sxml-set-content t (map sub (sxml-content t))))))))

(define (shtml->sxhtml t)
  (sxml-postorder t (cut sxml-set-ns-prefix "h" <>)))

(define (shtml->stm t)
  (htmltm-as-serial `(*TOP* ,(shtml->sxhtml t))))


(define (regtest-htmltm-headings)
  (check (shtml->stm '(h1 "a")) => '(document (chapter* "a")))
  (check (shtml->stm '(h2 "a")) => '(document (section* "a")))
  (check (shtml->stm '(h3 "a")) => '(document (subsection* "a")))
  (check (shtml->stm '(h4 "a")) => '(document (subsubsection* "a")))
  (check (shtml->stm '(h5 "a")) => '(document (paragraph* "a")))
  (check (shtml->stm '(h6 "a")) => '(document (subparagraph* "a"))))

(define (regtest-htmltm-grouping)
  (check (shtml->stm '(div "a")) => '(document "a"))
  (check (shtml->stm '(span "a")) => "a"))


(tm-define (htmltm-test)
  (regtest-htmltm-headings)
  (regtest-htmltm-grouping)
  (check-report)
  (display "Test suite of htmltm-test end\n"))
