;;;; dfm.lisp

(in-package #:dfm)

(defclass dfm-options ()
  ((start-directory
    :initarg :start-directory
    :initform (make-pathname :defaults (user-homedir-pathname))
    :accessor start-directory)
  (config-file
   :initarg :config-file
   :initform nil
   :accessor config-file)))

(defparameter *getopt-args* '(("directory" :required)
			      ("config-file" :required)))

(defun parse-argv (argv)
  (let ((options (make-instance 'dfm-options)))
    (multiple-value-bind (filtered-argument-list
			  matched-options
			  unmatched-required)
	(getopt:getopt argv *getopt-args*)
      (cond ((not (null unmatched-required))
	     ;; TODO: Add an error condition.
	     (format t "Failed to provide required arguments: ~a~%" unmatched-required)
	     (values nil nil))
	    (t (let ((directory-cons (assoc "directory" matched-options :test #'string=))
		     (config-file-cons (assoc "config-file" matched-options :test #'string=)))
		 (when directory-cons
		   (setf (slot-value options 'start-directory) (cdr directory-cons)))
		 (when config-file-cons
		   (setf (slot-value options 'config-file) (cdr config-file-cons)))
		 (values options filtered-argument-list)))))))

(defun main (argv)
  "Main function for dfm"
  (parse-argv argv))

