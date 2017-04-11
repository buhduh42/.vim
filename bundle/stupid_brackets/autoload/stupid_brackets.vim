if !has('python')
  finish
endif

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/stupid_brackets.py'
function! stupid_brackets#MatchitRuby()
  execute 'pyfile ' . s:path
endfunction
