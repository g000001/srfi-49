;;;; readtable.lisp

(cl:in-package "https://github.com/g000001/srfi-49")


(in-readtable :common-lisp)


(defun |read-#@| (stream char arg)
  (declare (ignore char arg))
  (sugar-read stream))


(defreadtable :srfi-49
  (:merge :standard)
  (:dispatch-macro-char #\# #\@ #'|read-#@|)
  (:case :upcase))


;;; *EOF*
