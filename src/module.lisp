;;;; module.lisp - module for installing files

(in-package #:dfm)

(defclass module-component ()
  ((action-type
    :initarg :component-type
    :initform :component-type
    :accessor component-type)))

(defgeneric module-component-install (component))

(defgeneric module-component-uninstall (component))

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

;; (defmethod initialize-instance :after ((module module-file) &key)
;; 	   (

(defun module-file-source-path (module)
  (append-file-to-directory (filename module)
			    (start-directory module)))

(defun module-file-destination-path (module)
  (append-file-to-directory (filename module)
			    (install-directory module)))
 
(defmethod module-component-install ((module module-file))
  (copy-file-into-generic (module-file-source-path module)
			  (install-directory module)))
  

(defmethod module-component-uninstall ((module module-file))
  (when (remove-on-uninstall module)
    (delete-file-generic (module-file-destination-path module))))

(defclass module ()
  ((module-name
    :initarg :module-name
    :initform "Generic Module"
    :accessor module-name)
   (module-components
    :initarg :module-components
    :initform nil
    :accessor module-components)))

(defun module-install (module)
  (dolist (component (module-components module))
    (when (eql (component-type component) :install)
      (module-component-install component))))
