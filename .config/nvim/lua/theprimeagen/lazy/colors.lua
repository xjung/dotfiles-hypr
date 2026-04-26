function ColorMyPencils(color)
	color = color or "rose-pine-moon"
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })  -- For inactive windows
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "Folded", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "FoldedColumn", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })

    ---vim.api.nvim_set_hl(0, 'Search', { bg = '#4a4a4a' })

    ---vim.api.nvim_set_hl(0, "TSFuncMacro", { fg = "#e5b567" })
    ---vim.api.nvim_set_hl(0, "Comment", { fg = '#54706f', italic = true })
end

return {

    {
        "catppuccin/nvim",
        flavour = "auto", -- latte, frappe, macchiato, mocha
        background = { -- :h background
            light = "latte",
            dark = "mocha",
        },
        transparent_background = true, -- disables setting the background color.
        float = {
            transparent = true, -- enable transparent floating windows
            solid = false, -- use solid styling for floating windows, see |winborder|
        },
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = false, -- dims the background color of inactive window
            shade = "dark",
            percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = { "italic" }, -- Change the style of comments
            conditionals = { "italic" },
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
            -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        lsp_styles = { -- Handles the style of specific lsp hl groups (see `:h lsp-highlight`).
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
                ok = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
                ok = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        auto_integrations = false,
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            notify = false,
            mini = {
                enabled = true,
                indentscope_color = "",
            },
            -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
    },

    {
        "yonatan-perel/lake-dweller.nvim",
        config = function()
            require("lake-dweller").setup({
                variant = "ocean-dweller",
                transparent = true,  -- Enables your preferred transparency
                italics = true,
            })
        end
    },

    {
        "RRethy/base16-nvim",
        config = function()
            require('base16-colorscheme').setup({
                -- Warm Evening Study - increased contrast
                base00 = '#100d14', -- bg (deeper, richer dark)
                base01 = '#1d1924', -- bg_alt (clearer separation from bg)
                base02 = '#2b2535', -- float_bg (more visible, still warm)
                base03 = '#7a7480', -- fg_dim (brighter comments, easier to read)
                base04 = '#706878', -- keyword (more present while staying muted)
                base05 = '#e0d6c8', -- fg (brighter warm cream, crisp against dark bg)
                base06 = '#ece2d2', --
                base07 = '#f4ead8', -- fg (light background, warm and bright)

                base08 = '#e0b5a0', -- variables (more vivid rose clay)
                base09 = '#e8a37e', -- boolean/constant (punchy terracotta)
                base0A = '#96d0f5', -- type (bright light sky blue, clearly visible)
                base0B = '#8cbc90', -- comment/added (fresher sage green)
                base0C = '#42c0e2', -- hint/search_current (brighter medium blue)
                base0D = '#5f9cd6', -- func/changed (strong deep blue, function names pop)
                base0E = '#a098b8', -- keyword (more visible violet-gray, but still muted)
                base0F = '#bfb2a0', -- operator (clear warm stone)
            })

            ColorMyPencils();
        end,
        },
    }
