--- snacks.nvim bundles a set of small quality-of-life modules. Only the ones
--- listed below are enabled; everything else stays dormant.

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true }, -- disable syntax/LSP on huge files
        quickfile = { enabled = true }, -- render the file before loading plugins
        input = { enabled = true }, -- pretty vim.ui.input (used by LSP rename)
        notifier = { enabled = true, timeout = 3000, style = "compact" },
        indent = {
            enabled = true,
            indent = { char = "│" },
            scope = { char = "│" },
            animate = { enabled = false }, -- static guides, like VS Code
        },
        scope = { enabled = true }, -- `ii`/`ai` indent-scope text objects
        statuscolumn = { enabled = true }, -- git signs + folds in the gutter
        words = { enabled = true }, -- highlight other references to the word under the cursor
        dashboard = {
            enabled = true,
            preset = {
                header = table.concat({
                    "                                                  ",
                    "  ███╗   ██╗ ███████╗ ██████╗  ██╗ ███╗   ███╗    ",
                    "  ████╗  ██║ ██╔════╝ ██╔══██╗ ██║ ████╗ ████║    ",
                    "  ██╔██╗ ██║ █████╗   ██║  ██║ ██║ ██╔████╔██║    ",
                    "  ██║╚██╗██║ ██╔══╝   ██║  ██║ ██║ ██║╚██╔╝██║    ",
                    "  ██║ ╚████║ ███████╗ ██████╔╝ ██║ ██║ ╚═╝ ██║    ",
                    "  ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝  ╚═╝ ╚═╝     ╚═╝    ",
                }, "\n"),
                keys = {
                    { icon = " ", key = "f", desc = "Find file", action = "<cmd>Telescope find_files<cr>" },
                    { icon = " ", key = "n", desc = "New file", action = "<cmd>ene | startinsert<cr>" },
                    { icon = " ", key = "g", desc = "Find text", action = "<cmd>Telescope live_grep<cr>" },
                    { icon = " ", key = "r", desc = "Recent files", action = "<cmd>Telescope oldfiles<cr>" },
                    { icon = " ", key = "e", desc = "File tree", action = "<cmd>Neotree toggle<cr>" },
                    { icon = " ", key = "c", desc = "Config", action = "<cmd>Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<cr>" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = "<cmd>Lazy<cr>" },
                    { icon = " ", key = "q", desc = "Quit", action = "<cmd>qa<cr>" },
                },
            },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "recent_files", icon = " ", title = "Recent", padding = 1, limit = 5 },
                { section = "startup" },
            },
        },
    },
    keys = {
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
        { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "Lazygit file history" },
        { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Blame line" },
        { "<leader>gO", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "x" } },
        { "<leader>tt", function() Snacks.terminal() end, desc = "Terminal (cwd)" },
        { "<C-/>", function() Snacks.terminal() end, desc = "Terminal", mode = { "n", "t" } },
        { "<C-_>", function() Snacks.terminal() end, desc = "which_key_ignore", mode = { "n", "t" } },
        { "<leader>N", function() Snacks.notifier.show_history() end, desc = "Notification history" },
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
        { "]]", function() Snacks.words.jump(1, true) end, desc = "Next reference", mode = { "n", "t" } },
        { "[[", function() Snacks.words.jump(-1, true) end, desc = "Previous reference", mode = { "n", "t" } },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Registered late so which-key picks up their descriptions.
                Snacks.toggle.dim():map("<leader>uD")
                Snacks.toggle.zen():map("<leader>uz")
            end,
        })
    end,
}
