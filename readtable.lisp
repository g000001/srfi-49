;;;; readtable.lisp

(cl:in-package :srfi-49.internal)
(in-readtable :common-lisp)

(defreadtable :srfi-49
  (:merge :standard)
  (:dispatch-macro-char #\# #\♦ #'|read-#♦|)
  (:case :upcase))

(defun |read-#♦| (stream char arg)
  (declare (ignore char arg))
  (sugar-read stream))
