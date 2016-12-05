;;;; files.lisp - utilities for working with files

(in-package #:dfm)

(defun append-file-to-directory (file directory)
  "Takes a file, strips all directory components, and appends it to directory compononent of
directory."
  (if (file-pathname-p file)
      (merge-pathnames* (make-pathname :defaults file
				       :directory '(:relative))
			directory)
      nil))

(defun last-directory-component (directory-pathname)
  (let ((last-element (first (last (pathname-directory directory-pathname)))))
    (if (or (eql last-element :relative) (eql last-element :absolute))
	nil
	last-element)))

(defun copy-directory (source-path dest-path)
  "Copies the directory pointed to by source-path into the path spicified by dest-path."
  (let ((source-directory (directory-exists-p source-path))
	(dest-directory (ensure-directory-pathname dest-path)))
    (cond (source-directory
	   (ensure-directories-exist dest-directory)
	   (dolist (file (directory-files source-directory))
	     (copy-file file (append-file-to-directory file dest-directory)))
	   (dolist (subdirectory (subdirectories source-directory))
	     (copy-directory subdirectory
			     (subpathname dest-directory
					  (last-directory-component subdirectory)
					  :type :directory)))
	   t)
	  ;; TODO: Add error condition.
	  (t (format t "Error: directory doesn't exist or isn't a directory.~%")
	     nil))))


(defun copy-directory-into (source-path dest-path &optional (new-name nil))
  (let ((source-directory (directory-exists-p source-path))
	(dest-directory (ensure-directory-pathname dest-path)))
    (cond (source-path
	   (copy-directory source-directory
			   (subpathname dest-directory
					(if new-name
					    new-name
					    (last-directory-component source-directory))))
	   t)
	  (t
	   ;; TODO: Add error condition.
	   (format t "Error: directory doesn't exist or isn't a directory.~%")
	   nil))))

(defun delete-file-generic (pathspec)
  "Delete pathspec whether it's a regular file or directory"
  (let ((as-directory (uiop:directory-exists-p pathspec)))
    (if as-directory
	(delete-directory-tree as-directory :validate t)
	(delete-file pathspec))))

(defun copy-file-generic (source-pathspec dest-pathspec)
  "Copy pathspec whether it's a regular file or directory. Behavior changes
based on if the file is in file form or directory form."
  (if (directory-pathname-p source-pathspec)
      (copy-directory source-pathspec dest-pathspec)
      (copy-file source-pathspec dest-pathspec)))

(defun copy-file-into-generic (source-pathspec dest-pathspec)
  "Copy pathspec into the given directory. Works on files and directories.
Behavior changes based on if the source-pathspec is in file form or directory
form."
  (if (directory-pathname-p source-pathspec)
      (copy-directory-into source-pathspec dest-pathspec)
      (copy-file source-pathspec (append-file-to-directory source-pathspec
							   dest-pathspec))))
