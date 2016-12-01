all: dfm

dfm: src/dfm.lisp src/package.lisp
	buildapp --output dfm --asdf-tree ~/quicklisp/dists/quicklisp --asdf-path . --load-system dfm --entry dfm:main
