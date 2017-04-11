if !has('python')
  finish
endif

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/clean_json.py'
function! clean_json#CleanJSON()
  execute 'pyfile ' . s:path
endfunction
