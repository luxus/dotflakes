;;; init.el --- Main Configuration -*- lexical-binding: t; -*-
;;
;; Copyright (c) 2022, Chris Montgomery <chris@cdom.io>
;;
;; Author: Chris Montgomery <https://github.com/montchr>
;; Maintainer: Chris Montgomery <chris@cdom.io>
;; Version: 0.0.1
;; Package-Requires: ((emacs "28.1"))
;;
;; Created: 05 Feb 2022
;;
;; URL: https://github.com/montchr/dotfield/tree/main/config/emacs
;;
;; License: GPLv3
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see
;; <http://www.gnu.org/licenses/>.
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;; Emacs customizations for Dotfield.
;;
;;; Code:

;;
;;; Initialize

;; Since we might be running in CI or other environments, stick to
;; XDG_CONFIG_HOME value if possible.
(let ((emacs-home (if-let ((xdg (getenv "XDG_CONFIG_HOME")))
                      (expand-file-name "emacs/" xdg)
                    user-emacs-directory)))
  ;; Add Lisp directory to `load-path'.
  (add-to-list 'load-path (expand-file-name "lisp" emacs-home)))

;; Adjust garbage collection thresholds during startup, and thereafter.
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
            (lambda () (setq gc-cons-threshold
                             normal-gc-cons-threshold))))

(setq-default user-full-name "Chris Montgomery"
              user-mail-address "chris@cdom.io")

(setq-default load-prefer-newer t)

;; No beep!
(setq visible-bell t)

;;; Unicode
(set-language-environment   'utf-8)
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system          'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-clipboard-coding-system   'utf-8)
(set-default-coding-systems    'utf-8)
(set-file-name-coding-system   'utf-8)
(set-keyboard-coding-system    'utf-8)
(set-selection-coding-system   'utf-8)
(set-terminal-coding-system    'utf-8)
(setq locale-coding-system     'utf-8)


;;
;;; Bootstrap

(require 'config-path)
(require 'init-elpa)

;; Configure and load the customize file
;; Because sometimes we just need Emacs to write code for us
;; FIXME: rename to the standard `custom.el'
(setq custom-file (concat path-local-dir "custom-settings.el"))

;; Load autoloads file
;; FIXME: does not exist, see d12frosted repo
;; (unless elpa-bootstrap-p
;;   (unless (file-exists-p path-autoloads-file)
;;     (error "Autoloads file doesn't exist!"))
;;   (load path-autoloads-file nil 'nomessage))

;;
;;; Environment

(defconst xtallos/env--graphic-p (display-graphic-p))
(defconst xtallos/env--rootp (string-equal "root" (getenv "USER")))
(defconst xtallos/env-sys-mac-p (eq system-type 'darwin))
(defconst xtallos/env-sys-linux-p (eq system-type 'gnu/linux))
(defconst xtallos/env-sys-name (system-name))
(defconst xtallos/is-darwin xtallos/env-sys-mac-p)
(defconst xtallos/is-linux xtallos/env-sys-linux-p)

(require 'init-exec-path)

;;
;;; Performance

;; Disable an unnecessary second pass over `auto-mode-alist'.
(setq auto-mode-case-fold nil)

;; Disable bidirectional text scanning.
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

;; Disable rendering of cursors or regions in windows other than the
;; window which is currently focused.
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t)

;; Avoid pinging random domain names.
(setq ffap-machine-p-known 'reject)

;; Disable frame resizing when changing font.
(setq frame-inhibit-implied-resize t)

;; Increase chunk size when reading from process output.
(setq read-process-output-max (* 64 1024))  ; 64kb

;; Remove unnecessary OS-specific command-line options while running
;; Emacs in a different OS.
(unless xtallos/is-darwin    (setq command-line-ns-option-alist nil))
(unless xtallos/is-linux     (setq command-line-x-option-alist nil))


;;
;;; Core

(require 'init-keys)
(require 'init-evil)

(require 'init-editor)
(require 'init-ui)
(require 'init-window)
(require 'init-selection)


;;
;;; Utilities

(require 'init-vcs)
(require 'init-ide)


;;
;;; Languages

(require 'init-lang-nix)
(require 'init-lang-yaml)

;;
;;; `dired'

(setq delete-by-moving-to-trash t)

;; Delete intermediate buffers while navigating.
(eval-after-load "dired"
  #'(lambda ()
      (put 'dired-find-alternate-file 'disabled nil)
      (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file)))

;; Load the local customizations file.
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)
;;; init.el ends here
