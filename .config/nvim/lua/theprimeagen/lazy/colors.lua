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
end

return {

    {
      "neanias/everforest-nvim",
      version = false,
      lazy = false,
      priority = 1000, -- make sure to load this before all the other start plugins
      -- Optional; default configuration will be used if setup isn't called.
      config = function()
        require("everforest").setup({
            transparent_background_level = 2,
            })
      end,
    },

    {
      'projekt0n/github-nvim-theme',
      name = 'github-theme',
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
        require('github-theme').setup({
          -- ...
        })
      end,
    },

    {
        "ramojus/mellifluous.nvim",
        -- version = "v0.*", -- uncomment for stable config (some features might be missed if/when v1 comes out)
        config = function()
            require("mellifluous").setup({}) -- optional, see configuration section.
        end,
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
        "Shatur/neovim-ayu",
        config = function()
            require('ayu').setup({
                terminal = true,
                mirage = true,
                overrides = {
                   Normal = { bg = "None" },
                   NormalFloat = { bg = "none" },
                   ---ColorColumn = { bg = "None" },
                   SignColumn = { bg = "None" },
                   Folded = { bg = "None" },
                   FoldColumn = { bg = "None" },
                   CursorLine = { bg = "None" },
                   CursorColumn = { bg = "None" },
                   VertSplit = { bg = "None" },
               },
           })
        end
    },

    {
        "erikbackman/brightburn.vim",
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        config = function()
            ColorMyPencils()
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "", -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = true, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark", -- style for floating windows
                },
            })
        end
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })

            ColorMyPencils();
        end
    },

    {
        "RRethy/base16-nvim",
        config = function()
            require('base16-colorscheme').setup({
                base00 = '#0e0e16', -- bg (background)
                base01 = '#1a1a24', -- bg_alt (background highlight)
                base02 = '#252532', -- float_bg (line numbers, selections)
                base03 = '#707c8c', -- fg_dim (comments, virtual text)
                base04 = '#858d95', -- keyword (dark foreground)
                base05 = '#d8d8d8', -- fg (foreground)
                base06 = '#b0c0e0', --
                base07 = '#d8d8d8', -- fg (light background)

                base08 = '#ffffff', -- variables
                base09 = '#d1b77a', -- boolean/constant
                base0A = '#d1b77a', -- type
                base0B = '#54b06f', -- comment/added (green)
                base0C = '#5fa6a6', -- hint/search_current
                base0D = '#02a8ce', -- func/changed
                base0E = '#f58080', -- keyword
                base0F = '#aaaaaa', -- operator
            })

            ColorMyPencils();
        end,
    },

}
