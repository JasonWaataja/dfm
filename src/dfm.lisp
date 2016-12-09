;;;; dfm.lisp - main file for dfm

(in-package #:dfm)

(defclass dfm-options ()
  ((source-directory
    :initarg :source-directory
    :initform (make-pathname :defaults (getcwd))
    :accessor options-source-directory)
   (config-file-name
    :initarg :config-file-name
    :initform nil
    :accessor options-config-file-name)
   (install-module
    :initarg :install-module
    :initform nil
    :accessor options-install-module)
   (uninstall-module
    :initarg :uninstall-module
    :initform nil
    :accessor options-uninstall-module)))

(defparameter *getopt-args* '(("install" :required)
			      ("uninstall" :required)))

(defparameter *config-extension* "dfm")

(defun parse-argv (argv)
  "Parses arguments for dfm. Returns first a dfm-options object with the correct arguments and a
list of the remaining arguments"
  (let ((options (make-instance 'dfm-options)))
    (multiple-value-bind (filtered-argument-list
			  matched-options
			  unmatched-required)
	(getopt:getopt argv *getopt-args*)
      (cond ((not (null unmatched-required))
	     ;; TODO: Add an error condition.
	     (format t "Failed to provide required arguments: ~a~%" unmatched-required)
	     (values nil nil))
	    (t (let ((install-cons (assoc "install" matched-options :test #'string=))
		     (uninstall-cons (assoc "uninstall" matched-options :test #'string=)))
		 (when install-cons
		   (setf (slot-value options 'install-modules) (cdr install-cons)))
		 (when uninstall-cons
		   (setf (slot-value options 'uninstall-modules) (cdr uninstall-cons)))
		 (values options filtered-argument-list)))))))

(defun parent-directory-for-file (file-pathspec)
  (let* ((pathname (make-pathname :defaults file-pathspec))
	 (as-absolute (if (absolute-pathname-p pathname)
			  pathname
			  (merge-pathnames* pathname (getcwd)))))
    (if (file-pathname-p as-absolute)
	(make-pathname :defaults as-absolute
		       :name nil
		       :type nil)
	nil)))

;; (defun config-file-for-path (path)
;;   "Takes a string or pathname and either returns either the file if it's a config file or searches
;; one level of the directory if it's a directory. Otherwise, returns nil."
;;   (let ((as-pathname (pathname path)))
;;     (if (string= (pathname-type path) "dfm")
;; 	(namestring as-pathname)
;; 	(let ((as-directory (directory-exists-p as-pathname)))
;; 	  (if as-directory
;; 	      (let ((with-wild (make-pathname :defaults as-directory
;; 					      :name :wild
;; 					      :type :wild)))
;; 		(loop for dirent in (directory* with-wild)
;; 		   if (string= (pathname-type dirent) *config-extension*)
;; 		   return (values as-directory (namestring dirent))
;; 		   finally (return (values as-directory nil)))))
;; 	  (if (file-exists-p as-pathname)
;; 	      (

(defun config-file-from-options (remaining-args)
    "Parses a list of arguments, probably from parse-argv, and scans the files to get the config
file."
  (config-file-for-path (first remaining-args)))

(defun main (argv)
  "Main function for dfm"
  (parse-argv argv))

