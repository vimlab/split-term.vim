
let s:force_vertical = exists('g:split_term_vertical') ? 1 : 0

" utilities around neovim's :term

" Remaps specifically a few keys for a better terminal buffer experience.
"
" - Rebind <Esc> to switch to normal mode
" - Bind Alt+hjkl, Ctrl+arrows to navigate through windows (eg. switching to
"   buffer/windows left, right etc.)
fun! s:defineMaps()
  " Allow hitting <Esc> to switch to normal mode
  tnoremap <buffer> <Esc> <C-\><C-n>

  " Alt+[hjkl] to navigate through windows in insert mode
  tnoremap <buffer> <A-h> <C-\><C-n><C-w>h
  tnoremap <buffer> <A-j> <C-\><C-n><C-w>j
  tnoremap <buffer> <A-k> <C-\><C-n><C-w>k
  tnoremap <buffer> <A-l> <C-\><C-n><C-w>l

  " Alt+[hjkl] to navigate through windows in normal mode
  nnoremap <buffer> <A-h> <C-w>h
  nnoremap <buffer> <A-j> <C-w>j
  nnoremap <buffer> <A-k> <C-w>k
  nnoremap <buffer> <A-l> <C-w>l

  " Ctrl+Arrows to navigate through windows in insert mode
  tnoremap <buffer> <C-Left>  <C-\><C-n><C-w>h
  tnoremap <buffer> <C-Down>  <C-\><C-n><C-w>j
  tnoremap <buffer> <C-Up>    <C-\><C-n><C-w>k
  tnoremap <buffer> <C-Right> <C-\><C-n><C-w>l

  " Ctrl+Arrows to navigate through windows in normal mode
  nnoremap <buffer> <C-Left>  <C-w>h
  nnoremap <buffer> <C-Down>  <C-w>j
  nnoremap <buffer> <C-Up>    <C-w>k
  nnoremap <buffer> <C-Right> <C-w>l
endfunction

" Opens up a new buffer, either vertical or horizontal. Count can be used to
" specify the number of visible columns or rows.
fun! s:openBuffer(count, vertical)
  let cmd = a:vertical ? 'vnew' : 'new'
  let cmd = a:count ? a:count . cmd : cmd
  exe cmd
endf

" Opens a new terminal buffer, but instead of doing so using 'enew' (same
" window), it uses :vnew and :new instead. Usually, I want to open a new
" terminal and not replace my current buffer.
fun! s:openTerm(args, count, vertical)
  let params = split(a:args)
  let direction = s:force_vertical ? 1 : a:vertical

  call s:openBuffer(a:count, direction)
  exe 'terminal' a:args
  exe 'startinsert'
  call s:defineMaps()
endf

command! -count -nargs=* Term call s:openTerm(<q-args>, <count>, 0)
command! -count -nargs=* VTerm call s:openTerm(<q-args>, <count>, 1)
