Installation instructions only relevant for pathogen

Install pathogen from: https://github.com/tpope/vim-pathogen

mv clean_json $HOME/.vim/bundle

Add the following to your .vimrc
let mapleader = " "
nnoremap <silent> <leader>j :normal ggVG<CR>:<c-u>call clean_json#CleanJSON()<CR>
vnoremap <silent> <leader>j :<c-u>call clean_json#CleanJSON()<CR>

Tested on Mac, probably works for any *nix
