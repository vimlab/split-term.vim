
let s:force_vertical = exists('g:split_term_vertical') ? 1 : 0
let s:map_keys = exists('g:disable_key_mappings') ? 0 : 1
let s:default_shell = exists('g:split_term_default_shell') ? g:split_term_default_shell : 0

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

  " Easier time when pasting content in terminal mode with <C-v>
  tnoremap <buffer> <expr> <C-v> '<C-\><C-N>pi'
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
fun! s:openSplitTerm(args, count, vertical)
  let direction = s:force_vertical ? 1 : a:vertical

  call s:openBuffer(a:count, direction)
  call s:openTerm(a:args)
endf

" Opens a new terminal buffer, but instead of doing so using split buffer, it
" uses :tabnew instead.
fun! s:openTabTerm(args)
  exe 'tabnew'
  call s:openTerm(a:args)
endf

" Open a new terminal in the active buffer, while defining default mappings
" for this plugin.
fun! s:openTerm(args)
  let prevShell = &shell
  if exists('g:split_term_default_shell')
    exe 'set shell =' . s:default_shell
  endif

  exe 'terminal' a:args
  exe 'startinsert'
  if s:map_keys
    call s:defineMaps()
  endif

  if exists('g:split_term_default_shell')
    exe 'set shell =' . prevShell
  endif
endf

command! -count -nargs=* Term call  s:openSplitTerm(<q-args>, <count>, 0)
command! -count -nargs=* VTerm call s:openSplitTerm(<q-args>, <count>, 1)
command! -nargs=* TTerm call s:openTabTerm(<q-args>)
