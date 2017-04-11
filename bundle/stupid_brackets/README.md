Stupid Brackets
--------------

A simple vim plugin that moves the cursor to complimentary key word blocks
commonly employed in Ruby. Will match an "end" to one of the following:
["def", "module", "do", "class", "while", "if"]
Intended to function similarily to "%" for brackets.

Installation
--------------

1. Requires vim to be compiled with python, verify with:
   vim --version | grep "+python"
2. Requires pathogen: clone from https://github.com/tpope/vim-pathogen
3. Unzip the folder this README comes in and:
  mv stupid_brackets ~/.vim/bundle
4. Add the following lines to your ~/.vimrc file:
  let mapleader = ","
  map <silent> <leader>s :call stupid_brackets#MatchitRuby()<CR>
5. Reload Vim

Useage
--------------

The above installation steps will map the plugin to the key sequence: ",s" in
normal mode. Put the cursor on an applicable keyword
"def", "module", "do", "class", "while", "if", or "end" and press ",s".
The cursor will move to the matching keyword.

Issues
--------------

1. Relies on pretty basic regex, therefore don't be too clever with variable
names or symbols(:aSymbol)
2. Overly complex strings with too many escaped quote characters and applicable
keywords will likely cause this plugin to freak out.
3. Ruby has a very complex grammar, short of writing a legitimate parser for
Ruby, I would not trust this plugin with very large complex blocks.  In other
words, don't be too fancy and this should work fine.
4. No heredoc support.


Planned
--------------

1. Integrated Vim help.
2. Highlighting for complimentary closing tokens.
3. Heredoc support.
4. %() syntax support.
5. Visual mode support.
