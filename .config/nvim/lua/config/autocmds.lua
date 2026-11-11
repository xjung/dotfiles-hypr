--- Editor-wide autocommands.

--- Create (and clear) an augroup namespaced to this config.
---@param name string
---@return integer group_id
local function augroup(name)
    return vim.api.nvim_create_augroup("nvimrc_" .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

-- Briefly highlight whatever was just yanked.
autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
    end,
})

-- Strip trailing whitespace on save, except where it is meaningful.
autocmd("BufWritePre", {
    group = augroup("trim_whitespace"),
    callback = function(event)
        if vim.tbl_contains({ "markdown", "diff", "gitcommit" }, vim.bo[event.buf].filetype) then
            return
        end
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- Create missing parent directories when writing a new file.
autocmd("BufWritePre", {
    group = augroup("auto_mkdir"),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return -- a URL-style buffer (oil://, fugitive://, ...)
        end
        vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(event.match) or event.match, ":p:h"), "p")
    end,
})

-- Reopen a file where you left it.
autocmd("BufReadPost", {
    group = augroup("last_location"),
    callback = function(event)
        if vim.b[event.buf].last_location_restored then
            return
        end
        vim.b[event.buf].last_location_restored = true
        local mark = vim.api.nvim_buf_get_mark(event.buf, [["]])
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(event.buf) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
            vim.cmd("normal! zz")
        end
    end,
})

-- `q` closes throwaway windows instead of quitting Neovim.
autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "help", "man", "qf", "lspinfo", "checkhealth", "startuptime",
        "notify", "fugitive", "gitsigns-blame", "dbout", "neotest-output",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close window" })
    end,
})

-- Wrap and spell-check prose.
autocmd("FileType", {
    group = augroup("prose"),
    pattern = { "markdown", "gitcommit", "text", "tex" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en,ru"
    end,
})

-- Keep splits proportional when the terminal is resized.
autocmd("VimResized", {
    group = augroup("resize_splits"),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- Pick up changes made outside Neovim (git checkout, formatter, ...).
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Terminal buffers have no use for line numbers or a sign column.
autocmd("TermOpen", {
    group = augroup("terminal"),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.spell = false
    end,
})
