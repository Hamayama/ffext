;;
;; testing ffext
;;

(add-load-path "." :relative)
(use gauche.test)
(use file.util)

(test-start "ffext")
(use ffext)
(test-module 'ffext)

(cond-expand
 (gauche.os.windows
  ;; overwite find-file-in-paths
  (define (find-file-in-paths name :key paths pred)
    (apply find-file-in-paths-ext
           name
           :ext '("" "exe")
           (cond-list
            ((not (undefined? paths)) @ `(:paths ,paths))
            ((not (undefined? pred))  @ `(:pred  ,pred))
            ))))
 (else))

(define (testA name expected expr :optional (check test-check))
  (test* name expected expr check)
  (print "  " expr))

(test-section "find-file-in-paths-ext")
(testA "1" "<string> or #f" (find-file-in-paths-ext "calc.exe")
       (lambda (e r) (or (string? r) (eq? r #f))))
(testA "2" "<string> or #f" (find-file-in-paths-ext "notepad" :ext "exe")
       (lambda (e r) (or (string? r) (eq? r #f))))
(testA "3" "<string> or #f" (find-file-in-paths-ext "more" :ext '("" "exe" "com"))
       (lambda (e r) (or (string? r) (eq? r #f))))

(test-section "overwrite find-file-in-paths")
(testA "1" "<string> or #f" (find-file-in-paths "calc.exe")
       (lambda (e r) (or (string? r) (eq? r #f))))
(testA "2" "<string> or #f" (find-file-in-paths "notepad")
       (lambda (e r) (or (string? r) (eq? r #f))))
(testA "3" "<string> or #f" (find-file-in-paths "more")
       (lambda (e r) (or (string? r) (eq? r #f))))

(test-end)

