(use-package plantuml-mode
  :mode "\\.plantuml\\'"
  :init
  (setq plantuml-java-args (list "-Djava.awt.headless=true" "-jar") ;; somehow related to java-8 I think
        plantuml-jar-path (concat no-littering-etc-directory "plantuml.jar")
        plantuml-default-exec-mode 'jar
        plantuml-indent-level 4))

(provide 'k-plantuml)
