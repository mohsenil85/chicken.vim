set lisp

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
  normal dd
  let term = "(use " . package . ")"
  call SlimuxSendCommand(term)
  echom term
endfunc

func! VisualDoc(search)
  let term = ",doc " . "(" . a:search . ")"
  echom term
  call SlimuxSendCommand(term)
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
