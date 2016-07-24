;; -*- coding: utf-8 -*-
;;
;; ffext.scm
;; 2016-7-24 v1.00
;;
;; ＜内容＞
;;   Gauche で、find-file-in-paths 手続きに拡張子の指定を追加した
;;   find-file-in-paths-ext 手続きを使用可能にするためのモジュールです。
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

;; 拡張子の指定を追加したファイル検索
;;   使用例
;;     (find-file-in-paths-ext "notepad" :ext "exe")
;;     (find-file-in-paths-ext "more" :ext '("" "exe" "com"))
(define (find-file-in-paths-ext name :key paths pred (ext ""))
  (let ((args1 (cond-list
                ((not (undefined? paths)) @ `(:paths ,paths))
                ((not (undefined? pred))  @ `(:pred  ,pred))))
        (exts  (map x->string (if (list? ext) ext (list ext)))))
    (any
     (lambda (ext1)
       (apply find-file-in-paths
              (cons (if (equal? ext1 "") name (string-append name "." ext1))
                    args1)))
     exts)))
