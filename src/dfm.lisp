;;;; dfm.lisp

(in-package #:dfm)

(defclass dfm-options ()
  ((start-directory
    :initarg :start-directory
    :initform (make-pathname :defaults (user-homedir-pathname))
    :accessor start-directory))
  (config-file
   :initarg :config-file
   :initform nil
   :accessor config-file))

(defparameter *getopt-args* '(("directory" :required)
			      ("config-file" :required)))

(defun parse-argv (argv)
  (loop
     with current-argument-list = (copy-list argv)
     with matched-arguments = nil
     with unmatched-required = nil
     with options = (make-instance 'dfm-options)
     do
       (setf current-argument-list
	     (getopt:getopt current-argument-list *getopt-args*))
     if (not (null unmatched-required))
     do
       ;; TODO: Add an error condition.
       (format t "Unmatched arguments: ~a~%" unmatched-required)
       (return nil)
     else
     if (null matched-arguments) return options
     end
     else do
       
       

(defun main (argv)
  "Main function for dfm"
  (format t "~a~%" argv))

