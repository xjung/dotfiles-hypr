--- Search, replace, motion and diagnostic lists.

return {
    -----------------------------------------------------------------------
    -- grug-far: ripgrep-backed search and replace across the whole project,
    -- edited in a normal buffer with a live diff before anything is written.
    -----------------------------------------------------------------------
    {
        "MagicDuck/grug-far.nvim",
        cmd = "GrugFar",
        opts = {
            headerMaxWidth = 80,
            windowCreationCommand = "botright split",
            resultLocation = { showNumberLabel = true },
            -- In-buffer actions keep grug-far's <localleader> defaults (\r to
            -- replace, \s to sync, g? for help), so they never shadow <leader>.
        },
        keys = {
            {
                "<leader>rr",
                function() require("grug-far").open() end,
                desc = "Search & replace (project)",
            },
            {
                "<leader>rf",
                function()
                    require("grug-far").open({
                        prefills = { paths = vim.fn.expand("%") },
                    })
                end,
                desc = "Search & replace (current file)",
            },
            {
                "<leader>rw",
                function()
                    require("grug-far").open({
                        prefills = { search = vim.fn.expand("<cword>") },
                    })
                end,
                desc = "Replace word under cursor (project)",
            },
            {
                "<leader>rW",
                function()
                    require("grug-far").open({
                        prefills = {
                            search = vim.fn.expand("<cword>"),
                            paths = vim.fn.expand("%"),
                        },
                    })
                end,
                desc = "Replace word under cursor (file)",
            },
            {
                "<leader>rr",
                mode = "x",
                function() require("grug-far").with_visual_selection() end,
                desc = "Search & replace selection",
            },
        },
    },

    -----------------------------------------------------------------------
    -- flash: label-based jumping, and labels on `/` search results.
    -----------------------------------------------------------------------
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                char = { jump_labels = true }, -- label f/t/F/T targets too
                search = { enabled = true },
            },
        },
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter search" },
            { "<c-s>", mode = "c", function() require("flash").toggle() end, desc = "Toggle flash search" },
        },
    },

    -----------------------------------------------------------------------
    -- trouble: a proper list view for diagnostics, references and symbols.
    -----------------------------------------------------------------------
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = { focus = true, win = { border = "rounded" } },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (project)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
            { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols outline" },
            { "<leader>xr", "<cmd>Trouble lsp toggle<cr>", desc = "References / definitions" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
        },
    },

    -----------------------------------------------------------------------
    -- todo-comments: highlight and search TODO / FIXME / HACK markers.
    -----------------------------------------------------------------------
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
        keys = {
            { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo comments" },
            { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo comments (list)" },
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
        },
    },
}
