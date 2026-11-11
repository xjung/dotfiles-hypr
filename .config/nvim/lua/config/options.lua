--- Core editor settings. Loaded before lazy.nvim so that <leader> is defined
--- by the time plugin specs declare their keymaps.

-- Space as leader, backslash as local leader.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Transparent by default so the terminal's blur shows through.
vim.g.dark_2026_transparent = true

local opt = vim.opt

-- Appearance -----------------------------------------------------------------
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.showmode = false -- the statusline already shows the mode
opt.laststatus = 3 -- one global statusline instead of one per split
opt.cmdheight = 1
opt.pumheight = 12
opt.pumblend = 0 -- keep popups opaque-free so blur shows through
opt.winblend = 0
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true
opt.wrap = true
opt.linebreak = true -- wrap at word boundaries, not mid-word
opt.breakindent = true
opt.guicursor = "" -- a solid block cursor in every mode
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣", extends = "›", precedes = "‹" }
opt.fillchars = {
    eob = " ",
    fold = " ",
    foldopen = "▾",
    foldclose = "▸",
    foldsep = " ",
    diff = "╱",
}
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Indentation ----------------------------------------------------------------
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.smartindent = true

-- Search ---------------------------------------------------------------------
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true -- a capital letter in the pattern makes it case-sensitive
opt.inccommand = "split" -- live preview of :substitute in a scratch split
if vim.fn.executable("rg") == 1 then
    opt.grepprg = "rg --vimgrep --smart-case --hidden --glob=!.git/"
    opt.grepformat = "%f:%l:%c:%m"
end

-- Files and undo -------------------------------------------------------------
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undolevels = 10000
opt.autoread = true
opt.confirm = true -- prompt instead of failing when quitting a dirty buffer
opt.isfname:append("@-@")

-- Splits and windows ---------------------------------------------------------
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen" -- keep text in place when a split opens
opt.equalalways = false

-- Folding (tree-sitter driven, everything open on entry) ----------------------
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.foldlevel = 99
opt.foldcolumn = "0"

-- Behaviour ------------------------------------------------------------------
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.updatetime = 200 -- drives CursorHold, gitsigns and LSP highlights
opt.timeoutlen = 300 -- how long which-key waits before popping up
opt.virtualedit = "block"
opt.jumpoptions = "stack"
opt.completeopt = "menu,menuone,noselect"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "folds" }
opt.wildmode = "longest:full,full"
opt.diffopt:append({ "linematch:60" })

-- Providers we never use; skipping them removes startup checks and :checkhealth noise.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
