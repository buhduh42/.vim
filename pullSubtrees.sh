#!/bin/bash
#Run from .vim directory
repos=(\
  https://github.com/scrooloose/nerdtree.git \
  https://github.com/fatih/vim-go.git \
  https://github.com/jistr/vim-nerdtree-tabs.git \
  https://github.com/tikhomirov/vim-glsl \
  https://github.com/rust-lang/rust.vim.git \
  https://github.com/saltstack/salt-vim.git \
  https://github.com/racer-rust/vim-racer.git \
  https://github.com/martinda/Jenkinsfile-vim-syntax.git \
  https://github.com/kien/ctrlp.vim.git \
  https://github.com/jeetsukumaran/vim-indentwise.git \
  git@github.com:mattn/webapi-vim.git \
  https://github.com/leafgarland/typescript-vim.git \
)
for repo in ${repos[@]}; do
  dir=$(echo -n ${repo%.*} | rev | cut -d'/' -f1 - | rev)
  if ! test -e bundle/${dir}; then
    git subtree add -P bundle/${dir} ${repo} master --squash
  else
    git subtree pull -P bundle/${dir} ${repo} master --squash
  fi
done
