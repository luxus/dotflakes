;;; init-lang-yaml.el --- YAML language configuration -*- lexical-binding: t; -*-
;;
;; Copyright (c) 2022, Chris Montgomery <chris@cdom.io>
;;
;; Author: Chris Montgomery <https://github.com/montchr>
;; Maintainer: Chris Montgomery <chris@cdom.io>
;; Version: 0.0.1
;; Package-Requires: ((emacs "28.1"))
;;
;; Created: 22 Jul 2022
;;
;; URL: https://github.com/montchr/dotfield/tree/main/users/seadoom/config/emacs/profiles/xtallos
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
;;; Commentary:
;;
;; Configuration for YAML language editing.
;;
;;; Code:

(use-package yaml-mode
  :mode ("\\.yaml\\'" "\\.yml\\'"))

(use-package yaml)
(use-package yaml-pro
  :after yaml)

(provide 'init-lang-yaml)
;;; init-lang-yaml.el ends here
