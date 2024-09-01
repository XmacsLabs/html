;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : font-size-test.scm
;; DESCRIPTION : Test suite for tmhtml-with-font-size
;; COPYRIGHT   : (C) 2024  ATQlove
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; (use-modules (convert html tmhtml))
(load (string-append (system-getenv "TEXMACS_HOME_PATH") "/plugins/html/progs/convert/html/tmhtml.scm"))
(import (liii check))

;; Mock environment for testing
(define tmhtml-env (make-ahash-table))

;; Mock tmhtml function for testing
(define (tmhtml arg) arg)

;; Test tmhtml-with-font-size with different font sizes
(define (test-font-size)
  ;; Setting a base font size in the environment
  (ahash-set! tmhtml-env :font-base-size "10")

  ;; Test case 1: target font size is equal to base font size
  (check 
    (tmhtml-with-font-size "10" '("This is a test")) 
    => '((h:span (@ (style "font-size: 100.0%;")) "This is a test")))

  ;; Test case 2: target font size is smaller than base font size
  (check 
    (tmhtml-with-font-size "5" '("This is a test")) 
    => '((h:span (@ (style "font-size: 50.0%;")) "This is a test")))

  ;; Test case 3: target font size is larger than base font size
  (check 
    (tmhtml-with-font-size "12" '("This is a test")) 
    => '((h:span (@ (style "font-size: 120.0%;")) "This is a test")))
)

;; Run all font size tests
(tm-define (font-size-test)
  (test-font-size)
  (check-report))
