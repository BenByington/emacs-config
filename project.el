(global-set-key (kbd "C-S-p") 'multi-compile-run)
(setq multi-compile-alist '(
    (c++-mode . (("ReleaseBuild" "make -j12" build-release-dir)
                 ("DebugBuild" "make -j12" build-debug-dir)
                 ("RunDebug" "make test" build-debug-dir)
                 ("RefreshIndex" "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .; rc -J ." build-debug-dir))
)))

