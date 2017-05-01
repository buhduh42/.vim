#!/bin/bash
#Run from .vim directory
git subtree pull -P bundle/nerdtree https://github.com/scrooloose/nerdtree.git master --squash
git subtree pull -P bundle/vim-go https://github.com/fatih/vim-go.git master --squash
git subtree pull -P bundle/vim-nerdtree-tabs https://github.com/jistr/vim-nerdtree-tabs.git master --squash
git subtree pull -P bundle/vim-glsl https://github.com/tikhomirov/vim-glsl master --squash
