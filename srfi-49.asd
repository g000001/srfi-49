;;;; srfi-49.asd -*- Mode: Lisp;-*-

(cl:in-package :asdf)

(defsystem :srfi-49
  :serial t
  :depends-on (:fiveam
               :named-readtables)
  :components ((:file "package")
               (:file "readtable")
               (:file "util")
               (:file "srfi-49")
               (:file "test")))

(defmethod perform ((o test-op) (c (eql (find-system :srfi-49))))
  (load-system :srfi-49)
  (or (flet ((_ (pkg sym)
               (intern (symbol-name sym) (find-package pkg))))
         (let ((result (funcall (_ :fiveam :run) (_ :srfi-49.internal :srfi-49))))
           (funcall (_ :fiveam :explain!) result)
           (funcall (_ :fiveam :results-status) result)))
      (error "test-op failed") ))
