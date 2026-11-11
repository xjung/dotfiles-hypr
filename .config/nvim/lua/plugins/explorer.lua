--- neo-tree: a persistent file tree, plus buffer and git-status views in the
--- same sidebar. Replaces `:Explore` entirely.

return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "Explorer (toggle)" },
        { "<leader>E", "<cmd>Neotree focus reveal<cr>", desc = "Explorer (reveal file)" },
        { "<leader>fe", "<cmd>Neotree toggle reveal<cr>", desc = "Explorer (toggle)" },
        { "<leader>fE", "<cmd>Neotree float reveal<cr>", desc = "Explorer (floating)" },
        { "<leader>fB", "<cmd>Neotree buffers reveal left<cr>", desc = "Explorer: open buffers" },
        { "<leader>fG", "<cmd>Neotree git_status reveal left<cr>", desc = "Explorer: git status" },
    },
    init = function()
        -- Opening Neovim on a directory (`nvim .`) should show the tree.
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("neotree_hijack_dirs", { clear = true }),
            callback = function(event)
                if vim.fn.isdirectory(event.match) == 1 then
                    require("neo-tree")
                    return true -- one-shot: neo-tree hijacks netrw from here on
                end
            end,
        })
    end,
    opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf", "Outline" },
        sources = { "filesystem", "buffers", "git_status" },
        source_selector = {
            winbar = true, -- tabs across the top of the sidebar
            statusline = false,
            sources = {
                { source = "filesystem", display_name = "  Files" },
                { source = "buffers", display_name = "  Buffers" },
                { source = "git_status", display_name = "  Git" },
            },
        },
        default_component_configs = {
            indent = {
                with_expanders = true,
                expander_collapsed = "▸",
                expander_expanded = "▾",
                indent_marker = "│",
                last_indent_marker = "└",
            },
            git_status = {
                symbols = {
                    added = "",
                    modified = "",
                    deleted = "✖",
                    renamed = "󰁕",
                    untracked = "",
                    ignored = "",
                    unstaged = "󰄱",
                    staged = "",
                    conflict = "",
                },
            },
        },
        -- neo-tree has no built-in "open externally" or "yank path" command,
        -- so both are defined here and referenced by name in `mappings`.
        commands = {
            system_open = function(state)
                local node = state.tree:get_node()
                if node then
                    vim.ui.open(node.path) -- xdg-open on Linux
                end
            end,
            copy_path = function(state)
                local node = state.tree:get_node()
                if not node then
                    return
                end
                local path = vim.fn.fnamemodify(node.path, ":~:.")
                vim.fn.setreg("+", path)
                vim.notify(path, vim.log.levels.INFO, { title = "Copied path" })
            end,
        },
        window = {
            width = 32,
            mappings = {
                -- Open in splits, matching the window keys used everywhere else.
                ["s"] = "open_split",
                ["v"] = "open_vsplit",
                ["<space>"] = "none", -- keep <leader> usable inside the tree
                ["h"] = "close_node",
                ["l"] = "open",
                ["O"] = "system_open",
                ["Y"] = "copy_path",
                ["P"] = { "toggle_preview", config = { use_float = true } },
            },
        },
        filesystem = {
            window = { mappings = { ["H"] = "toggle_hidden" } },
            bind_to_cwd = false,
            cwd_target = { sidebar = "tab", current = "window" },
            follow_current_file = { enabled = true, leave_dirs_open = true },
            use_libuv_file_watcher = true, -- react to changes made outside Neovim
            hijack_netrw_behavior = "open_default",
            filtered_items = {
                visible = false,
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_by_name = { ".git", "node_modules", "__pycache__", ".venv", "target" },
            },
        },
        buffers = {
            follow_current_file = { enabled = true },
            show_unloaded = true,
        },
        git_status = {
            window = { position = "left" },
        },
    },
    config = function(_, opts)
        --- Keep LSP references correct when files are renamed or moved from
        --- the tree (snacks.rename drives `workspace/willRenameFiles`).
        local function on_move(data)
            Snacks.rename.on_rename_file(data.source, data.destination)
        end

        local events = require("neo-tree.events")
        opts.event_handlers = {
            { event = events.FILE_MOVED, handler = on_move },
            { event = events.FILE_RENAMED, handler = on_move },
        }

        require("neo-tree").setup(opts)

        vim.api.nvim_create_autocmd("TermClose", {
            pattern = "*lazygit",
            group = vim.api.nvim_create_augroup("neotree_git_refresh", { clear = true }),
            callback = function()
                if package.loaded["neo-tree.sources.git_status"] then
                    require("neo-tree.sources.git_status").refresh()
                end
            end,
        })
    end,
}
