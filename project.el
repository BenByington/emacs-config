(require 'multi-compile)

;;(defun git-base-dir ()(locate-dominating-file default-directory ".git"))

(setq proj-debug t)
(setq proj-arch "gcc")
(setq proj-host "localhost")
(setq proj-subproj nil)
(setq proj-root nil)
(setq proj-build-system "make")

(defun proj-localhost()(interactive) (setq proj-host "localhost"))
(defun proj-dev00()(interactive) (setq proj-host "rt-dev01"))
(defun proj-dev01()(interactive) (setq proj-host "pa-dev01"))
(defun proj-gpu()(interactive) (setq proj-host "rt-gpudev"))
(defun proj-gpu2()(interactive) (setq proj-host "rt-gpudev02"))
(defun proj-gpuA100()(interactive) (setq proj-host "kestrel-primary-poc"))
(defun proj-arch-gcc ()(interactive) (setq proj-arch "gcc"))
(defun proj-arch-icc ()(interactive) (setq proj-arch "icc"))
(defun proj-arch-avx ()(interactive) (setq proj-arch "avx512"))
(defun proj-arch-k1om ()(interactive)(setq proj-arch "k1om"))
(defun proj-debug()(interactive) (setq proj-debug t))
(defun proj-release()(interactive) (setq proj-debug nil))

(defun proj-generic-build-dirs (proj arch debug)
    (setq baseDir proj-root)
    (setq relDir (concat proj "/"))
    (cond ((and (string= arch "gcc") debug)       (setq archDir "build/x86_64/Debug_gcc"))
          ((and (string= arch "icc") debug)       (setq archDir "build/x86_64/Debug"))
          ((and (string= arch "icc") (not debug)) (setq archDir "build/x86_64/Release"))
	  (t                                      (setq archDir "invalid-build-arch"))
    )
    (when (file-directory-p (concat baseDir relDir)) 
          (setq return (concat baseDir relDir archDir)))
)
(defun proj-generic-build-dirs2 (proj arch debug)
    (setq baseDir proj-root)
    (setq relDir (concat proj "/"))
    (cond ((string= arch "gcc") (setq archDir "build/x86_64_gcc/"))
          ((string= arch "icc") (setq archDir "build/x86_64/"))
          (t                    (setq archDir "invalid-build-arch/"))
    )
    (cond (debug (setq buildDir "Debug"))
          (t     (setq buildDir "Release"))
    )
    (when (file-directory-p (concat baseDir relDir)) 
          (setq return (concat baseDir relDir archDir buildDir)))
)
(defun proj-generic-build-dirs-new (proj arch debug)
    (setq baseDir proj-root)
    (setq relDir (concat "build/" proj "/"))
    (cond ((string= arch "gcc")    (setq archDir "gcc/x86_64/"))
          ((string= arch "icc")    (setq archDir "icc/x86_64/"))
          ((string= arch "avx512") (setq archDir "icc/avx512/"))
          (t                       (setq archDir "invalid-build-arch/"))
    )
    (cond (debug (setq buildDir "Debug"))
          (t     (setq buildDir "Release"))
    )
    (when (file-directory-p (concat baseDir relDir)) 
          (setq return (concat baseDir relDir archDir buildDir)))
)
(defun proj-web-build-dir (arch debug) (proj-generic-build-dirs "Sequel/webservices" arch debug))
(defun proj-ppa-build-dir (arch debug) (proj-generic-build-dirs2 "Sequel/postprimary" arch debug))
(defun proj-acq-build-dir (arch debug) (proj-generic-build-dirs2 "Sequel/acquisition" arch debug))
(defun proj-bw-build-dir (arch debug) (proj-generic-build-dirs "Sequel/basewriter" arch debug))
(defun proj-cc-build-dir (arch debug) (proj-generic-build-dirs "Sequel/common" arch debug))
(defun proj-cplusplus-build-dir (arch debug) (proj-generic-build-dirs "" arch debug))
(defun proj-hwmongo-build-dir (arch debug) (proj-generic-build-dirs-new "hw-mongo" arch debug))
(defun proj-bc-build-dir (arch debug)
    (setq baseDir proj-root)
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
(defun proj-mongo-build-dir (arch debug) (proj-generic-build-dirs-new "basecaller" arch debug))
(defun proj-calib-build-dir (arch debug) (proj-generic-build-dirs-new "pa-cal" arch debug))
(defun proj-pawnee-build-dir (arch debug) (proj-generic-build-dirs-new "pawnee" arch debug))

(defun proj-shapeshift-build-dir (arch debug)
    (setq baseDir proj-root)
    (if debug (setq buildDir "build/Debug") (setq buildDir "build/Release"))
    (message (concat baseDir buildDir))
    (when (file-directory-p (concat baseDir buildDir)) 
          (setq return (concat baseDir buildDir)))
)

(defun lsp-restart-workspace-quiet ()
  (--when-let (pcase (lsp-workspaces)
                (`(,workspace) workspace))
    (lsp--warn "Restarting %s" (lsp--workspace-print it))
    (setf (lsp--workspace-shutdown-action it) 'restart)
    (with-lsp-workspace it (lsp--shutdown-workspace))))


(defun proj-update-parse-proj() 
    (setq cacheDir (expand-file-name (concat "~/.cache/ccls/" proj-subproj)))
    (setq commandDir (file-relative-name (proj-build-dir "gcc" t) proj-root))
    (setq buildDir (proj-build-dir "gcc" t))
    (setq lsp-clients-clangd-args `("-log=info" , 
                                   (concat "--compile-commands-dir=" (expand-file-name buildDir))   
                                   "--all-scopes-completion"
                                   "--completion-style=detailed"
                                   "--header-insertion=never"
                                   "--recovery-ast"
                                   "--suggest-missing-includes"
                                   "--pch-storage=memory"
                                   "--pretty"
                                   "-j=4"
    ))
    (lsp-restart-workspace-quiet)
)

(setq web-hist nil)
(setq ppa-hist nil)
(setq seq-common-hist nil)
(setq basecaller-hist nil)
(setq basewriter-hist nil)
(setq acquisition-hist nil)
(setq cplusplus-hist nil)
(setq hwmongo-hist nil)
(setq mongo-hist nil)
(setq pawnee-hist nil)
(setq calib-hist nil)
(setq shapeshift-hist nil)

(require 'savehist)
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'web-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'ppa-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'seq-common-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'basecaller-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'basewriter-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'acquisition-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'cplusplus-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'hw-mongo-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'mongo-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'pawnee-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'calib-hist))
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'shapeshift-hist))

(savehist-mode 1)

(setq warning-suppress-log-types (list))
(add-to-list 'warning-suppress-log-types '(defvaralias losing-value run-hist))

(defun proj-web()         (interactive)(setq proj-root "~/primary/")            (setq proj-build-system "make")  (setq proj-subproj "Webservices") (fset 'proj-build-dir 'proj-web-build-dir)       (defvaralias 'run-hist 'web-hist)         (proj-run-args (car run-hist)) (proj-update-parse-proj))
(defun proj-ppa()         (interactive)(setq proj-root "~/primary/")            (setq proj-build-system "make")  (setq proj-subproj "PPA" )        (fset 'proj-build-dir 'proj-ppa-build-dir)       (defvaralias 'run-hist 'ppa-hist)         (proj-run-args (car run-hist)) (proj-update-parse-proj))
(defun proj-seq-common()  (interactive)(setq proj-root "~/primary/")            (setq proj-build-system "make")  (setq proj-subproj "Common")      (fset 'proj-build-dir 'proj-cc-build-dir)        (defvaralias 'run-hist 'seq-common-hist)  (proj-run-args (car run-hist)) (proj-update-parse-proj))
(defun proj-basecaller()  (interactive)(setq proj-root "~/primary/")            (setq proj-build-system "make")  (setq proj-subproj "Basecaller")  (fset 'proj-build-dir 'proj-bc-build-dir)        (defvaralias 'run-hist 'basecaller-hist)  (proj-run-args (car run-hist)) (proj-update-parse-proj))
(defun proj-basewriter()  (interactive)(setq proj-root "~/primary/")            (setq proj-build-system "make")  (setq proj-subproj "Basewriter")  (fset 'proj-build-dir 'proj-bw-build-dir)        (defvaralias 'run-hist 'basewriter-hist)  (proj-run-args (car run-hist)) (proj-update-parse-proj))
(defun proj-acquisition() (interactive)(setq proj-root "~/primary/")            (setq proj-build-system "make")  (setq proj-subproj "Acquisition") (fset 'proj-build-dir 'proj-acq-build-dir)       (defvaralias 'run-hist 'acquisition-hist) (proj-run-args (car run-hist)) (proj-update-parse-proj))
(defun proj-cpluspus()    (interactive)(setq proj-root "~/pa-kestrel/pa-common/") (setq proj-build-system "ninja")  (setq proj-subproj "CPlusPlusAPI")(fset 'proj-build-dir 'proj-cplusplus-build-dir) (defvaralias 'run-hist 'cplusplus-hist)   (proj-run-args (car run-hist)) (proj-update-parse-proj))
(defun proj-hwmongo()     (interactive)(setq proj-root "~/pa-kestrel/hw-mongo/")  (setq proj-build-system "ninja") (setq proj-subproj "HwMongo")(fset 'proj-build-dir 'proj-hwmongo-build-dir) (defvaralias 'run-hist 'hw-mongo-hist)   (proj-run-args (car run-hist)) (proj-update-parse-proj))
(defun proj-mongo()       (interactive)(setq proj-root "~/pa-kestrel/")         (setq proj-build-system "ninja") (setq proj-subproj "Mongo")       (fset 'proj-build-dir 'proj-mongo-build-dir)     (defvaralias 'run-hist 'mongo-hist)       (proj-run-args (car run-hist)) (proj-update-parse-proj))
(defun proj-pawnee()      (interactive)(setq proj-root "~/pawnee/")             (setq proj-build-system "ninja") (setq proj-subproj "Pawnee")       (fset 'proj-build-dir 'proj-pawnee-build-dir)     (defvaralias 'run-hist 'pawnee-hist)       (proj-run-args (car run-hist)) (proj-update-parse-proj))
(defun proj-calib()       (interactive)(setq proj-root "~/pa-kestrel/")         (setq proj-build-system "ninja") (setq proj-subproj "Calib")       (fset 'proj-build-dir 'proj-calib-build-dir)     (defvaralias 'run-hist 'calib-hist)       (proj-run-args (car run-hist)) (proj-update-parse-proj))
                                                                                                                                                 
(defun proj-shapeshift() (interactive) (setq proj-root "~/Shapeshifter")        (setq proj-build-system "make")  (setq proj-subproj "ShapeShift")  (fset 'proj-build-dir 'proj-shapeshift-build-dir)(defvaralias 'run-hist 'shapeshift-hist)  (proj-run-args (car run-hist)) (proj-update-parse-proj))

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
(defun proj-run-args(arg)(interactive (list (ivy-read "Run Command: " run-hist :history 'run-hist :preselect 0))) 
;;(defun proj-run-args(arg)(interactive (list (ivy-read "Run Command: " run-hist :history 'run-hist :preselect 0 :update-fn 'ivy-insert-current))) 
    (if (string= arg "")
       (setq proj-run-args nil)
       (setq proj-run-args arg)
    )
)

(defun build-cmd()
    (if (string= proj-build-system "make")
        (setq return "make -j8")
        (setq return "CLICOLOR_FORCE=1 ninja -j8")
    )
)

(defun clean-cmd()
    (if (string= proj-build-system "make")
        (setq return "make clean")
        (setq return "CLICOLOR_FORCE=1 ninja clean")
    )
)

(defun proj-host-build()
  (concat "ssh -t " proj-host " 'cd "
	  (proj-build-dir proj-arch proj-debug) "\; "
	  proj-root "sync_and_build.sh " proj-compile-args"'")
)
(defun proj-host-clean()
  (concat "ssh -t " proj-host " 'cd "
	  (proj-build-dir proj-arch proj-debug) "\; " (clean-cmd)"'")
)
(defun proj-host-cleanbuild()
  (concat "ssh -t " proj-host " 'cd "
	  (proj-build-dir proj-arch proj-debug)
	  "\; " (clean-cmd) "\; " proj-root
	  "sync_and_build.sh " proj-compile-args"'")
)
(defun proj-host-run()
  (if (not proj-run-args)
      (print "No run command specified")
      (concat "ssh -t " proj-host " 'cd "
	  (proj-build-dir proj-arch proj-debug) "\; "
	  proj-run-args "'")
  )
)

(defun proj-build()
  (concat (build-cmd) " " proj-compile-args)
)
(defun proj-clean()
  (concat (clean-cmd))
)
(defun proj-cleanbuild()
  (concat (clean-cmd) "\; " (build-cmd) " " proj-compile-args)
)
(defun proj-run()
  (if (not proj-run-args)
      (print "No build target specified")
       proj-run-args
  )
)

(setq refresh nil)
(setq multi-compile-alist '(
    ((proj-valid) .
                          ;; The sed command is necessary because while clang can parse cuda code, some of the options are 
                          ;; different compared to nvcc.  `-x cu` needs to be `-x cuda`, and `-G` seems to cause
                          ;; parsing to fail
	(("RefreshIndex" generate-compile-commands-str (progn (setq refresh t) (proj-build-dir "gcc" t))))
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
       (when refresh (lsp-restart-workspace-quiet) (setq refresh nil))
)

(defun proj-compile()(interactive)
       (save-some-buffers)
       (when (catch 'proj-bad-config (proj-compile-private)) (print proj-bad-config))
)

(global-set-key (kbd "C-S-p") 'proj-compile)

;;(proj-ppa)
;;(proj-dev01)
;;(proj-arch-gcc)
;;(proj-release)

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
			  ((string= (widget-value widget) "Mongo") (proj-mongo))
			  ((string= (widget-value widget) "Pawnee") (proj-pawnee))
			  ((string= (widget-value widget) "Calib") (proj-calib))
			  ((string= (widget-value widget) "Basecaller") (proj-basecaller))
			  ((string= (widget-value widget) "Basewriter") (proj-basewriter))
			  ((string= (widget-value widget) "Acquisition") (proj-acquisition))
			  ((string= (widget-value widget) "Webservices") (proj-web))
			  ((string= (widget-value widget) "CPlusPlusAPI") (proj-cpluspus))
			  ((string= (widget-value widget) "HwMongo") (proj-hwmongo))
			  ((string= (widget-value widget) "Common") (proj-seq-common))
			  ( t (message "No Match")))
		    (proj-info)
		)
        '(item "PPA" )
        '(item "Mongo" )
        '(item "Pawnee" )
        '(item "Basecaller")
        '(item "Basewriter")
        '(item "Acquisition")
        '(item "Webservices")
        '(item "CPlusPlusAPI")
        '(item "HwMongo")
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
			  ((string= (widget-value widget) "rt-gpudev") (proj-gpu))
			  ((string= (widget-value widget) "rt-gpudev02") (proj-gpu2))
			  ( t (message "No Match")))
		    (proj-info)
		)
        '(item "localhost" )
        '(item "pa-dev00")
        '(item "pa-dev01")
        '(item "rt-gpudev")
        '(item "rt-gpudev02"))
    (widget-insert "\n")
    (widget-create 'push-button
        :notify (lambda (widget &rest ignore)
                  (kill-buffer-and-window))
                  
        "Finished")
    (widget-setup)
    (goto-char 0)
)

