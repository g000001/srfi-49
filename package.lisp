;;;; package.lisp

(cl:in-package :cl-user)

(defpackage :srfi-49
  (:use)
  (:export))

(defpackage :srfi-49.internal
  (:use :srfi-49 :cl :named-readtables :fiveam)
    (:shadow :map :lambda :loop :member :assoc))
