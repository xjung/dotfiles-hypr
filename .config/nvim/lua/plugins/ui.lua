--- Chrome: keymap hints, the tab bar and the statusline.

return {
    -----------------------------------------------------------------------
    -- Icons shared by neo-tree, bufferline, telescope and lualine.
    -----------------------------------------------------------------------
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = { color_icons = true },
    },

    -----------------------------------------------------------------------
    -- which-key: the popup that documents a prefix while you are typing it.
    -----------------------------------------------------------------------
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "helix", -- side panel, closest to the LazyVim feel
            delay = function(ctx)
                -- Instant for operator-pending (d, y, c), relaxed otherwise.
                return ctx.plugin and 0 or 250
            end,
            win = { border = "rounded" },
            icons = { mappings = true },
            spec = {
                { "<leader>b", group = "buffer" },
                { "<leader>c", group = "code" },
                { "<leader>f", group = "file / find" },
                { "<leader>g", group = "git" },
                { "<leader>h", group = "git hunks" },
                { "<leader>q", group = "quit" },
                { "<leader>r", group = "replace" },
                { "<leader>s", group = "search" },
                { "<leader>t", group = "terminal" },
                { "<leader>u", group = "ui / toggle" },
                { "<leader>w", group = "window" },
                { "<leader>x", group = "diagnostics / lists" },
                { "[", group = "previous" },
                { "]", group = "next" },
                { "g", group = "goto" },
                { "z", group = "fold" },
            },
        },
        keys = {
            {
                "<leader>?",
                function() require("which-key").show({ global = false }) end,
                desc = "Keymaps for this buffer",
            },
            {
                "<leader>K",
                function() require("which-key").show({ global = true }) end,
                desc = "All keymaps",
            },
        },
    },

    -----------------------------------------------------------------------
    -- bufferline: open files as clickable tabs, VS Code style.
    -----------------------------------------------------------------------
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
            { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned buffers" },
            { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
            { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to the left" },
            { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump to buffer (pick)" },
            { "<leader>bm", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
            { "<leader>bM", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
            -- Jump straight to the Nth tab. `gt`/`gT` and `<S-h>`/`<S-l>` are
            -- wired to bufferline in lua/config/keymaps.lua.
            { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to tab 1" },
            { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to tab 2" },
            { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to tab 3" },
            { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to tab 4" },
            { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to tab 5" },
            { "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to tab 6" },
            { "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to tab 7" },
            { "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to tab 8" },
            { "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to tab 9" },
            { "<leader>0", "<cmd>BufferLineGoToBuffer -1<cr>", desc = "Go to last tab" },
        },
        opts = function()
            return {
                highlights = require("dark-2026").bufferline(),
                options = {
                    mode = "buffers",
                    themable = true,
                    close_command = function(n) Snacks.bufdelete(n) end,
                    right_mouse_command = function(n) Snacks.bufdelete(n) end,
                    indicator = { style = "underline" }, -- accent bar like VS Code
                    separator_style = "thin",
                    always_show_bufferline = false,
                    show_buffer_close_icons = true,
                    show_close_icon = false,
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(_, _, diagnostics)
                        local icons = { error = " ", warning = " ", info = " ", hint = " " }
                        local parts = {}
                        for severity, count in pairs(diagnostics) do
                            parts[#parts + 1] = (icons[severity] or "") .. count
                        end
                        return table.concat(parts, " ")
                    end,
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "EXPLORER",
                            text_align = "left",
                            highlight = "NeoTreeRootName",
                            separator = true,
                        },
                    },
                    hover = { enabled = true, delay = 150, reveal = { "close" } },
                },
            }
        end,
    },

    -----------------------------------------------------------------------
    -- lualine: statusline showing branch, diff, diagnostics and file path.
    -----------------------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = function()
            --- Path of the current buffer relative to the cwd, trimmed to the
            --- last two components so long paths do not eat the statusline.
            ---@return string
            local function short_path()
                local name = vim.fn.expand("%:~:.")
                if name == "" then
                    return "[No Name]"
                end
                local parts = vim.split(name, "/", { plain = true })
                if #parts <= 2 then
                    return name
                end
                return "…/" .. table.concat({ parts[#parts - 1], parts[#parts] }, "/")
            end

            --- Names of the language servers attached to the current buffer.
            ---@return string
            local function lsp_clients()
                local names = vim.iter(vim.lsp.get_clients({ bufnr = 0 }))
                    :map(function(client) return client.name end)
                    :totable()
                return #names > 0 and ("  " .. table.concat(names, ", ")) or ""
            end

            return {
                options = {
                    theme = require("dark-2026").lualine(),
                    globalstatus = true,
                    component_separators = { left = "│", right = "│" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { statusline = { "neo-tree", "snacks_dashboard" } },
                },
                sections = {
                    lualine_a = { { "mode", fmt = function(m) return m:sub(1, 3) end } },
                    lualine_b = {
                        { "branch", icon = "" },
                        {
                            "diff",
                            symbols = { added = " ", modified = " ", removed = " " },
                        },
                    },
                    lualine_c = {
                        { short_path },
                        { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
                    },
                    lualine_x = { lsp_clients, "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                extensions = { "neo-tree", "lazy", "trouble", "mason", "quickfix", "fugitive" },
            }
        end,
    },
}
