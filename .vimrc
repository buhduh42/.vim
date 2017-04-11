syntax on
set ignorecase
set smartcase
set backspace=indent,eol,start
set number
set shiftwidth=2
set tabstop=2
set expandtab
set smarttab
set ruler
set smartindent

execute pathogen#infect()
"map <C-n> :NERDTreeToggle<CR>
map <C-n> <plug>NERDTreeTabsToggle<CR>
map <silent> <leader>c :!clear<CR>

let mapleader = " "

"Was having trouble getting the grouped or ()|() regex working
"though it did work directly...
nmap <silent> <leader>f :g/^func.\+($/:normal V%$%zf<CR><leader>of
nmap <silent> <leader>of :g/^func.\+{$/:normal $V%zf<CR><leader>cf
nmap <silent> <leader>cf :g/^const ($/:normal V%zf<CR><leader>if
nmap <silent> <leader>if :g/^import ($/:normal V%zf<CR><leader>sf
nnoremap <silent> <leader>sf :g/^type.\+{$/:normal V%zf<CR>

nnoremap <silent> <leader>j :normal ggVG<CR>:<c-u>call clean_json#CleanJSON()<CR>
vnoremap <silent> <leader>j :<c-u>call clean_json#CleanJSON()<CR>
