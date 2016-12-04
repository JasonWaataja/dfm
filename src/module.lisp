;;;; module.lisp - module for installing files

(in-package #:dfm)

(defclass module-action ())

(defgeneric module-action-perform (action))

(defclass install-file ()
  ((filename
    :initarg :filename
    :initform nil
    :accessor filename)
   (start-directory
    :initarg :start-directory
    :initform (make-pathname :defaults (uiop:getcwd))
    :accessor start-directory)
   (install-directory
    :initarg install-directory
    :initform (make-pathname :defaults (user-homedir-pathname))
    :accessor install-directory)))

(defmethod module-action-perform ((action install-file))
  (let ((start-file-path (uiop:merge-pathnames* (filename action)
						(uiop:ensure-directory-pathname
						 (start-directory action))))
	(end-file-path (uiop:merge-pathnames* (filename action)
					      (uiop:ensure-directory-pathname
					       (install-directory action)))))
    ;; TODO: Add error checking.
    (uiop:copy-file start-file-path end-file-path)))


;; (defclass module ()
;;   (
