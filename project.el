
(setq bb-project nil)
(defun ppa-proj()(interactive)(setq bb-project "ppa-proj"))
(defun cplusplus-proj()(interactive) (setq bb-project "cplusplus-proj"))

(defun proj-match (name) (string= name bb-project))

(setq ppa-rel-dir "~/primary/Sequel/ppa/build/x86_64/Release_gcc")
(setq ppa-deb-dir "~/primary/Sequel/ppa/build/x86_64/Debug_gcc")
(setq cc-rel-dir "~/primary/common/pacbio-cplusplus-api/build/x86_64/Release_gcc")
(setq cc-deb-dir "~/primary/common/pacbio-cplusplus-api/build/x86_64/Debug_gcc")

(global-set-key (kbd "C-S-p") 'multi-compile-run)
(setq multi-compile-alist '(
    ((proj-match "ppa-proj") . (("ReleaseBuild" "make -j12" ppa-rel-dir)
                 ("DebugBuild" "make -j12" ppa-deb-dir)
                 ("RunDebug" "make test" ppa-deb-dir)
                 ("RunRelease" "make test" ppa-rel-dir)
                 ("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J ." ppa-deb-dir)))
    ((proj-match "cplusplus-proj") . (("ReleaseBuild" "make -j12" cc-rel-dir)
                      ("DebugBuild" "make -j12" cc-deb-dir)
                      ("RunDebug" "make test" cc-deb-dir)
                      ("RunRelease" "make test" cc-rel-dir)
                      ("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J ." cc-deb-dir))
    )
))

