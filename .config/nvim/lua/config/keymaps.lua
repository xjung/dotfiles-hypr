--- Editor keymaps that do not belong to a specific plugin.
---
--- Plugin keymaps live next to their `lazy.nvim` spec so that which-key can
--- show them before the plugin is even loaded.

local map = vim.keymap.set

--- Small wrapper so every mapping gets a description (which-key reads these).
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string
---@param opts? table
local function nmap(mode, lhs, rhs, desc, opts)
    opts = vim.tbl_extend("force", { silent = true, desc = desc }, opts or {})
    map(mode, lhs, rhs, opts)
end

-- Movement -------------------------------------------------------------------
-- `wrap` is on, so plain j/k would skip whole paragraphs. Moving by display
-- line only when no count is given keeps `5j` behaving like a real 5 lines.
nmap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true })
nmap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true })

nmap("n", "<C-d>", "<C-d>zz", "Half page down")
nmap("n", "<C-u>", "<C-u>zz", "Half page up")
nmap("n", "n", "nzzzv", "Next search match")
nmap("n", "N", "Nzzzv", "Previous search match")
nmap("n", "J", "mzJ`z", "Join lines (keep cursor)")

-- Windows --------------------------------------------------------------------
nmap("n", "<C-h>", "<C-w>h", "Go to left window")
nmap("n", "<C-j>", "<C-w>j", "Go to lower window")
nmap("n", "<C-k>", "<C-w>k", "Go to upper window")
nmap("n", "<C-l>", "<C-w>l", "Go to right window")
nmap("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase window height")
nmap("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease window height")
nmap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease window width")
nmap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Increase window width")

nmap("n", "<leader>ww", "<C-w>p", "Other window")
nmap("n", "<leader>wd", "<C-w>c", "Delete window")
nmap("n", "<leader>ws", "<C-w>s", "Split below")
nmap("n", "<leader>wv", "<C-w>v", "Split right")
nmap("n", "<leader>w=", "<C-w>=", "Balance windows")
nmap("n", "<leader>wm", "<C-w>|<C-w>_", "Maximise window")

-- Tabs (bufferline) ----------------------------------------------------------
-- The tab bar shows buffers, and its order can be rearranged with <leader>bm,
-- so navigation goes through bufferline rather than :bnext - the latter would
-- follow buffer numbers and disagree with what is on screen.

--- Run a bufferline command, loading the plugin first if it is still lazy.
---@param command string
---@return function
local function tab_cmd(command)
    return function()
        require("bufferline")
        vim.cmd(command)
    end
end

--- `gt` keeps Vim's tab-page semantics: a count jumps to that tab, a bare
--- press moves one to the right.
local function goto_tab()
    require("bufferline")
    if vim.v.count > 0 then
        vim.cmd("BufferLineGoToBuffer " .. vim.v.count)
    else
        vim.cmd("BufferLineCycleNext")
    end
end

nmap("n", "gt", goto_tab, "Next tab / go to tab N")
nmap("n", "gT", tab_cmd("BufferLineCyclePrev"), "Previous tab")
nmap("n", "<S-l>", tab_cmd("BufferLineCycleNext"), "Next tab")
nmap("n", "<S-h>", tab_cmd("BufferLineCyclePrev"), "Previous tab")
nmap("n", "]b", tab_cmd("BufferLineCycleNext"), "Next tab")
nmap("n", "[b", tab_cmd("BufferLineCyclePrev"), "Previous tab")
nmap("n", "<leader>bb", "<cmd>e #<cr>", "Alternate buffer")
nmap("n", "<leader>`", "<cmd>e #<cr>", "Alternate buffer")

-- Editing --------------------------------------------------------------------
nmap("i", "<C-c>", "<Esc>", "Escape")
nmap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", "Save file")
nmap("n", "Q", "<nop>", "Disabled")

-- Keep the selection after shifting so you can indent repeatedly.
nmap("x", "<", "<gv", "Indent left")
nmap("x", ">", ">gv", "Indent right")

-- Move the selection up and down, reindenting as it goes.
nmap("x", "J", ":m '>+1<cr>gv=gv", "Move selection down")
nmap("x", "K", ":m '<-2<cr>gv=gv", "Move selection up")
nmap("n", "<A-j>", "<cmd>m .+1<cr>==", "Move line down")
nmap("n", "<A-k>", "<cmd>m .-2<cr>==", "Move line up")
nmap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move line down")
nmap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move line up")

-- Paste over a selection without losing the yanked text, and delete to the
-- black-hole register when the clipboard should stay untouched.
nmap("x", "<leader>p", [["_dP]], "Paste (keep register)")
nmap({ "n", "x" }, "<leader>d", [["_d]], "Delete (no register)")

-- Undo break-points: typing one of these starts a new undo block.
for _, char in ipairs({ ",", ".", ";", "(", "[", "{" }) do
    map("i", char, char .. "<c-g>u")
end

-- Search ---------------------------------------------------------------------
nmap({ "i", "n", "s" }, "<Esc>", "<cmd>noh<cr><esc>", "Clear search highlight")

--- Escape the current visual selection into a search pattern.
---@return string pattern Regex-escaped text of the selection.
local function selection_pattern()
    local saved = vim.fn.getreg("v")
    vim.cmd([[noautocmd silent normal! "vy]])
    local text = vim.fn.getreg("v")
    vim.fn.setreg("v", saved)
    return vim.fn.escape(table.concat(vim.split(text, "\n"), "\\n"), "/\\.*$^~[]")
end

nmap("x", "*", function()
    vim.fn.setreg("/", "\\V" .. selection_pattern())
    vim.cmd("normal! n")
end, "Search selection forward")
nmap("x", "#", function()
    vim.fn.setreg("/", "\\V" .. selection_pattern())
    vim.cmd("normal! N")
end, "Search selection backward")

-- Replace --------------------------------------------------------------------
-- Native, instant in-file replace. `inccommand=split` previews every hit while
-- you type, so this covers the common "rename in this file" case without a
-- plugin round-trip. The cursor lands between the slashes, ready to type.
nmap("n", "<leader>rs", function()
    local word = vim.fn.expand("<cword>")
    -- Three <Left>s park the cursor right after the pre-filled replacement.
    return ":%s/\\<" .. word .. "\\>/" .. word .. "/gI<Left><Left><Left>"
end, "Substitute word in file", { expr = true, silent = false })

nmap("n", "<leader>rl", ":s/", "Substitute on line", { silent = false })
nmap("x", "<leader>rs", ":s/", "Substitute in selection", { silent = false })

-- Diagnostics and lists ------------------------------------------------------
nmap("n", "]q", "<cmd>cnext<cr>zz", "Next quickfix item")
nmap("n", "[q", "<cmd>cprevious<cr>zz", "Previous quickfix item")
nmap("n", "]l", "<cmd>lnext<cr>zz", "Next location item")
nmap("n", "[l", "<cmd>lprevious<cr>zz", "Previous location item")

--- Jump to the next/previous diagnostic, optionally filtered by severity.
---@param count 1|-1
---@param severity? string Key of `vim.diagnostic.severity`, e.g. "ERROR".
---@return function
local function diagnostic_jump(count, severity)
    return function()
        vim.diagnostic.jump({
            count = count,
            float = true,
            severity = severity and vim.diagnostic.severity[severity] or nil,
        })
    end
end

nmap("n", "]d", diagnostic_jump(1), "Next diagnostic")
nmap("n", "[d", diagnostic_jump(-1), "Previous diagnostic")
nmap("n", "]e", diagnostic_jump(1, "ERROR"), "Next error")
nmap("n", "[e", diagnostic_jump(-1, "ERROR"), "Previous error")
nmap("n", "]w", diagnostic_jump(1, "WARN"), "Next warning")
nmap("n", "[w", diagnostic_jump(-1, "WARN"), "Previous warning")

-- Files and misc -------------------------------------------------------------
nmap("n", "<leader>cx", "<cmd>!chmod +x %<cr>", "Make file executable")
nmap("n", "<leader>qq", "<cmd>qa<cr>", "Quit all")
nmap("n", "<leader>qw", "<cmd>wqa<cr>", "Write and quit all")
nmap("n", "<leader>L", "<cmd>Lazy<cr>", "Plugin manager")
nmap("n", "<leader>M", "<cmd>Mason<cr>", "LSP installer")

-- Toggles (<leader>u) --------------------------------------------------------

--- Build a toggle for a boolean window-local option.
---@param name string Option name, e.g. "wrap".
---@param label string Human-readable name used in the notification.
---@return function
local function toggle_option(name, label)
    return function()
        vim.wo[name] = not vim.wo[name]
        vim.notify(label .. ": " .. (vim.wo[name] and "on" or "off"), vim.log.levels.INFO)
    end
end

nmap("n", "<leader>ut", function() require("dark-2026").toggle() end, "Toggle transparency")
nmap("n", "<leader>uw", toggle_option("wrap", "Wrap"), "Toggle wrap")
nmap("n", "<leader>ul", toggle_option("number", "Number"), "Toggle line numbers")
nmap("n", "<leader>uL", toggle_option("relativenumber", "Relative number"), "Toggle relative numbers")
nmap("n", "<leader>us", toggle_option("spell", "Spell"), "Toggle spell check")

nmap("n", "<leader>uc", function()
    vim.wo.colorcolumn = vim.wo.colorcolumn == "" and "80,100" or ""
end, "Toggle column guides")

nmap("n", "<leader>ud", function()
    local enabled = vim.diagnostic.is_enabled()
    vim.diagnostic.enable(not enabled)
    vim.notify("Diagnostics: " .. (enabled and "off" or "on"), vim.log.levels.INFO)
end, "Toggle diagnostics")

nmap("n", "<leader>uh", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
    vim.notify("Inlay hints: " .. (enabled and "off" or "on"), vim.log.levels.INFO)
end, "Toggle inlay hints")
