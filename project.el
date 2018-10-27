(setq bb-project nil)

;; enable the different peojcts
(defun proj-ppa()(interactive)(setq bb-project "proj-ppa"))
(defun proj-cpluspus()(interactive) (setq bb-project "proj-cplusplus"))
(defun proj-seq-common()(interactive) (setq bb-project "proj-seq-common"))
(defun proj-basecaller()(interactive) (setq bb-project "proj-basecaller"))
(defun proj-basewriter()(interactive) (setq bb-project "proj-basewriter"))
(defun proj-acquisition()(interactive) (setq bb-project "proj-acquisition"))

;; helper functions
(defun pb-base-dir ()(locate-dominating-file default-directory ".git"))
(defun proj-match (name) (when (pb-base-dir) (string= name bb-project)))

;; Gets our appropriate build dirs, regardless of which repo we're in
(defun ppa-deb-dir () (concat (pb-base-dir) "Sequel/ppa/build/x86_64/Debug_gcc"))
(defun ppa-rel-dir () (concat (pb-base-dir) "Sequel/ppa/build/x86_64/Release_gcc"))
(defun cc-rel-dir  () (concat (pb-base-dir) "common/pacbio-cplusplus-api/build/x86_64/Release_gcc"))
(defun cc-deb-dir  () (concat (pb-base-dir) "common/pacbio-cplusplus-api/build/x86_64/Debug_gcc"))
(defun common-rel-dir  () (concat (pb-base-dir) "Sequel/common/build/x86_64/Release_gcc"))
(defun common-deb-dir  () (concat (pb-base-dir) "Sequel/common/build/x86_64/Debug_gcc"))
(defun basecaller-deb-dir () (concat (pb-base-dir) "Sequel/basecaller/build/x86_64_gcc/Debug"))
(defun basecaller-rel-dir () (concat (pb-base-dir) "Sequel/basecaller/build/x86_64_gcc/Release"))
(defun basewriter-deb-dir () (concat (pb-base-dir) "Sequel/basewriter/build/x86_64/Debug_gcc"))
(defun basewriter-rel-dir () (concat (pb-base-dir) "Sequel/basewriter/build/x86_64/Release_gcc"))
(defun acquisition-deb-dir () (concat (pb-base-dir) "Sequel/acquisition/build/x86_64/Debug_gcc"))
(defun acquisition-rel-dir () (concat (pb-base-dir) "Sequel/acquisition/build/x86_64/Release_gcc"))

(global-set-key (kbd "C-S-p") 'multi-compile-run)
(setq multi-compile-alist '(
    ((proj-match "proj-ppa") . 
         (("ReleaseBuild" "make -j12" (ppa-rel-dir))
          ("DebugBuild" "make -j12" (ppa-deb-dir))
          ("RunDebug" "make test" (ppa-deb-dir))
          ("RunRelease" "make test" (ppa-rel-dir))
          ("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J ." (ppa-deb-dir)))
    )
    ((proj-match "proj-cplusplus") . 
         (("ReleaseBuild" "make -j12" (cc-rel-dir))
          ("DebugBuild" "make -j12" (cc-deb-dir))
          ("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J ." (cc-deb-dir)))
    )
    ((proj-match "proj-seq-common") . 
         (("DebugBuild" "make -j12" (common-deb-dir))
          ("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J ." (common-deb-dir)))
    )
    ((proj-match "proj-basecaller") . 
         (("DebugBuild" "make -j12" (basecaller-deb-dir))
          ("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J ." (basecaller-deb-dir)))
    )
    ((proj-match "proj-basewriter") . 
         (("DebugBuild" "make -j12" (basewriter-deb-dir))
          ("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J ." (basewriter-deb-dir)))
    )
    ((proj-match "proj-acquisition") . 
         (("DebugBuild" "make -j12" (acquisition-deb-dir))
          ("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J ." (acquisition-deb-dir)))
    )
))

