execute pathogen#infect()
syntax on
filetype plugin indent on
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set mouse=a
set nohls
set modeline

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
