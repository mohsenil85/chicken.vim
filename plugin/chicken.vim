set lisp

au VimEnter *.scm RainbowParenthesesToggle
au Syntax *.scm RainbowParenthesesLoadRound
au Syntax *.scm RainbowParenthesesLoadSquare
au Syntax *.scm RainbowParenthesesLoadBraces

let g:slimux_scheme_leader=','


autocmd filetype lisp,scheme,art setlocal equalprg=lispindent.lisp
let b:is_chicken=1
setl include=\^\(\\(use\\\|require-extension\\)\\s\\+
setl includeexpr=substitute(v:fname,'$','.scm','')
setl path+=/usr/local/Cellar/chicken/4.9.0.1/
setl suffixesadd=.scm)
setl lispwords+=let-values,condition-case,with-input-from-string
setl lispwords+=with-output-to-string,handle-exceptions,call/cc,rec,receive
setl lispwords+=call-with-output-file
setl complete+=,k~/.vim/scheme-word-list


map <Leader>c :SlimuxREPLConfigure<CR>
map <Leader>b :SlimuxREPLSendBuffer<CR>

map <Leader>s :SlimuxREPLSendLine<CR>
vmap <Leader>s :SlimuxREPLSendSelection<CR>
let g:slimux_scheme_keybindings=1



function! ChickenDocLookup(search)
let winnr = bufwinnr('^_output$')
if ( winnr >= 0 )
execute winnr . 'wincmd w'
execute 'normal ggdG'
else
below new _output
setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
endif
execute "silent! r! chicken-doc " . a:search
execute "silent! / " . a:search
execute "silent! set filetype=scheme"
execute "silent! set filetype=scheme"
endfunction

function! ChickenArgsPrompt(search)
let cmd = "chicken-doc -s " . a:search 
let output = system(cmd)
echom output
endfunction

function! ChickenInstallPrompt()
let package = input('install package: ')
normal dd
let cmd = "chicken-install " . package 
execute "silent! !" . cmd
echom '...done'
endfunction


func! GetSelectedText()
normal gv"xy
let result = getreg("x")
normal gv
return result
endfunc

func! LoadNameSpace()
let package = input('load namespace: ')
let term = "(use " . package . ")"
call SlimuxSendCommand(term)
echom term
endfunc

func! VisualDoc(search)
let term = ",doc " . "(" . a:search . ")"
echom term
call SlimuxSendCommand(term)
endfunc

func! DocPrompt() 
let search = input('search docs: ')
call ChickenDocLookup(search)
endfunc

nnoremap <silent> <buffer> <Leader>K :call ChickenDocLookup('<C-R><C-W>')<CR>
nnoremap <silent> <buffer> <Leader>c :SlimuxREPLConfigure<CR>
"nnoremap <silent> <buffer> <Leader>g :call ChickenArgsPrompt('<C-R><C-W>')<CR>

vnoremap <silent> <buffer> <Leader>K :call ChickenDocLookup(GetSelectedText())<CR>
vnoremap <silent> <buffer> <Leader>K :call ChickenDocLookup(GetSelectedText())<CR>
nnoremap <silent> <buffer> <Leader>a :call SlimuxSendCommand(",wtf <C-R><C-W>")<CR>
nnoremap <silent> <buffer> <Leader>h :call SlimuxSendCommand(",doc <C-R><C-W>")<CR>
nnoremap <silent> <buffer> <Leader>i :call ChickenInstallPrompt()<CR>
nnoremap <silent> <buffer> <Leader>n :call LoadNameSpace()<CR>
vnoremap <silent> <buffer> <Leader>h :call VisualDoc(GetSelectedText())<CR>

nnoremap <silent> <buffer> <Leader>t :call SlimuxSendCommand("(trace  <C-R><C-W>)")<CR>
nnoremap <silent> <buffer> <Leader>f :call DocPrompt()<CR>
