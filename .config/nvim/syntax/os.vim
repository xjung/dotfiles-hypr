" OneScript shares the BSL grammar.
if exists("b:current_syntax")
  finish
endif
runtime! syntax/bsl.vim
let b:current_syntax = "os"
