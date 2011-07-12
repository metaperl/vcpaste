;;; vcpastebin.el --- A simple interface to the vcpaste.pl paste program

;;; Copyright (C) 2011 by Terrence Brannon <metaperl@gmail.com>
;;; Thanks to the authors of scpaste and pastebin.el
;;; This code is derived from theirs.

;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2, or (at your option)
;;; any later version.

;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.

;;; You should have received a copy of the GNU General Public License
;;; along with this program; see the file COPYING.  If not, write to the
;;; Free Software Foundation, Inc.,   51 Franklin Street, Fifth Floor,
;;; Boston, MA  02110-1301  USA

;;; Commentary:
;;;
;;; Before this emacs code is useable, you must install and configure
;;; vcpaste.pl 
;;; Load this file and run:
;;;
;;;   M-x vcpaste-buffer
;;;
;;; to send the whole buffer or select a region and run
;;;
;;;  M-x vcpaste
;;;
;;; to send just the region.
;;;
;;; In either case the url that vcpaste.pl generates is left on the kill
;;; ring and the paste buffer.

;;; Code:

;;;###autoload
(defgroup vcpaste nil
  "Vcpaste -- vcpaste.com client"
  :tag "Vcpaste"
  :group 'tools)

(defcustom vcpaste-default-domain "vcpaste.com"
  "Vcpaste domain to use by default"
  :type 'string
  :group 'vcpaste
  )

(setq vcpaste-command "c:/Users/thequietcenter/prg/vcpaste/bin/vcpaste.pl")


;;;###autoload
(defun vcpaste (original-name)
 "Paste the current buffer via vcpaste.pl"
  (interactive "MName (defaults to buffer name): ")
  (let* ((b (current-buffer))
         (name (url-hexify-string (if (equal "" original-name)
                                      (buffer-name)
                                    original-name)))
         (tmp-file (concat temporary-file-directory "/" name)))

    ;; Save the file (while adding footer)
    (save-excursion
      (switch-to-buffer b)
      (write-file tmp-file)
      (kill-buffer b)
      (shell-command (concat "perl " vcpaste-command " " tmp-file))
      )
    

    ))


