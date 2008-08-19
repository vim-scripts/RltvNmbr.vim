" RltvNmbr.vim
"   Author: Charles E. Campbell, Jr.
"   Date:   Aug 18, 2008
"   Version: 1c	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_RltvNmbrPlugin")
 finish
endif
let g:loaded_RltvNmbrPlugin = "v1c"
if !has("signs")
 echoerr 'Sorry, your vim is missing +signs; use  "configure --with-features=huge" , recompile, and install'
 finish
endif
let s:keepcpo= &cpo
set cpo&vim

" ---------------------------------------------------------------------
"  Public Interface: {{{1
com! -bang RltvNmbr	call RltvNmbr#RltvNmbrCtrl(<bang>1)

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
