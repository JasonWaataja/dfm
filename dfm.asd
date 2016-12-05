;;;; dfm.asd

(asdf:defsystem #:dfm
  :description "The Common Lisp version of Dot File Manager"
  :author "Jason Waataja <jasonswaataja@gmail.com>"
  :license "MIT"
  :depends-on (#:uiop #:getopt)
  :components ((:module "src"
			:serial t
			:components ((:file "package")
				     (:file "dfm")
				     (:file "module")))))
