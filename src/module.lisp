;;;; module.lisp - module for installing files

(in-package #:dfm)

(defclass module-component ()
  ((is-install-component
    :initarg is-install-component
    :initform nil
    :accessor is-install-component)
   (is-uninstall-component
    :initarg :is-install-component
    :initform nil
    :accessor is-uninstall-component)))

(defgeneric module-component-install-action (component))

(defgeneric module-component-uninstall-action (component))

(defun module-component-install (component)
  (when (is-install-component component)
    (module-component-install-action component)))

(defun module-component-uninstall (component)
  (when (is-uninstall-component component)
    (module-component-uninstall-action component)))

(defclass file-module-component (module-component)
  ((filename
    :initarg :filename
    :initform nil
    :accessor file-module-component-filename)
   (file-source-directory
    :initarg :file-source-directory
    :initform (make-pathname :defaults (getcwd))
    :accessor file-source-directory)
   (file-destination-directory
    :initarg :file-destination-directory
    :initform (make-pathname :defaults (user-homedir-pathname))
    :accessor file-destination-directory)
   (remove-on-uninstall
    :initarg :remove-on-uninstall
    :initform nil
    :accessor remove-on-uninstall)))

(defun file-module-component-file-path (component)
  (append-file-to-directory (file-module-component-filename component)
			    (file-source-directory component)))

(defun file-module-component-destination-path (component)
  (append-file-to-directory (file-module-component-filename component)
			    (file-destination-directory component)))

(defmethod module-component-install-action ((component file-module-component))
  (copy-file-into-generic (file-module-component-file-path component)
			  (file-destination-directory component)))

(defmethod module-component-uninstall-action ((component file-module-component))
  (when (remove-on-uninstall component)
    (delete-file-generic (file-module-component-destination-path component))))

(defclass module ()
  ((module-name
    :initarg :module-name
    :initform "Generic Module"
    :accessor module-name)
   (module-components
    :initarg :module-components
    :initform nil
    :accessor module-components)))

(defun install-module (module)
  (loop for component in (module-components module)
     when (is-install-component component) do
       (module-install-action component)))

(defun uninstall-module (module)
  (loop for component in (module-components module)
     when (is-uninstall-component component) do
       (module-uninstall-action component)))
