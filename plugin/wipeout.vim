" wipeout.vim - Destroy all buffers that are not open in any tabs or windows.
"
" Adapted from the following StackOverflow answer:
" http://stackoverflow.com/questions/1534835
"
" Author: Artem Nezvigin <artem@artnez.com>

command! -bang Wipeout :call Wipeout(<bang>0, 0)
command! -bang WipeoutAll :call Wipeout(<bang>0, 1)

function! Wipeout(bang, wipeUnlisted)
  " figure out which buffers are visible in any tab
  let visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  " close any buffer that are loaded and not visible
  let l:tally = 0
  let l:skips = 0
  let l:cmd = 'bw'
  if a:bang
    let l:cmd .= '!'
  endif
  for b in range(1, bufnr('$'))
    if (a:wipeUnlisted || buflisted(b)) && !has_key(visible, b)
      if getbufvar(b, "&mod")
        let l:skips += 1
        continue
      endif
      let l:tally += 1
      exe l:cmd . ' ' . b
    endif
  endfor
  let l:msg = "Deleted " . l:tally . " buffer" . (l:tally == 1 ? "" : "s")
  if l:skips
    let l:msg .= ", skipped " . l:skips . " modified buffer" . (l:skips == 1 ? "" : "s")
  endif
  echon l:msg
endfun
