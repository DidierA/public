syntax on
set tabstop=4
filetype on
set nu
set ruler

" set mouse=a
" displays $ at end of line and tabs as <-->
set list
set listchars=eol:$,tab:<->

" highlight whitespace at end of lines
" (see http://vim.wikia.com/wiki/Highlight_unwanted_spaces )
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
" autocmd InsertLeave * match ExtraWhitespace /\s\+$/
" autocmd BufWinLeave * call clearmatches()

