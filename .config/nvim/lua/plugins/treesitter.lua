--- Tree-sitter powers syntax highlighting, indentation and folds.
---
--- The `main` branch dropped the old `nvim-treesitter.configs` module: parsers
--- are installed explicitly and highlighting is switched on per filetype.

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local treesitter = require("nvim-treesitter")
            treesitter.setup({})

            -- There is no dedicated jsonc grammar; reuse json for it.
            vim.treesitter.language.register("json", "jsonc")

            local wanted = {
                "bash", "c", "cpp", "css", "diff", "dockerfile", "gitcommit",
                "gitignore", "html", "javascript", "jsdoc", "json",
                "lua", "luadoc", "luap", "markdown", "markdown_inline", "python",
                "query", "regex", "rust", "sql", "toml", "tsx", "typescript",
                "vim", "vimdoc", "xml", "yaml",
            }

            local installed = treesitter.get_installed()
            local missing = vim.tbl_filter(function(lang)
                return not vim.tbl_contains(installed, lang)
            end, wanted)
            if #missing > 0 then
                treesitter.install(missing)
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
                callback = function(event)
                    local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
                    -- `pcall` keeps filetypes without a parser (bsl, os) quiet.
                    if not lang or not pcall(vim.treesitter.start, event.buf, lang) then
                        return
                    end
                    vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },

    {
        -- Structural text objects: `af`/`if` for a function, `ac`/`ic` for a
        -- class, `aa`/`ia` for an argument, on top of the built-in ones.
        "nvim-mini/mini.ai",
        event = "VeryLazy",
        -- The `@function.outer` style queries live in the textobjects repo.
        dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" } },
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
                    a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
                    o = ai.gen_spec.treesitter({
                        a = { "@conditional.outer", "@loop.outer" },
                        i = { "@conditional.inner", "@loop.inner" },
                    }),
                },
            }
        end,
    },

    {
        -- Keeps the enclosing function/class visible at the top of the window
        -- while scrolling, like VS Code's sticky scroll.
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        opts = { max_lines = 3, multiline_threshold = 1, separator = "─" },
        keys = {
            { "<leader>ux", "<cmd>TSContextToggle<cr>", desc = "Toggle sticky context" },
        },
    },
}
