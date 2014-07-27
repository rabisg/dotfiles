(setq exec-path (cons (expand-file-name "~/.gem/ruby/2.0.0/bin") exec-path))
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
