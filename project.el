(require 'multi-compile)

(defun git-base-dir ()(locate-dominating-file default-directory ".git"))

(setq proj-debug t)
(setq proj-arch "gcc")
(setq proj-host "localhost")
(setq proj-subproj nil)

(defun proj-localhost()(interactive) (setq proj-host "localhost"))
(defun proj-dev00()(interactive) (setq proj-host "pa-dev00"))
(defun proj-dev01()(interactive) (setq proj-host "pa-dev01"))
(defun proj-arch-gcc ()(interactive) (setq proj-arch "gcc"))
(defun proj-arch-icc ()(interactive) (setq proj-arch "icc"))
(defun proj-arch-avx ()(interactive) (setq proj-arch "avx512"))
(defun proj-arch-k1om ()(interactive)(setq proj-arch "k1om"))
(defun proj-debug()(interactive) (setq proj-debug t))
(defun proj-release()(interactive) (setq proj-debug nil))

(defun proj-generic-build-dirs (proj arch debug)
    (setq baseDir (git-base-dir))
    (setq relDir (concat proj "/"))
    (cond ((and (string= arch "gcc") debug)       (setq archDir "build/x86_64/Debug_gcc"))
          ((and (string= arch "icc") debug)       (setq archDir "build/x86_64/Debug"))
          ((and (string= arch "icc") (not debug)) (setq archDir "build/x86_64/Release"))
	  (t                                      (setq archDir "invalid-build-arch"))
    )
    (when (file-directory-p (concat baseDir relDir)) 
          (setq return (concat baseDir relDir archDir)))
)
(defun proj-ppa-build-dir (arch debug) (proj-generic-build-dirs "Sequel/ppa" arch debug))
(defun proj-acq-build-dir (arch debug) (proj-generic-build-dirs "Sequel/acquisition" arch debug))
(defun proj-bw-build-dir (arch debug) (proj-generic-build-dirs "Sequel/basewriter" arch debug))
(defun proj-cc-build-dir (arch debug) (proj-generic-build-dirs "Sequel/common" arch debug))
(defun proj-cplusplus-build-dir (arch debug) (proj-generic-build-dirs "common/pacbio-cplusplus-api" arch debug))
(defun proj-bc-build-dir (arch debug)
    (setq baseDir (git-base-dir))
    (setq relDir "Sequel/basecaller/")
    (cond ((string= arch "gcc")    (setq archDir "build/x86_64_gcc/"))
          ((string= arch "icc")    (setq archDir "build/x86_64/"))
          ((string= arch "avx512") (setq archDir "build/avx512/"))
          ((string= arch "k1om")   (setq archDir "build/k1om/"))
	  (t                       (setq archDir "invalid-arch"))
    )
    (if debug (setq buildDir "Debug") (setq buildDir "Release"))
    (when (file-directory-p (concat baseDir relDir)) 
          (setq return (concat baseDir relDir archDir buildDir)))
)

(defun proj-shapeshift-build-dir (arch debug)
    (setq baseDir (git-base-dir))
    (if debug (setq buildDir "build/Debug") (setq buildDir "build/Release"))
    (message (concat baseDir buildDir))
    (when (file-directory-p (concat baseDir buildDir)) 
          (setq return (concat baseDir buildDir)))
)

(defun proj-ppa()        (interactive) (setq proj-subproj "PPA")(fset 'proj-build-dir 'proj-ppa-build-dir))
(defun proj-cpluspus()   (interactive) (setq proj-subproj "CPlusPlusAPI")(fset 'proj-build-dir 'proj-cplusplus-build-dir))
(defun proj-seq-common() (interactive) (setq proj-subproj "Common")(fset 'proj-build-dir 'proj-cc-build-dir))
(defun proj-basecaller() (interactive) (setq proj-subproj "Basecaller")(fset 'proj-build-dir 'proj-bc-build-dir))
(defun proj-basewriter() (interactive) (setq proj-subproj "Basewriter")(fset 'proj-build-dir 'proj-bw-build-dir))
(defun proj-acquisition()(interactive) (setq proj-subproj "Acquisition")(fset 'proj-build-dir 'proj-acq-build-dir))

(defun proj-shapeshift() (interactive) (setq proj-subproj "ShapeShift")(fset 'proj-build-dir 'proj-shapeshift-build-dir))

(setq lasterror nil)
(defun proj-valid()(interactive)
    (setq valid t)
    (setq lasterror nil)
    (unless (proj-build-dir proj-arch proj-debug) (setq valid nil))
    (unless (or valid lasterror)(setq lasterror "Something wrong with project build directory"))
    (if (string= proj-subproj "ShapeShift")
        (progn   ;; Personal targets
            (unless (string= proj-host "localhost") (setq valid nil))
            (unless (or valid lasterror)(setq lasterror "ShapeShifter only compiles locally"))
            (unless (string= proj-arch "gcc") (setq valid nil))
            (unless (or valid lasterror)(setq lasterror "ShapeShifter only uses gcc"))
        )
        (progn   ;; Normal primary targets
            ;; Only gcc allowed locally
            ( when (and (not (string= proj-arch "gcc"))(string= "localhost" proj-host))
                (setq valid nil)
            )
            ( unless (or valid lasterror) (setq lasterror "Must use gcc on localhost"))
            ( unless (string= proj-subproj "Basecaller")
                (when (or (string= proj-arch "k1om")(string= proj-arch "avx512")) (setq valid nil))
                (unless (or valid lasterror) (setq lasterror "Only basecaller can use this arch"))
                (when (and (string= proj-arch "gcc")(not proj-debug )) (setq valid nil))
                (unless (or valid lasterror)(setq lasterror "Only basecaller can use Release and gcc"))
            )
        )
    )
    valid
)

(setq proj-compile-args nil)
(defun proj-compile-args(arg)(interactive (list (read-string "Compile Args: " proj-compile-args))) 
    (if (string= arg "")
       (setq proj-compile-args nil)
       (setq proj-compile-args arg)
    )
)
(setq proj-run-args nil)
(defun proj-run-args(arg)(interactive (list (read-string "Run Command: " proj-run-args))) 
    (if (string= arg "")
       (setq proj-run-args nil)
       (setq proj-run-args arg)
    )
)

(defun proj-host-build()
  (concat "ssh " proj-host " 'cd "
	  (proj-build-dir proj-arch proj-debug) "\; "
	  (git-base-dir) "sync_and_build.sh " proj-compile-args"'")
)
(defun proj-host-clean()
  (concat "ssh " proj-host " 'cd "
	  (proj-build-dir proj-arch proj-debug) "\; make clean'")
)
(defun proj-host-cleanbuild()
  (concat "ssh " proj-host " 'cd "
	  (proj-build-dir proj-arch proj-debug)
	  "\; make clean\; " (git-base-dir)
	  "sync_and_build.sh " proj-compile-args"'")
)
(defun proj-host-run()
  (if (not proj-run-args)
      (print "No run command specified")
      (concat "ssh " proj-host " 'cd "
	  (proj-build-dir proj-arch proj-debug) "\; "
	  proj-run-args "'")
  )
)

(defun proj-build()
  (concat "make -j8 " proj-compile-args)
)
(defun proj-clean()
  (concat "make clean")
)
(defun proj-cleanbuild()
  (concat "make clean\; make -j8" proj-compile-args)
)
(defun proj-run()
  (if (not proj-run-args)
      (print "No build target specified")
       proj-run-args
  )
)

(setq multi-compile-alist '(
    ((proj-valid) .
	(("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J . --project-root=$(pwd); rc -w $(pwd)" (proj-build-dir "gcc" t)))
    )
    ((and (proj-valid)(string= proj-host "localhost")) .
	(("Build" proj-build (proj-build-dir proj-arch proj-debug))
	 ("Clean" proj-clean (proj-build-dir proj-arch proj-debug))
	 ("CleanBuild" proj-cleanbuild (proj-build-dir proj-arch proj-debug))
         ("Run" proj-run (proj-build-dir proj-arch proj-debug)))
    )
    ((and (proj-valid) (not (string= proj-host "localhost"))) .
	(("Build" . proj-host-build)
	 ("Clean" . proj-host-clean)
	 ("CleanBuild" . proj-host-cleanbuild)
         ("Run" . proj-host-run))
    )
))

(defun proj-curr-build-dir ()(interactive) (print (proj-build-dir proj-arch proj-debug)))
(defun proj-info ()(interactive) (
	print (concat "Host: " (if proj-host proj-host "localhost")
		      "\n Project: " proj-subproj
		      "\n Type: " proj-arch
		      " " (if proj-debug "Debug" "Release")
		      "\n BuildDir: " (proj-build-dir proj-arch proj-debug)
		      (when proj-compile-args (concat "\n Compile Args: " proj-compile-args))
		      (when proj-run-args (concat "\n Run Command: " proj-run-args))
                      (if (proj-valid) "\nValid Setup" "\nINVALID Setup")
                      (when lasterror (concat "\nError: " lasterror))
)))

(setq proj-bad-config nil)
(defun proj-compile-private()
       (unless (proj-valid) (setq proj-bad-config "Invalid project configuration.  Check directory and 'proj-info'")(throw 'proj-bad-config t))
       (multi-compile-run)
)

(defun proj-compile()(interactive)
       (save-some-buffers)
       (when (catch 'proj-bad-config (proj-compile-private)) (print proj-bad-config))
)

(global-set-key (kbd "C-S-p") 'proj-compile)

(proj-ppa)
(proj-dev01)
(proj-arch-gcc)
(proj-release)

(require 'widget)
     
(eval-when-compile
   (require 'wid-edit))

(defun proj-configure()
    "Create the widgets from the Widget manual."
    (interactive)
    (setq silly default-directory)
    (switch-to-buffer "*Project Configuration*")
    (let ((inhibit-read-only t))
        (erase-buffer))
    (remove-overlays)
    (setq default-directory silly)
    (widget-insert "Setup primary build configurations.\n\n")
    (widget-insert "Project:\n")
    (widget-create 'radio-button-choice
        :value proj-subproj
        :follow-link "\C-m"
        :notify (lambda (widget &rest ignore)
		    (cond ((string= (widget-value widget) "PPA") (proj-ppa))
			  ((string= (widget-value widget) "Basecaller") (proj-basecaller))
			  ((string= (widget-value widget) "Basewriter") (proj-basewriter))
			  ((string= (widget-value widget) "Acquisition") (proj-acquisition))
			  ((string= (widget-value widget) "CPlusPlusAPI") (proj-cpluspus))
			  ((string= (widget-value widget) "Common") (proj-seq-common))
			  ( t (message "No Match")))
		    (proj-info)
		)
        '(item "PPA" )
        '(item "Basecaller")
        '(item "Basewriter")
        '(item "Acquisition")
        '(item "CPlusPlusAPI")
        '(item "Common"))
    (widget-insert "\n")
    (widget-insert "Compiler:\n")
    (widget-create 'radio-button-choice
        :value proj-arch
        :notify (lambda (widget &rest ignore)
		    (cond ((string= (widget-value widget) "gcc") (proj-arch-gcc))
			  ((string= (widget-value widget) "icc") (proj-arch-icc))
			  ((string= (widget-value widget) "avx512") (proj-arch-avx))
			  ((string= (widget-value widget) "k1om") (proj-arch-k1om))
			  ( t (message "No Match")))
		    (proj-info)
		)
        '(item "gcc" )
        '(item "icc")
        '(item "avx512")
        '(item "k1om"))
    (widget-insert "\n")
    (widget-insert "Type:\n")
    (widget-create 'radio-button-choice
        :value (if proj-debug "Debug" "Release")
        :notify (lambda (widget &rest ignore)
		    (cond ((string= (widget-value widget) "Release") (proj-release))
			  ((string= (widget-value widget) "Debug") (proj-debug))
			  ( t (message "No Match")))
		    (proj-info)
		)
        '(item "Release" )
        '(item "Debug"))
    (widget-insert "\n")
    (widget-insert "Host:\n")
    (widget-create 'radio-button-choice
        :value proj-host
        :notify (lambda (widget &rest ignore)
		    (cond ((string= (widget-value widget) "localhost") (proj-localhost))
			  ((string= (widget-value widget) "pa-dev00") (proj-dev00))
			  ((string= (widget-value widget) "pa-dev01") (proj-dev01))
			  ( t (message "No Match")))
		    (proj-info)
		)
        '(item "localhost" )
        '(item "pa-dev00")
        '(item "pa-dev01"))
    (widget-insert "\n")
    (widget-create 'push-button
        :notify (lambda (widget &rest ignore)
                  (kill-buffer-and-window))
                  
        "Finished")
    (widget-setup)
    (goto-char 0)
)

