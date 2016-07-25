;; -*- coding: utf-8 -*-
;;
;; ffext.scm
;; 2016-7-25 v1.03
;;
;; ＜内容＞
;;   Gauche で find-file-in-paths 手続きを拡張した
;;   find-file-in-paths-ext 手続きを使用可能にするためのモジュールです。
;;
;;   find-file-in-paths-ext 手続きは、ファイルの拡張子を複数指定して検索が行えます。
;;
;;   詳細については、以下のページを参照ください。
;;   https://github.com/Hamayama/ffext
;;
(define-module ffext
  (use file.util)
  (export
    find-file-in-paths-ext
    ))
(select-module ffext)

;; ファイルの拡張子を複数指定可能としたファイル検索
;;   使用例
;;     (find-file-in-paths-ext "notepad" :ext "exe")
;;     (find-file-in-paths-ext "more" :ext '("" "exe" "com"))
(define (find-file-in-paths-ext name :key paths pred (ext "") (dot "."))
  (let ((args1  (cond-list
                 ((not (undefined? paths)) @ `(:paths ,paths))
                 ((not (undefined? pred))  @ `(:pred  ,pred))))
        (exts   (map x->string (if (list? ext) ext (list ext))))
        (dot-st (x->string dot)))
    (any
     (lambda (ext1)
       (apply find-file-in-paths
              (cons (if (equal? ext1 "") name (string-append name dot-st ext1))
                    args1)))
     exts)))

