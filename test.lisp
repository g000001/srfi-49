(cl:in-package "https://github.com/g000001/srfi-49")


(in-readtable :srfi-49)


(def-suite srfi-49)


(in-suite srfi-49)


(test sugar-read
  (is (equal
       '(foo bar baz)
       (progn
         #@
         '
         foo
         bar
         baz

         )))
  (is (= 55
  #@
  labels
   group
    fib (n a1 a2)
     cond
      group
       (zerop n)
       a2
      group
       (= 1 n)
       a1
      group
       T
       group
        fib
        (1- n)
        (+ a1 a2)
        a1
   group
    fib
    10
    1
    0

  )))


;;; *EOF*
