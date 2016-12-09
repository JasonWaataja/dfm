;;;; package.lisp

(defpackage #:dfm
  (:use #:cl)
  (:import-from #:uiop
		#:merge-pathnames*
		#:subpathname
		#:getcwd
		#:directory*
		#:directory-exists-p
		#:directory-pathname-p
		#:file-pathname-p
		#:ensure-directory-pathname
		#:directory-files
		#:subdirectories
		#:copy-file
		#:file-exists-p
		#:probe-file*
		#:delete-directory-tree
		#:absolute-pathname-p
		#:file-pathname-p)
  (:export #:main
	   #:config-file-for-path
	   #:config-file-from-options
	   #:copy-directory-into
	   #:delete-file-generic
	   #:append-file-to-directory
	   #:copy-directory
	   #:copy-directory-into
	   #:last-directory-component
	   #:copy-file-generic
	   #:delete-file-generic
	   #:copy-file-into-generic
	   #:parent-directory-for-file))

