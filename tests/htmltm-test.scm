
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
  (:use (convert html htmltm)
        (convert data xmltm)
        (convert data sxml)
        (convert data sxhtml)))

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

(define (regtest-htmltm-quote)
  (check (shtml->stm '(p "`hello`")) => '(document "\x00;hello\x00;"))
  (check (shtml->stm '(p "‘hello’")) => '(document "`hello<#2019>"))
  (check (shtml->stm '(a (@ (href "%60hello%20world%60")) "`how are you?`"))
         => '(hlink "\x00;how are you?\x00;" "%60hello%20world%60")))

(define (regtest-htmltm-formatting)
  (check (shtml->stm '(b "test")) => '(with "font-series" "bold" "test"))
  (check (shtml->stm '(em "test")) => '(em "test"))
  (check (shtml->stm '(i "test")) => '(with "font-shape" "italic" "test"))
  (check (shtml->stm '(small "test")) => '(with "font-size" "0.83" "test"))
  (check (shtml->stm '(strong "test")) => '(strong "test"))
  (check (shtml->stm '("test" (sub "sub"))) => '(rsub "sub"))
  (check (shtml->stm '("test" (sup "sup"))) => '(rsup "sup")))

(tm-define (htmltm-test)
  (regtest-htmltm-headings)
  (regtest-htmltm-grouping)
  (regtest-htmltm-quote)
  (regtest-htmltm-formatting)
  (check-report))
