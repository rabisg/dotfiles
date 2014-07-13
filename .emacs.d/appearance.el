;; Highlight current line
(global-hl-line-mode 1)

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

;; Set custom theme path
(setq custom-theme-directory (concat user-emacs-directory "themes"))

(defun use-default-theme ()
  (interactive)
  (load-theme 'solarized-dark))

(add-hook 'after-init-hook 'use-default-theme)

(provide 'appearance)
