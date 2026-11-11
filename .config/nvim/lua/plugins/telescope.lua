--- telescope: fuzzy finding for files, text, symbols and Neovim's own lists.

return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            -- Native fzf sorter; an order of magnitude faster on big repos.
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            enabled = vim.fn.executable("make") == 1,
        },
        "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
        -- Files -------------------------------------------------------------
        { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fF", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "Find files (all)" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
        { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
        { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git files" },
        { "<leader>fc", function()
            require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end, desc = "Find config file" },

        -- Search ------------------------------------------------------------
        { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep in project" },
        { "<leader>sG", function()
            require("telescope.builtin").live_grep({ additional_args = { "--hidden", "--no-ignore" } })
        end, desc = "Grep in project (all files)" },
        { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor", mode = { "n", "x" } },
        { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
        { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Diagnostics (buffer)" },
        { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics (project)" },
        { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols (buffer)" },
        { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Symbols (project)" },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help pages" },
        { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
        { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
        { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
        { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix list" },
        { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
        { "<leader>s:", "<cmd>Telescope command_history<cr>", desc = "Command history" },
        { "<leader>s/", "<cmd>Telescope search_history<cr>", desc = "Search history" },

        -- Git ---------------------------------------------------------------
        { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
        { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
        { "<leader>gB", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
    },
    opts = function()
        local actions = require("telescope.actions")
        local layout_actions = require("telescope.actions.layout")

        return {
            defaults = {
                prompt_prefix = "   ",
                selection_caret = "▍ ",
                entry_prefix = "  ",
                path_display = { "filename_first" }, -- name first, directory dimmed after
                sorting_strategy = "ascending",
                winblend = 0,
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = { prompt_position = "top", preview_width = 0.55, width = 0.9, height = 0.85 },
                },
                file_ignore_patterns = {
                    "^%.git/", "node_modules/", "%.venv/", "__pycache__/",
                    "^target/", "%.lock$", "%.png$", "%.jpg$", "%.pdf$",
                },
                vimgrep_arguments = {
                    "rg", "--color=never", "--no-heading", "--with-filename",
                    "--line-number", "--column", "--smart-case", "--trim",
                },
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-n>"] = actions.cycle_history_next,
                        ["<C-p>"] = actions.cycle_history_prev,
                        ["<C-u>"] = false, -- clear the prompt instead of scrolling
                        ["<C-d>"] = actions.preview_scrolling_down,
                        ["<C-f>"] = actions.preview_scrolling_up,
                        ["<C-h>"] = layout_actions.toggle_preview,
                        -- Send everything (or the selection) to the quickfix
                        -- list, which pairs with trouble for bulk edits.
                        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                        ["<Esc>"] = actions.close,
                    },
                    n = {
                        ["q"] = actions.close,
                        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    },
                },
            },
            pickers = {
                find_files = { find_command = { "rg", "--files", "--hidden", "--glob", "!.git/" } },
                buffers = {
                    mappings = {
                        i = { ["<C-x>"] = actions.delete_buffer },
                        n = { ["dd"] = actions.delete_buffer },
                    },
                },
                lsp_document_symbols = { symbol_width = 50 },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        -- `pcall` because fzf-native is skipped when `make` is unavailable.
        pcall(telescope.load_extension, "fzf")
        telescope.load_extension("ui-select")
    end,
}
