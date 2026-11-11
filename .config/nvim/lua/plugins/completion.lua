--- blink.cmp: completion, snippets and signature help.

return {
    "saghen/blink.cmp",
    version = "1.*", -- a release tag ships the prebuilt fuzzy-matcher binary
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            -- `default` keeps the <C-y> / <C-n> / <C-p> muscle memory; Tab and
            -- Enter are layered on top for a VS Code-like feel.
            preset = "default",
            ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
            ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
        },
        appearance = { nerd_font_variant = "mono" },
        completion = {
            accept = { auto_brackets = { enabled = true } },
            -- Nothing is preselected, so <CR> stays a newline until you have
            -- deliberately moved through the list.
            list = { selection = { preselect = false, auto_insert = true } },
            menu = {
                border = "rounded",
                winblend = 0,
                draw = { treesitter = { "lsp" } },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = { border = "rounded", winblend = 0 },
            },
            ghost_text = { enabled = false },
        },
        signature = { enabled = true, window = { border = "rounded" } },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        cmdline = {
            enabled = true,
            keymap = { preset = "cmdline" },
            completion = { menu = { auto_show = true } },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
