--- Everyday editing helpers: git signs, pairs, surround and undo history.

return {
    -----------------------------------------------------------------------
    -- gitsigns: gutter marks, hunk navigation and staging without leaving
    -- the buffer.
    -----------------------------------------------------------------------
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "▁" },
                topdelete = { text = "▔" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
            on_attach = function(buffer)
                local gs = require("gitsigns")

                ---@param mode string|string[]
                ---@param lhs string
                ---@param rhs string|function
                ---@param desc string
                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = buffer, desc = desc })
                end

                map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
                map("n", "[h", function() gs.nav_hunk("prev") end, "Previous hunk")
                map("n", "]H", function() gs.nav_hunk("last") end, "Last hunk")
                map("n", "[H", function() gs.nav_hunk("first") end, "First hunk")

                map({ "n", "x" }, "<leader>hs", gs.stage_hunk, "Stage hunk")
                map({ "n", "x" }, "<leader>hr", gs.reset_hunk, "Reset hunk")
                map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
                map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk")
                map("n", "<leader>hd", gs.diffthis, "Diff against index")
                map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against last commit")
                map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
                map("n", "<leader>ht", gs.toggle_current_line_blame, "Toggle inline blame")
                map({ "o", "x" }, "ih", gs.select_hunk, "Hunk text object")
            end,
        },
    },

    -----------------------------------------------------------------------
    -- mini.pairs / mini.surround: brackets and quotes.
    -----------------------------------------------------------------------
    {
        "nvim-mini/mini.pairs",
        event = "InsertEnter",
        opts = { modes = { insert = true, command = true, terminal = false } },
    },

    {
        "nvim-mini/mini.surround",
        event = "VeryLazy",
        opts = {
            -- `s` alone belongs to flash, so surround lives behind `gs`.
            mappings = {
                add = "gsa",
                delete = "gsd",
                find = "gsf",
                find_left = "gsF",
                highlight = "gsh",
                replace = "gsr",
                update_n_lines = "gsn",
            },
        },
    },

    {
        -- Closes and renames HTML/JSX tags as you type.
        "windwp/nvim-ts-autotag",
        ft = { "html", "xml", "javascriptreact", "typescriptreact", "vue", "svelte" },
        opts = {},
    },

    -----------------------------------------------------------------------
    -- undotree: browse the undo history as a tree.
    -----------------------------------------------------------------------
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle", "UndotreeShow" },
        keys = {
            { "<leader>uu", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
        },
        init = function()
            vim.g.undotree_WindowLayout = 3 -- tree on the right, diff below
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_ShortIndicators = 1
        end,
    },
}
