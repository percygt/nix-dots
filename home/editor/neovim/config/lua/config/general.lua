local g, opt = vim.g, vim.opt

g.mapleader = " "
g.maplocalleader = " "

opt.nu = true -- Show numberline
opt.relativenumber = true -- Show number relative to the current cursor position

opt.termguicolors = true -- Enable 24-bit RGB color in the TUI
opt.cursorline = true -- Highlight the text line of the cursor
opt.hlsearch = true -- Highlighting search

opt.autowrite = true
opt.autoread = true

opt.mouse = "a" -- Enable mouse support
opt.wrap = false -- Disable text wrap
opt.ignorecase = true -- Case insensitive searching
opt.infercase = true -- Infer cases in keyword completion
opt.smartcase = true -- Case sensitivie searching
opt.smartindent = true -- Smarter autoindentation
opt.scrolloff = 8 -- Number of lines to keep above and below the cursor
opt.sidescrolloff = 8 -- Number of columns to keep at the sides of the cursor
opt.tabstop = 2 -- Number of whitespaces in a \t
opt.shiftwidth = 2 -- Number of whitespaces in one level of indentation
opt.softtabstop = 2 -- Number of whitespaces generated by a single tab keypress or removed by a backspace keypress
opt.expandtab = true -- Place spaces instead of \t upon receiving a whitespace command or a tab keypress
opt.updatetime = 100 -- Length of time to wait before triggering the plugin
opt.signcolumn = "yes" -- Enable status symbols before numberline
opt.virtualedit = "block" -- Allow going past end of line in visual block mode
opt.splitbelow = true -- Splitting a new window below the current one
opt.splitright = true -- Splitting a new window at the right of the current one
opt.conceallevel = 2

opt.swapfile = false -- Disable swapfiles
opt.backup = false
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.undofile = true -- Enable persistent undo
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions" -- For better auto-session
opt.spell = true
opt.spelllang = "en_us"
opt.spelloptions = "camel"