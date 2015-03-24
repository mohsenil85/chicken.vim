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
  let cmd = "chicken-doc " . a:search ."| grep ':' | head -n 1 | cut -d':' -f2 "
  let output = system(cmd)
  echom output
endfunction



func! GetSelectedText()
  normal gv"xy
  let result = getreg("x")
  normal gv
  return result
endfunc

nnoremap <silent> <buffer> <Leader>K :call ChickenDocLookup('<C-R><C-W>')<CR>
nnoremap <silent> <buffer> <Leader>g :call ChickenArgsPrompt('<C-R><C-W>')<CR>

vnoremap <silent> <buffer> <Leader>K :call ChickenDocLookup(GetSelectedText())<CR>


