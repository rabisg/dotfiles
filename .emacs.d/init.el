;;; init.el --- Basic Configuration file

;;; Commentary:

;;; Code:
;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Set up custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Set up load path
(add-to-list 'load-path user-emacs-directory)

;; Setup packages
(require 'setup-package)

;; Install extensions if they're missing
(defun init--install-packages ()
  (packages-install
   '(flycheck
     haskell-mode
     solarized-theme
     undo-tree
     yaml-mode)
  ))

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

(add-hook 'after-init-hook #'global-flycheck-mode)

;; Set up themes/colors
(require 'appearance)

;; Don't clutter up the tree
(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
    (setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

;; Set up undo-tree
(require 'undo-tree)
(global-undo-tree-mode)
;; (setq undo-tree-auto-save-history 1)

;; Map RET to newline-and-indent
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Load site specific customizations
(eval-after-load 'haskell-mode '(require 'setup-haskell-mode))

(provide 'init)
;;; init.el ends here
