" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

func! Test_fillstruct() abort
  let l:wd = getcwd()
  try
    let g:go_gopls_enabled = 0
    let g:go_fillstruct_mode = 'fillstruct'
    let l:tmp = gotest#write_file('a/a.go', [
          \ 'package a',
          \ 'import "net/mail"',
          \ "var addr = mail.\x1fAddress{}"])

    call go#fillstruct#FillStruct()
    call gotest#assert_buffer(1, [
          \ 'var addr = mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}'])
  finally
    call go#util#Chdir(l:wd)
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_fillstruct_line() abort
  let l:wd = getcwd()
  try
    let g:go_gopls_enabled = 0
    let g:go_fillstruct_mode = 'fillstruct'
    let l:tmp = gotest#write_file('a/a.go', [
          \ 'package a',
          \ 'import "net/mail"',
          \ "\x1f" . 'var addr = mail.Address{}'])

    call go#fillstruct#FillStruct()
    call gotest#assert_buffer(1, [
          \ 'var addr = mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}'])
  finally
    call go#util#Chdir(l:wd)
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_fillstruct_two_line() abort
  let l:wd = getcwd()
  try
    let g:go_fillstruct_mode = 'fillstruct'
    let g:go_gopls_enabled = 0
    let l:tmp = gotest#write_file('a/a.go', [
          \ 'package a',
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ "\x1f" . 'func x() { fmt.Println(mail.Address{}, mail.Address{}) }'])

    call go#fillstruct#FillStruct()
    call gotest#assert_buffer(1, [
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ 'func x() { fmt.Println(mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}, mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}) }'])
  finally
    call go#util#Chdir(l:wd)
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_fillstruct_two_cursor() abort
  let l:wd = getcwd()
  try
    let g:go_fillstruct_mode = 'fillstruct'
    let g:go_gopls_enabled = 0
    let l:tmp = gotest#write_file('a/a.go', [
          \ 'package a',
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ "func x() { fmt.Println(mail.Address{}, mail.Ad\x1fdress{}) }"])

    call go#fillstruct#FillStruct()
    call gotest#assert_buffer(1, [
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ 'func x() { fmt.Println(mail.Address{}, mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}) }'])
  finally
    call go#util#Chdir(l:wd)
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_gopls_fillstruct() abort
  let l:wd = getcwd()
  try
    let g:go_fillstruct_mode = 'gopls'
    let l:tmp = gotest#write_file('a/a.go', [
          \ 'package a',
          \ 'import "net/mail"',
          \ "var addr = mail.\x1fAddress{}"])

    call go#fillstruct#FillStruct()

    let start = reltime()
    while &modified == 0 && reltimefloat(reltime(start)) < 10
      sleep 100m
    endwhile

    call gotest#assert_buffer(1, [
          \ 'var addr = mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}'])
  finally
    call go#util#Chdir(l:wd)
    call delete(l:tmp, 'rf')
  endtry
endfunc

"func! Test_gopls_fillstruct_line() abort
"  let l:wd = getcwd()
"  try
"    let g:go_fillstruct_mode = 'gopls'
"    let l:tmp = gotest#write_file('a/a.go', [
"          \ 'package a',
"          \ 'import "net/mail"',
"          \ "\x1f" . 'var addr = mail.Address{}'])
"
"    call go#fillstruct#FillStruct()
"
"    let start = reltime()
"    while &modified == 0 && reltimefloat(reltime(start)) < 10
"      sleep 100m
"    endwhile
"
"    call gotest#assert_buffer(1, [
"          \ 'var addr = mail.Address{',
"          \ '\tName:    "",',
"          \ '\tAddress: "",',
"          \ '}'])
"  finally
"    call go#util#Chdir(l:wd)
"    call delete(l:tmp, 'rf')
"  endtry
"endfunc

func! Test_gopls_fillstruct_two_cursor_first() abort
  let l:wd = getcwd()
  try
    let g:go_fillstruct_mode = 'gopls'
    let l:tmp = gotest#write_file('a/a.go', [
          \ 'package a',
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ "func x() { fmt.Println(mail.Addr\x1fess{}, mail.Address{}) }"])

    call go#fillstruct#FillStruct()

    let start = reltime()
    while &modified == 0 && reltimefloat(reltime(start)) < 10
      sleep 100m
    endwhile

    call gotest#assert_buffer(1, [
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ 'func x() { fmt.Println(mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}, mail.Address{}) }'])
  finally
    call go#util#Chdir(l:wd)
    call delete(l:tmp, 'rf')
  endtry
endfunc

func! Test_gopls_fillstruct_two_cursor_second() abort
  let l:wd = getcwd()
  try
    let g:go_fillstruct_mode = 'gopls'
    let l:tmp = gotest#write_file('a/a.go', [
          \ 'package a',
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ "func x() { fmt.Println(mail.Address{}, mail.Ad\x1fdress{}) }"])

    call go#fillstruct#FillStruct()

    let start = reltime()
    while &modified == 0 && reltimefloat(reltime(start)) < 10
      sleep 100m
    endwhile

    call gotest#assert_buffer(1, [
          \ 'import (',
          \ '"fmt"',
          \ '"net/mail"',
          \ ')',
          \ 'func x() { fmt.Println(mail.Address{}, mail.Address{',
          \ '\tName:    "",',
          \ '\tAddress: "",',
          \ '}) }'])
  finally
    call go#util#Chdir(l:wd)
    call delete(l:tmp, 'rf')
  endtry
endfunc

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
