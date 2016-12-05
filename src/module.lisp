;;;; module.lisp - module for installing files

(in-package #:dfm)

(defclass module-component ()
  ((action-type
    :initarg :component-type
    :initform :component-type
    :accessor component-type)))

(defgeneric module-component-install (component))

(defgeneric module-component-uninstall (component))

;; (defun module-install (module)
;;   (cond ((eql (component-type module) :install) (module-component-install module))
;; 	((eql (component-type module) :uninstall) (module-component-uninstall module))
;; 	;; TODO: Add error condition.
;; 	(t (format t "Error, unrecognized module type.~%"))))

(defclass module-file (module-component)
  ((filename
    :initarg :filename
    :initform nil
    :accessor filename)
   (start-directory
    :initarg :start-directory
    :initform (make-pathname :defaults (getcwd))
    :accessor start-directory)
   (install-directory
    :initarg :install-directory
    :initform (make-pathname :defaults (user-homedir-pathname))
    :accessor install-directory)
   (remove-on-uninstall
    :initarg :remove-on-uninstall
    :initform nil
    :accessor remove-on-uninstall)))
 
(defmethod module-component-install ((module module-file))
  (if (directory-pathname-p 
  

(defmethod module-component-uninstall ((module module-file))
  (let ((file-path (uiop:merge-pathnames* (filename module)
					  (uiop:ensure-directory-pathname
					   (start-directory module)))))
    (if (uiop:file-exists-p 


(defclass module ()
  ((module-components
    :initarg :module-components
    :initform nil
    :accessor module-components)))

(defun module-install (module)
  (dolist (component (module-components module))
    (when (eql (component-type component) :install)
      (module-component-install component))))
