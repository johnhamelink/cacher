;;; .dir-config.el --- Directory config -*- no-byte-compile: t; lexical-binding: t; -*-

(defun jjh/build-swagg-local-url (file)
  "Build a file:// prefixed FILE URL for a local file relative to `project-root'."
  (format "file://%s"
          (expand-file-name
           (format "%s/%s"
                   (project-root (project-current))
                   file))))

(defconst jjh/bondio/api-key "AAAAAAAAAAAAAAA"
  "API key used to authenticate with Bondio.")

(defun jjh/bondio/build-auth-header ()
  "Build an API header value for Bondio Core API."
  `("Authorization" . ,(format "Bearer %s" jjh/bondio/api-key)))

(setq swagg-auto-accept-bound-values t
      swagg-display-headers t
      swagg-definitions
      `((:name "Core"
               :yaml ,(jjh/build-swagg-local-url "doc/API/Core.yaml")
               :base "https://api.bondio.co"
               :header (("Accept" . "application/json")
                        ,(jjh/bondio/build-auth-header))
               )))

;; Use our ts-node wrapper script to build a REPL
(setq js-comint-program-command "ts-node"
      js-comint-program-arguments '()
      jest-arguments '("--bail" "--colors" "--coverage" "--verbose"))
