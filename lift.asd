(defpackage #:lift-system (:use #:common-lisp #:asdf))
(in-package #:lift-system)

(defsystem lift
  :version "1.7.0"
  :author "Gary Warren King <gwking@metabang.com>"
  :maintainer "Gary Warren King <gwking@metabang.com>"
  :licence "MIT Style License; see file COPYING for details"
  :description "LIsp Framework for Testing"
  :long-description "LIFT is an SUnit variant and much much more."  
  :components ((:module
		"timeout"
		:pathname "timeout/"
		:components 
		((:file "package")
		 (:file "with-timeout" :depends-on ("package"))))
	       (:module 
		"setup"
		:pathname "dev/"
		:depends-on ("timeout")
		:components
		((:file "packages")
		 (:file "utilities" 
			:depends-on ("packages" "macros"))
		 (:file "macros"
			:depends-on ("packages"))
		 (:file "definitions"
			:depends-on ("packages"))
		 (:file "class-defs"
			:depends-on ("definitions"))))
	       (:module 
		"api"
		:pathname "dev/"
		:depends-on ("setup")
		:components ((:file "generics")))
	       (:module 
		"dev" 
		:depends-on ("setup" "api")
		:components 
		((:static-file "notes.text")
		 (:file "lift"
			:depends-on ("measuring" "port"))
		 (:file "copy-file"
			:depends-on ())
		 (:file "random-testing" 
			:depends-on ("lift"))
		 (:file "port" 
			:depends-on ())
		 (:file "measuring" 
			:depends-on ("port"))
		 (:file "config" 
			:depends-on ("port" "lift"))
		 (:file "reports" 
			:depends-on ("port" "lift" "copy-file"))
		 (:file "introspection" 
			:depends-on ("lift"))
		 (:file "test-runner" 
			:depends-on ("lift"))
		 #+allegro
		 (:file "periodic-profiling"
			;; what I'd like to say
			#+no :depends-on #+no ((:feature :allegro)))
		  #+Ignore
		 (:file "prototypes"
			:depends-on ("lift")))))
  
  :in-order-to ((test-op (load-op lift-test)))
  :depends-on ()
  :perform (test-op :after (op c)
		    (funcall
		      (intern (symbol-name '#:run-tests) :lift)
		      :config :generic)))

(defmethod operation-done-p 
           ((o test-op) (c (eql (find-system 'lift))))
  (values nil))
