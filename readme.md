# split-term.vim

Utilites around neovim's `:terminal`.

One of the coolest feature of neovim is its xterm-like terminal emulator. See
`:help nvim-terminal-emulator`.

> One feature that distinguishes Nvim from Vim is that it implements a mostly
complete VT220/xterm-like terminal emulator. The terminal is presented to the
user as a special buffer type, one that is asynchronously updated to mirror
the virtual terminal display as data is received from the program connected
to it. For most purposes, terminal buffers behave a lot like normal buffers
with 'nomodifiable' set.

This help page also comes with a bunch of tips and recommandation. Indeed, the
initial user experience within a terminal Buffer is not perfect:

- No easy way to switch back to normal mode. Hitting `a`, `i` or any key that
  would enter insert mode allows sending input to the command, but there's no
  easy way to switch back (for instance to close the buffer with `:q`). The
  `<C-\><C-n>` key combo is the defaults.

- `:term` will open a terminal buffer, **in** the current buffer, which is
  often not wanted. It uses `:enew` by default whereas `:new` or `:vnew` might
  be more appropriate.

- Navigating to nearby buffer / windows is not easy / handy. Maps like `<C-w>w`
  are inactive in favor of the terminal implementation (which is in this case
  delete previous word)

This plugin aims to alleviate some of these issues, for a better terminal
buffer experience.

![demo](./demo.gif)

## Install

Install this plugin using your favorite plugin manager, or manually by
extracting the files in your `~/.vim` or `~/.config/nvim` directory.

    Plug 'mklabs/split-term.vim'

## Commands

- **`:Term`** Opens a new terminal buffer using `:new` (splits horizontally)
- **`:VTerm`** Opens a new terminal buffer using `:vnew` (splits vertically)

Both commands accept a `<count>` like their `:new`/`:vnew` counterparts. You
can prefix both commands with a number to specifiy the buffer height / width.

Similar to the original `:terminal`, both commands accepts any number of
arguments. It can be used to spawn a cmd and see the result, or even start a
REPL.

**Examples**

- `:10Term` would open an horizontal buffer with 10 lines displayed, on top of
  the current buffer.

- `:100VTerm` would open a vertical buffer with 10 lines displayed, right of
  the current buffer.

- `:Term npm search something` would open a new terminal buffer and launch a
  search on npm registry. This is a good candidate to appreciate the async
  nature of neovim (no more frozen UI!)

- `:2Term npm install express` would open a minimal buffer with only two lines,
  immediatly invoking `npm install express` with npm output displayed within
  the terminal buffer. Hit `<Enter>` when done to close the buffer.

- `:VTerm node` would open a vertical buffer with a node REPL started.

## Configuration

- `g:split_term_vertical` - force the `:Term` command to always use a vertical
  buffer (using `:vnew`)

- `splitright/splitbelow` options can be used to configure the split buffer
  orientation.
  - `set splitright` will put the new window right of the current one when using `:VTerm`
  - `set splitbelow` will put the new window below the current one when using `:Term`

- `g:disable_key_mappings` - disable key mappings of the plugin

## Mappings

The plugin remaps specifically a few keys for a better terminal buffer experience. This
behaviour can be disabled using `g:disable_key_mappings`.

- `<Esc>` - Switch to normal mode (instead of `<C-\><C-n>`)
- Bind Alt+hjkl, Ctrl+arrows to navigate through windows (eg. switching to buffer/windows left, right etc.)
  - `Alt+h` - does a `<C-w>h`
  - `Alt+j` - does a `<C-w>j`
  - `Alt+k` - does a `<C-w>k`
  - `Alt+l` - does a `<C-w>l`
  - `Ctrl+Left` - does a `<C-w>h`
  - `Ctrl+Down` - does a `<C-w>j`
  - `Ctrl+Up` - does a `<C-w>k`
  - `Ctrl+Right` - does a `<C-w>l`
