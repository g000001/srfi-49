;;;; readtable.lisp

(cl:in-package :srfi-49.internal)
(in-readtable :common-lisp)

(defun |read-#@| (stream char arg)
  (declare (ignore char arg))
  (sugar-read stream))

(defreadtable :srfi-49
  (:merge :standard)
  (:dispatch-macro-char #\# #\@ #'|read-#@|)
  (:case :upcase))
