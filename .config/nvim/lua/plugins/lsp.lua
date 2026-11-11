--- Language servers.
---
--- Neovim 0.11+ configures servers through `vim.lsp.config`/`vim.lsp.enable`;
--- nvim-lspconfig only supplies the per-server defaults (cmd, filetypes, root
--- markers) and mason installs the binaries.

--- Language servers to install and configure, keyed by their lspconfig name.
--- `rust_analyzer` is deliberately absent: rustaceanvim owns it.
local servers = {
    lua_ls = {
        settings = {
            Lua = {
                workspace = { checkThirdParty = false },
                codeLens = { enable = true },
                hint = { enable = true, arrayIndex = "Disable" },
                format = { enable = false }, -- stylua does this
                diagnostics = { globals = { "vim", "Snacks" } },
            },
        },
    },

    clangd = {
        cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
        },
        init_options = { clangdFileStatus = true },
    },

    basedpyright = {
        settings = {
            basedpyright = {
                analysis = {
                    typeCheckingMode = "standard",
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                    inlayHints = { variableTypes = true, callArgumentNames = true },
                },
            },
        },
    },

    -- ruff handles linting and import sorting; basedpyright keeps hover.
    ruff = {
        on_attach = function(client)
            client.server_capabilities.hoverProvider = false
        end,
    },

    vtsls = {
        settings = {
            typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                inlayHints = {
                    parameterNames = { enabled = "literals" },
                    variableTypes = { enabled = false },
                    propertyDeclarationTypes = { enabled = true },
                    functionLikeReturnTypes = { enabled = true },
                },
            },
            javascript = {
                updateImportsOnFileMove = { enabled = "always" },
            },
            vtsls = { experimental = { completion = { enableServerSideFuzzyMatch = true } } },
        },
    },

    -- 1C:Enterprise / OneScript. nvim-lspconfig ships no `cmd` for this one,
    -- so point it at the launcher mason drops on the PATH. Needs a JRE.
    bsl_ls = {
        cmd = { "bsl-language-server" },
        filetypes = { "bsl", "os" },
        root_markers = { ".bsl-language-server.json", "src", ".git" },
    },
}

--- Formatters and linters mason should keep installed. These are not
--- language servers, so mason-lspconfig does not know about them.
local tools = { "stylua", "shfmt", "clang-format", "prettierd" }

return {
    -----------------------------------------------------------------------
    -- mason: installs language servers, formatters and linters.
    -----------------------------------------------------------------------
    {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
        build = ":MasonUpdate",
        opts = { ui = { border = "rounded" } },
        config = function(_, opts)
            require("mason").setup(opts)

            -- mason.nvim has no `ensure_installed` of its own, so drive the
            -- registry directly once it has refreshed.
            local registry = require("mason-registry")
            local function install_missing()
                for _, name in ipairs(tools) do
                    local ok, package = pcall(registry.get_package, name)
                    if ok and not package:is_installed() then
                        package:install()
                    end
                end
            end

            if registry.refresh then
                registry.refresh(install_missing)
            else
                install_missing()
            end
        end,
    },

    -- Loaded as a dependency below and set up by hand, so that every
    -- `vim.lsp.config` call lands before any server is enabled.
    { "mason-org/mason-lspconfig.nvim", lazy = true },

    -----------------------------------------------------------------------
    -- nvim-lspconfig: per-server defaults plus our keymaps and diagnostics.
    -----------------------------------------------------------------------
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },
        keys = {
            { "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", desc = "LSP info" },
            { "<leader>cL", "<cmd>LspRestart<cr>", desc = "Restart LSP" },
        },
        config = function()
            -- Advertise blink.cmp's completion capabilities to every server.
            vim.lsp.config("*", {
                capabilities = require("blink.cmp").get_lsp_capabilities(nil, true),
            })

            for name, config in pairs(servers) do
                vim.lsp.config(name, config)
            end

            require("mason-lspconfig").setup({
                ensure_installed = vim.list_extend(vim.tbl_keys(servers), { "rust_analyzer" }),
                -- Enable exactly the servers configured above. rust_analyzer
                -- is installed but left to rustaceanvim, and mason tools that
                -- happen to ship an LSP mode (stylua) stay out of the way.
                automatic_enable = vim.tbl_keys(servers),
            })

            vim.diagnostic.config({
                severity_sort = true,
                underline = { severity = vim.diagnostic.severity.WARN },
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    prefix = "●",
                    source = "if_many",
                    severity = { min = vim.diagnostic.severity.WARN },
                },
                float = {
                    border = "rounded",
                    source = "if_many",
                    header = "",
                    prefix = "",
                },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                    },
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
                callback = function(event)
                    local buffer = event.buf

                    --- Buffer-local mapping helper.
                    ---@param mode string|string[]
                    ---@param lhs string
                    ---@param rhs string|function
                    ---@param desc string
                    local function map(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = buffer, silent = true, desc = desc })
                    end

                    -- Navigation goes through telescope so results are
                    -- previewable and fuzzy-filterable. Wrapping each one in a
                    -- closure keeps telescope lazy until a key is pressed.
                    ---@param picker string Name of a `telescope.builtin` picker.
                    ---@return function
                    local function pick(picker)
                        return function() require("telescope.builtin")[picker]() end
                    end

                    map("n", "gd", pick("lsp_definitions"), "Go to definition")
                    map("n", "gr", pick("lsp_references"), "Go to references")
                    map("n", "gI", pick("lsp_implementations"), "Go to implementation")
                    map("n", "gy", pick("lsp_type_definitions"), "Go to type definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")

                    map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end,
                        "Hover documentation")
                    map("n", "gK", function() vim.lsp.buf.signature_help({ border = "rounded" }) end,
                        "Signature help")
                    map("i", "<C-k>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end,
                        "Signature help")

                    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
                    map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
                    map("n", "<leader>cc", vim.lsp.codelens.run, "Run code lens")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client:supports_method("textDocument/inlayHint") then
                        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
                    end
                end,
            })
        end,
    },

    -----------------------------------------------------------------------
    -- Language-specific extras.
    -----------------------------------------------------------------------
    {
        -- Full rust-analyzer integration: runnables, macro expansion,
        -- `Cargo.toml` navigation and rendered compiler diagnostics.
        "mrcjkb/rustaceanvim",
        version = "^9",
        lazy = false, -- the plugin registers its own filetype hooks
        init = function()
            vim.g.rustaceanvim = {
                server = {
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = { allFeatures = true, buildScripts = { enable = true } },
                            checkOnSave = true,
                            check = { command = "clippy", extraArgs = { "--no-deps" } },
                            procMacro = { enable = true },
                            inlayHints = {
                                lifetimeElisionHints = { enable = "skip_trivial" },
                                closureReturnTypeHints = { enable = "with_block" },
                            },
                            files = { excludeDirs = { ".direnv", "target", "node_modules" } },
                        },
                    },
                },
            }

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("rust_keymaps", { clear = true }),
                pattern = "rust",
                callback = function(event)
                    ---@param lhs string
                    ---@param subcommand string
                    ---@param desc string
                    local function map(lhs, subcommand, desc)
                        vim.keymap.set("n", lhs, "<cmd>RustLsp " .. subcommand .. "<cr>",
                            { buffer = event.buf, silent = true, desc = desc })
                    end

                    map("K", "hover actions", "Hover actions")
                    map("<leader>ca", "codeAction", "Code action (rust)")
                    map("<leader>cR", "runnables", "Runnables")
                    map("<leader>cT", "testables", "Testables")
                    map("<leader>cm", "expandMacro", "Expand macro")
                    map("<leader>cM", "openCargo", "Open Cargo.toml")
                    map("<leader>cD", "openDocs", "Open docs.rs")
                    map("<leader>ce", "explainError", "Explain error")
                    map("<leader>cp", "parentModule", "Parent module")
                end,
            })
        end,
    },

    {
        -- Type information for the Neovim API while editing this config.
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim", words = { "Snacks" } },
            },
        },
    },

    {
        -- LSP progress in the bottom-right corner.
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            progress = { display = { done_icon = "" } },
            notification = { window = { winblend = 0 } },
        },
    },
}
