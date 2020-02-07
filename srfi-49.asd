;;;; srfi-49.asd -*- Mode: Lisp;-*-

(cl:in-package :asdf)


(defsystem :srfi-49
  :version "20200207"
  :description "SRFI 49 for CL: Indentation-sensitive syntax"
  :long-description "SRFI 49 for CL: Indentation-sensitive syntax
https://srfi.schemers.org/srfi-49"
  :author "Egil Möller"
  :maintainer "CHIBA Masaomi"
  :license "Unlicense"
  :serial t
  :depends-on (:fiveam
               :named-readtables)
  :components ((:file "package")
               (:file "readtable")
               (:file "util")
               (:file "srfi-49")
               (:file "test")))


(defmethod perform ((o test-op) (c (eql (find-system :srfi-49))))
  (let ((*package*
         (find-package "https://github.com/g000001/srfi-49")))
    (eval
     (read-from-string
      "
      (or (let ((result (run 'srfi-49)))
            (explain! result)
            (results-status result))
          (error \"test-op failed\") )"))))

;;; *EOF*


