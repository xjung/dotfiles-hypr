--- Filetype detection for languages Neovim does not ship rules for.
---
--- 1C:Enterprise uses `.bsl` for managed-application modules and `.os` for
--- OneScript; bsl-language-server handles both.
vim.filetype.add({
    extension = {
        bsl = "bsl",
        os = "os",
        epf = "bsl",
        erf = "bsl",
    },
    filename = {
        [".bsl-language-server.json"] = "jsonc",
    },
})

-- 1C sources are almost always written by Windows tooling in UTF-8 with a BOM
-- and CRLF endings; reading them without this mangles Cyrillic identifiers.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("bsl_encoding", { clear = true }),
    pattern = { "bsl", "os" },
    callback = function(event)
        vim.bo[event.buf].fileencoding = "utf-8"
        -- Cyrillic letters are word characters in 1C identifiers.
        vim.opt_local.iskeyword:append("192-255")
    end,
})
