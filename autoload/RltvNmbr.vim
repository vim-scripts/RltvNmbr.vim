" RltvNmbr.vim
"   Author: Charles E. Campbell, Jr.
"   Date:   Aug 18, 2008
"   Version: 1c	ASTRO-ONLY
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_RltvNmbr")
 finish
endif
let g:loaded_RltvNmbr = "v1c"
if !has("signs")
 echoerr 'Sorry, your vim is missing +signs; use  "configure --with-features=huge" , recompile, and install'
 finish
endif
let s:keepcpo= &cpo
set cpo&vim
"DechoTabOn

" ---------------------------------------------------------------------
"  Parameters: {{{1
let s:RLTVNMBR= 2683

" =====================================================================
"  Functions: {{{1

" ---------------------------------------------------------------------
" RltvNmbr: {{{2
fun! s:RltvNmbr(mode)
"  call Dfunc("s:RltvNmbr(mode=".a:mode.")")

  let lzkeep= &lz
  set lz
  if a:mode == 1
   " initial placement of signs
   let wt                              = line("w0")
   let wc                              = line(".")
   let wb                              = line("w$")
"   call Decho("initial placement of signs: wt=".wt." wc=".wc." wb=".wb)
   let w                               = wt
   let s:rltvnmbr_topline_{bufnr("%")} = wt
   let s:rltvnmbr_curline_{bufnr("%")} = wc
   let s:rltvnmbr_botline_{bufnr("%")} = wb
   while w <= wb
	if w == wc
	 let w= w + 1
	 continue
	endif
	let wmwc = w - wc
	if foldclosed(w) != -1
"	 call Decho("skipping w=".w." wmwc=".wmwc." foldclosed=".foldclosed(w))
	 let w= foldclosedend(w)+1
	 continue
	endif
	if wmwc <= -100
	 let w= wc - 99
	 continue
	endif
	if wmwc >= 100
	 break
	endif
	if wmwc < 0
	 let name = "RLTVN_M".(-wmwc)
	 exe "sign place ".(s:RLTVNMBR + wmwc)." line=".w." name=".name." buffer=".bufnr("%")
	else
	 let name = "RLTVN_P".wmwc
	 exe "sign place ".(s:RLTVNMBR + wmwc)." line=".w." name=".name." buffer=".bufnr("%")
	endif
	let w= w + 1
   endwhile

  elseif a:mode == 2
   if exists("s:rltvnmbr_curline_{bufnr('%')}")
    " re-placement of signs
"    call Decho("replacement of signs : (".line(".").",".line("w0").") =?= (".s:rltvnmbr_curline_{bufnr("%")}.",".s:rltvnmbr_topline_{bufnr("%")}.")")
    if line(".") != s:rltvnmbr_curline_{bufnr("%")} || line("w0") != s:rltvnmbr_topline_{bufnr("%")}
     exe "sign place ".s:RLTVNMBR." line=".s:rltvnmbr_curline_{bufnr("%")}." name=RLTVCURID buffer=".bufnr("%")
     call s:RltvNmbr(3)  " remove signs
     call s:RltvNmbr(1)  " put signs
     exe "sign unplace ".s:RLTVNMBR." buffer=".bufnr("%")
    endif
   endif

  elseif a:mode == 3
   " removal of signs
"   call Decho("removal of signs")
   let wt = s:rltvnmbr_topline_{bufnr("%")}
   let wc = s:rltvnmbr_curline_{bufnr("%")}
   let wb = s:rltvnmbr_botline_{bufnr("%")}
   let w  = wt
   while w <= wb
	if w == wc
	 let w= w + 1
	 continue
	endif
	let wmwc = w - wc
	if wmwc < 0
	 let name= "RLTVN_M".(-wmwc)
	else
	 let name= "RLTVN_P".wmwc
	endif
	exe "sign unplace ".(s:RLTVNMBR + wmwc)." buffer=".bufnr("%")
	let w= w + 1
   endwhile

  else
   echoerr "mode=".a:mode." unsupported"
  endif

  let &lz= lzkeep
"  call Dret("s:RltvNmbr")
endfun

" ---------------------------------------------------------------------
" RltvNmbr#RltvNmbrCtrl: {{{2
fun! RltvNmbr#RltvNmbrCtrl(start)
"  call Dfunc("RltvNmbr#RltvNmbrCtrl(start=".a:start.")")

  if      a:start && !exists("s:rltvnmbr_{bufnr('%')}")
   let s:rltvnmbr_{bufnr("%")}= 1

   if !exists("s:rltvnmbr_signs")
	let s:rltvnmbr_signs= 1
	hi default HL_RltvNmbr_Minus	ctermfg=red   ctermbg=black guifg=red   guibg=black
	hi default HL_RltvNmbr_Positive	ctermfg=green ctermbg=black guifg=green guibg=black
    let L= 1
    while L <= 99
	 exe "sign define RLTVN_M".L.' text='.string(L).' texthl=HL_RltvNmbr_Minus'
	 exe "sign define RLTVN_P".L.' text='.string(L).' texthl=HL_RltvNmbr_Positive'
     let L= L+1
    endwhile
   endif
   sign define RLTVCURID text=-- texthl=Ignore

   call s:RltvNmbr(1)
   augroup RltvNmbrAutoCmd
	au!
    au CursorMoved * call <SID>RltvNmbr(2)
	au ColorScheme * call <SID>ColorschemeLoaded()
   augroup END

  elseif !a:start && exists("s:rltvnmbr_{bufnr('%')}")
   unlet s:rltvnmbr_{bufnr("%")}
   augroup RltvNmbrAutoCmd
	au!
   augroup END
   augroup! RltvNmbrAutoCmd
   call s:RltvNmbr(3)
   exe "sign unplace ".s:RLTVNMBR." buffer=".bufnr("%")

  else
   echo "RltvNmbr is already ".((a:start)? "enabled" : "off")
  endif
"  call Dret("RltvNmbr#RltvNmbrCtrl")
endfun

" ---------------------------------------------------------------------
" s:ColorschemeLoaded: {{{2
fun! s:ColorschemeLoaded()
"  call Dfunc("s:ColorschemeLoaded()")
	hi HL_RltvNmbr_Minus	ctermfg=red   ctermbg=black guifg=red   guibg=black
	hi HL_RltvNmbr_Positive	ctermfg=green ctermbg=black guifg=green guibg=black
"  call Dret("s:ColorschemeLoaded")
endfun

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
