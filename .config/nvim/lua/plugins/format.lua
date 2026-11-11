--- conform.nvim: formatting on save, with per-filetype formatters.

return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
        {
            "<leader>cf",
            function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
            mode = { "n", "x" },
            desc = "Format buffer",
        },
        {
            "<leader>uf",
            function()
                vim.g.autoformat = not vim.g.autoformat
                vim.notify("Format on save: " .. (vim.g.autoformat and "on" or "off"), vim.log.levels.INFO)
            end,
            desc = "Toggle format on save",
        },
    },
    init = function()
        vim.g.autoformat = true
        -- Let conform own gq so the operator formats with the same tools.
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_format", "ruff_organize_imports" },
            c = { "clang_format" },
            cpp = { "clang_format" },
            sh = { "shfmt" },
            bash = { "shfmt" },
            javascript = { "prettierd" },
            javascriptreact = { "prettierd" },
            typescript = { "prettierd" },
            typescriptreact = { "prettierd" },
            json = { "prettierd" },
            jsonc = { "prettierd" },
            css = { "prettierd" },
            html = { "prettierd" },
            markdown = { "prettierd" },
            yaml = { "prettierd" },
            -- rust goes through rust-analyzer, bsl through bsl-language-server.
        },
        default_format_opts = { lsp_format = "fallback" },
        format_on_save = function(buffer)
            if not vim.g.autoformat then
                return
            end
            -- Huge or generated files are never worth reformatting on save.
            if vim.api.nvim_buf_line_count(buffer) > 20000 then
                return
            end
            return { timeout_ms = 1500, lsp_format = "fallback" }
        end,
        formatters = {
            shfmt = { prepend_args = { "-i", "4", "-ci" } },
        },
    },
}
