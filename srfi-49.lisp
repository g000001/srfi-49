;;;; srfi-49.lisp

(cl:in-package :srfi-49.internal)
;; (in-readtable :srfi-49)

(def-suite srfi-49)

(in-suite srfi-49)

;;; "srfi-49" goes here. Hacks and glory await!

(define-function sugar-read-save #'cl:read-preserving-whitespace)
(define-function sugar-load-save #'cl:load)

(define-function (readquote level port qt)
  (declare (ignore level))
  (read-char port)
  (let ((char (peek-char nil port nil :eof)))
    (if (or (eql char #\space)
            (eql char #\newline)
            (eql char #\ht))
        (list qt)
        (list qt (sugar-read-save port)))))

(define-function (readitem level port)
  (let ((char (peek-char nil port nil :eof)))
    (cond
      ((eql char #\`)
       (readquote level port 'quasiquote))
      ((eql char #\')
       (readquote level port 'quote))
      ((eql char #\,)
       (readquote level port 'unquote))
      (t
       (sugar-read-save port)))))

(setf (fdefinition 'substring)
      (fdefinition 'subseq))

(define-function (indentation>? indentation1 indentation2)
  (let ((len1 (string-length indentation1))
        (len2 (string-length indentation2)))
    (and (> len1 len2)
         (string=? indentation2 (substring indentation1 0 len2)))))

(defun list->string (list)
  (coerce list 'string))

(define-function (indentationlevel port)
  (labels ((*indentationlevel ()
             (if (or (eql (peek-char nil port nil :eof) #\space)
                     (eql (peek-char nil port nil :eof) #\ht))
                 (cons
                  (read-char port)
                  (*indentationlevel))
               '())))
    (list->string (*indentationlevel))))

(define-function (clean line)
  (cond
    ((not (pair? line))
     line )
    ((null? line)
     line )
    ((eql (car line) :group)
     (cdr line) )
    ((null? (car line))
     (cdr line) )
    ((list? (car line))
     (if (or (equal? (car line) '(quote))
             (equal? (car line) '(quasiquote))
             (equal? (car line) '(unquote)) )
         (if (and (list? (cdr line))
                  (= (length (cdr line)) 1) )
             (cons
              (car (car line))
              (cdr line) )
             (list
              (car (car line))
              (cdr line) ))
         (cons
          (clean (car line))
          (cdr line) )))
    (t
     line )))

  ;; Reads all subblocks of a block
(define-function (readblocks level port)
  (let* ((read (readblock-clean level port))
         (next-level (car read))
         (block (cdr read)))
      (if (string=? next-level level)
	  (let* ((reads (readblocks level port))
		 (next-next-level (car reads))
		 (next-blocks (cdr reads)))
	    (if (eql block '|.| )
		(if (pair? next-blocks)
		    (cons next-next-level (car next-blocks))
		    (cons next-next-level next-blocks))
		(cons next-next-level (cons block next-blocks))))
	  (cons next-level (list block)))))

(defun eof-object? (stream)
  (eq stream :eof))

;; Read one block of input
(define-function (readblock level port)
  (let ((char (peek-char nil port nil :eof)))
    ;; (and (characterp char) (print (char-name char)))
    (cond
      ((eof-object? char)
       (cons -1 char) )
      ((eql char #\newline)
       (read-char port)
       (let ((next-level (indentationlevel port)))
         (if (indentation>? next-level level)
             (readblocks next-level port)
             (cons next-level '()) )))
      ((or (eql char #\space)
           (eql char #\ht) )
       (read-char port)
       (readblock level port) )
      (t
       (let* ((first (readitem level port))
              (rest (readblock level port))
              (level (car rest))
              (block (cdr rest)) )
         (if (eql first '|.|)
             (if (pair? block)
                 (cons level (car block))
                 rest )
             (cons level (cons first block)) ))))))

;; reads a block and handles group, (quote), (unquote) and
;; (quasiquote).
(define-function (readblock-clean level port)
    (let* ((read (readblock level port))
	   (next-level (car read))
	   (block (cdr read)))
      (if (or (not (list? block)) (> (length block) 1))
	  (cons next-level (clean block))
	  (if (= (length block) 1)
	      (cons next-level (car block))
	      (cons next-level '|.|)))))

(define-function (sugar-read . port)
  (let* ((read (readblock-clean "" (if (null? port)
                                       *standard-input*
                                       (car port))))
         (level (car read))
         (block (cdr read)))
    (declare (ignore level))
    (cond
      ((eql block '|.|)
       '())
      (t
       block))))

(define-function (sugar-load filename)
  (with-open-file (port filename)
    (labels ((*load (port)
               (let ((inp (sugar-read port)))
                 (if (eof-object? inp)
                     T
                     (begin
                       (print inp)
                       (eval inp)
                       (*load port) )))))
      (*load port)) ))

#|(define-public (sugar-enable)
   (set! read sugar-read)
   (set! primitive-load sugar-load))|#

#|(define-public (sugar-disable)
    (set! read sugar-read-save)
    (set! primitive-load sugar-load-save))|#

#|(sugar-enable)|#
