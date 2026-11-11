--- "2026 Dark" - a port of the Visual Studio Code / Code OSS default dark
--- theme, built for a transparent terminal so the compositor blur shows
--- through.
---
--- Usage:
---     vim.g.dark_2026_transparent = true   -- default
---     vim.cmd.colorscheme("dark-2026")
---
--- Toggle transparency at runtime with `require("dark-2026").toggle()`.
local p = require("dark-2026.palette")

local M = {}

--- Build the full highlight table for the requested transparency mode.
---
--- Lua note for a Python reader: `t and a or b` is Lua's ternary. It is safe
--- here because `a` is never `false`/`nil`.
---
---@param transparent boolean When true, structural backgrounds become "NONE".
---@return table<string, table> highlights Map of group name to `nvim_set_hl` options.
local function build(transparent)
    local ui, syn, diag, git = p.ui, p.syn, p.diag, p.git
    local NONE = "NONE"

    -- Structural backgrounds: dropped entirely in transparent mode so the
    -- terminal (and its blur) shows through.
    local bg = transparent and NONE or ui.bg
    local bg_dark = transparent and NONE or ui.bg_dark
    local bg_float = transparent and NONE or ui.bg_float
    local bg_input = transparent and NONE or ui.bg_input
    -- The current-line fill is a solid block, which would punch a hole in the
    -- blur, so transparent mode drops it and relies on a bright CursorLineNr.
    local bg_line = transparent and NONE or ui.bg_line
    local bg_hover = transparent and ui.bg_visual_soft or ui.bg_hover

    return {
        ---------------------------------------------------------------- editor
        Normal = { fg = ui.fg, bg = bg },
        NormalNC = { fg = ui.fg, bg = bg },
        NormalSB = { fg = ui.fg, bg = bg_dark },
        NormalFloat = { fg = ui.fg, bg = bg_float },
        FloatBorder = { fg = ui.border_light, bg = bg_float },
        FloatTitle = { fg = ui.accent, bg = bg_float, bold = true },
        FloatFooter = { fg = ui.fg_muted, bg = bg_float },

        ColorColumn = { bg = ui.bg_dark },
        Conceal = { fg = ui.fg_muted },
        Cursor = { fg = ui.bg, bg = ui.cursor },
        lCursor = { fg = ui.bg, bg = ui.cursor },
        CursorIM = { fg = ui.bg, bg = ui.cursor },
        CursorLine = { bg = bg_line },
        CursorColumn = { bg = bg_line },
        CursorLineNr = { fg = ui.fg_bright, bold = true },
        LineNr = { fg = ui.fg_muted },
        LineNrAbove = { fg = ui.fg_muted },
        LineNrBelow = { fg = ui.fg_muted },
        SignColumn = { fg = ui.fg_muted, bg = bg },
        FoldColumn = { fg = ui.fg_muted, bg = bg },
        Folded = { fg = ui.fg_dim, bg = bg_input },
        CursorLineFold = { fg = ui.fg_dim, bg = bg_line },
        CursorLineSign = { bg = bg_line },

        Directory = { fg = ui.fg },
        EndOfBuffer = { fg = transparent and ui.bg_dark or ui.bg },
        ErrorMsg = { fg = diag.error },
        WarningMsg = { fg = diag.warn },
        ModeMsg = { fg = ui.fg, bold = true },
        MoreMsg = { fg = ui.accent },
        MsgArea = { fg = ui.fg },
        MsgSeparator = { fg = ui.border, bg = bg },
        NonText = { fg = ui.whitespace },
        Whitespace = { fg = ui.whitespace },
        SpecialKey = { fg = ui.whitespace },
        Question = { fg = ui.accent },
        QuickFixLine = { bg = ui.bg_active },

        Pmenu = { fg = ui.fg, bg = bg_float },
        PmenuSel = { fg = ui.fg_bright, bg = ui.bg_active, bold = true },
        PmenuKind = { fg = syn.type, bg = bg_float },
        PmenuKindSel = { fg = syn.type, bg = ui.bg_active },
        PmenuExtra = { fg = ui.fg_muted, bg = bg_float },
        PmenuExtraSel = { fg = ui.fg_dim, bg = ui.bg_active },
        PmenuSbar = { bg = ui.bg_input },
        PmenuThumb = { bg = ui.scrollbar },
        PmenuMatch = { fg = ui.match, bold = true },
        PmenuMatchSel = { fg = ui.match, bg = ui.bg_active, bold = true },
        WildMenu = { fg = ui.fg_bright, bg = ui.bg_active, bold = true },

        Search = { fg = ui.fg_bright, bg = ui.bg_search },
        IncSearch = { fg = ui.fg_bright, bg = ui.bg_search_cur, bold = true },
        CurSearch = { fg = ui.fg_bright, bg = ui.bg_search_cur, bold = true },
        Substitute = { fg = ui.bg, bg = diag.warn },
        MatchParen = { fg = ui.fg_bright, bg = ui.bg_paren, bold = true },

        SpellBad = { sp = diag.error, undercurl = true },
        SpellCap = { sp = diag.warn, undercurl = true },
        SpellLocal = { sp = diag.info, undercurl = true },
        SpellRare = { sp = diag.hint, undercurl = true },

        StatusLine = { fg = ui.fg, bg = bg_dark },
        StatusLineNC = { fg = ui.fg_muted, bg = bg_dark },
        TabLine = { fg = ui.fg_muted, bg = bg_dark },
        TabLineFill = { bg = bg_dark },
        TabLineSel = { fg = ui.fg_bright, bg = bg, bold = true },
        WinBar = { fg = ui.fg_dim, bg = bg },
        WinBarNC = { fg = ui.fg_muted, bg = bg },

        Title = { fg = ui.accent, bold = true },
        VertSplit = { fg = ui.border, bg = bg },
        WinSeparator = { fg = ui.border, bg = bg },
        Visual = { bg = ui.bg_visual },
        VisualNOS = { bg = ui.bg_visual_soft },

        DiffAdd = { bg = git.bg_add },
        DiffChange = { bg = git.bg_change },
        DiffDelete = { bg = git.bg_delete },
        DiffText = { bg = git.bg_text },
        Added = { fg = git.added },
        Changed = { fg = git.modified },
        Removed = { fg = git.deleted },
        diffAdded = { fg = git.added },
        diffChanged = { fg = git.modified },
        diffRemoved = { fg = git.deleted },
        diffFile = { fg = syn.type },
        diffNewFile = { fg = git.added },
        diffOldFile = { fg = git.deleted },
        diffLine = { fg = ui.fg_muted },
        diffIndexLine = { fg = ui.fg_muted },

        ---------------------------------------------------- legacy vim syntax
        Comment = { fg = syn.comment },
        Constant = { fg = syn.constant },
        String = { fg = syn.string },
        Character = { fg = syn.string },
        Number = { fg = syn.number },
        Float = { fg = syn.number },
        Boolean = { fg = syn.builtin },
        Identifier = { fg = syn.variable },
        Function = { fg = syn.func },
        Statement = { fg = syn.control },
        Conditional = { fg = syn.control },
        Repeat = { fg = syn.control },
        Label = { fg = syn.label },
        Keyword = { fg = syn.control },
        Exception = { fg = syn.control },
        Operator = { fg = syn.operator },
        PreProc = { fg = syn.control },
        Include = { fg = syn.control },
        Define = { fg = syn.control },
        Macro = { fg = syn.control },
        PreCondit = { fg = syn.control },
        Type = { fg = syn.keyword },
        StorageClass = { fg = syn.builtin },
        Structure = { fg = syn.keyword },
        Typedef = { fg = syn.builtin },
        Special = { fg = syn.escape },
        SpecialChar = { fg = syn.escape },
        SpecialComment = { fg = syn.comment },
        Tag = { fg = syn.tag },
        Delimiter = { fg = syn.punct },
        Debug = { fg = syn.control },
        Todo = { fg = ui.bg, bg = diag.warn, bold = true },
        Error = { fg = syn.invalid },
        Underlined = { underline = true },
        Ignore = { fg = ui.fg_muted },

        ------------------------------------------------------- tree-sitter
        ["@variable"] = { fg = syn.variable },
        ["@variable.builtin"] = { fg = syn.constant },
        ["@variable.parameter"] = { fg = syn.variable },
        ["@variable.parameter.builtin"] = { fg = syn.constant },
        ["@variable.member"] = { fg = syn.variable },
        ["@constant"] = { fg = syn.constant },
        ["@constant.builtin"] = { fg = syn.builtin },
        ["@constant.macro"] = { fg = syn.constant },
        ["@module"] = { fg = syn.type },
        ["@module.builtin"] = { fg = syn.type },
        ["@label"] = { fg = syn.label },

        ["@string"] = { fg = syn.string },
        ["@string.documentation"] = { fg = syn.string },
        ["@string.regexp"] = { fg = syn.regex },
        ["@string.escape"] = { fg = syn.escape },
        ["@string.special"] = { fg = syn.escape },
        ["@string.special.symbol"] = { fg = syn.variable },
        ["@string.special.url"] = { fg = ui.accent, underline = true },
        ["@character"] = { fg = syn.string },
        ["@character.special"] = { fg = syn.escape },
        ["@boolean"] = { fg = syn.builtin },
        ["@number"] = { fg = syn.number },
        ["@number.float"] = { fg = syn.number },

        ["@type"] = { fg = syn.type },
        ["@type.builtin"] = { fg = syn.keyword },
        ["@type.definition"] = { fg = syn.type },
        ["@type.qualifier"] = { fg = syn.builtin },
        ["@attribute"] = { fg = syn.func },
        ["@attribute.builtin"] = { fg = syn.func },
        ["@property"] = { fg = syn.variable },
        -- `support.type.property-name.json` is green in this theme.
        ["@property.json"] = { fg = syn.tag },
        ["@property.jsonc"] = { fg = syn.tag },
        ["@property.yaml"] = { fg = syn.tag },

        ["@function"] = { fg = syn.func },
        ["@function.builtin"] = { fg = syn.func_builtin },
        ["@function.call"] = { fg = syn.func },
        ["@function.macro"] = { fg = syn.func },
        ["@function.method"] = { fg = syn.func },
        ["@function.method.call"] = { fg = syn.func },
        ["@constructor"] = { fg = syn.type },
        ["@operator"] = { fg = syn.operator },

        ["@keyword"] = { fg = syn.control },
        ["@keyword.coroutine"] = { fg = syn.control },
        ["@keyword.function"] = { fg = syn.keyword },
        ["@keyword.operator"] = { fg = syn.control },
        ["@keyword.import"] = { fg = syn.control },
        ["@keyword.type"] = { fg = syn.keyword },
        ["@keyword.modifier"] = { fg = syn.builtin },
        ["@keyword.repeat"] = { fg = syn.control },
        ["@keyword.return"] = { fg = syn.control },
        ["@keyword.debug"] = { fg = syn.control },
        ["@keyword.exception"] = { fg = syn.control },
        ["@keyword.conditional"] = { fg = syn.control },
        ["@keyword.conditional.ternary"] = { fg = syn.operator },
        ["@keyword.directive"] = { fg = syn.control },
        ["@keyword.directive.define"] = { fg = syn.control },

        ["@punctuation.delimiter"] = { fg = syn.punct },
        ["@punctuation.bracket"] = { fg = syn.punct },
        ["@punctuation.special"] = { fg = syn.keyword },

        ["@comment"] = { fg = syn.comment },
        ["@comment.documentation"] = { fg = syn.comment },
        ["@comment.error"] = { fg = ui.bg, bg = diag.error, bold = true },
        ["@comment.warning"] = { fg = ui.bg, bg = diag.warn, bold = true },
        ["@comment.todo"] = { fg = ui.bg, bg = diag.info, bold = true },
        ["@comment.note"] = { fg = ui.bg, bg = diag.ok, bold = true },

        ["@markup.strong"] = { fg = syn.variable, bold = true },
        ["@markup.italic"] = { italic = true },
        ["@markup.strikethrough"] = { strikethrough = true },
        ["@markup.underline"] = { underline = true },
        ["@markup.heading"] = { fg = syn.constant, bold = true },
        ["@markup.quote"] = { fg = syn.tag },
        ["@markup.math"] = { fg = syn.number },
        ["@markup.link"] = { fg = syn.variable },
        ["@markup.link.label"] = { fg = syn.variable },
        ["@markup.link.url"] = { fg = syn.string, underline = true },
        ["@markup.raw"] = { fg = syn.constant },
        ["@markup.raw.block"] = { fg = syn.constant },
        ["@markup.list"] = { fg = syn.changed },
        ["@markup.list.checked"] = { fg = diag.ok },
        ["@markup.list.unchecked"] = { fg = ui.fg_muted },

        ["@diff.plus"] = { fg = syn.tag },
        ["@diff.minus"] = { fg = syn.invalid },
        ["@diff.delta"] = { fg = syn.changed },

        ["@tag"] = { fg = syn.tag },
        ["@tag.builtin"] = { fg = syn.tag },
        ["@tag.attribute"] = { fg = syn.attribute },
        ["@tag.delimiter"] = { fg = syn.punct },

        --------------------------------------------- LSP semantic tokens
        -- These win over tree-sitter, so they must mirror the rules above or
        -- files flip colour the moment the language server attaches.
        ["@lsp.type.class"] = { fg = syn.type },
        ["@lsp.type.comment"] = {}, -- defer to tree-sitter (keeps italics)
        ["@lsp.type.decorator"] = { fg = syn.func },
        ["@lsp.type.enum"] = { fg = syn.type },
        ["@lsp.type.enumMember"] = { fg = syn.constant },
        ["@lsp.type.event"] = { fg = syn.variable },
        ["@lsp.type.function"] = { fg = syn.func },
        ["@lsp.type.interface"] = { fg = syn.type },
        ["@lsp.type.keyword"] = { fg = syn.control },
        ["@lsp.type.macro"] = { fg = syn.func },
        ["@lsp.type.method"] = { fg = syn.func },
        ["@lsp.type.modifier"] = { fg = syn.builtin },
        ["@lsp.type.namespace"] = { fg = syn.type },
        ["@lsp.type.number"] = { fg = syn.number },
        ["@lsp.type.operator"] = { fg = syn.operator },
        ["@lsp.type.parameter"] = { fg = syn.variable },
        ["@lsp.type.property"] = { fg = syn.variable },
        ["@lsp.type.regexp"] = { fg = syn.regex },
        ["@lsp.type.string"] = { fg = syn.string },
        ["@lsp.type.struct"] = { fg = syn.type },
        ["@lsp.type.type"] = { fg = syn.type },
        ["@lsp.type.typeParameter"] = { fg = syn.type },
        ["@lsp.type.variable"] = { fg = syn.variable },
        -- rust-analyzer / clangd extensions
        ["@lsp.type.builtinType"] = { fg = syn.keyword },
        ["@lsp.type.selfKeyword"] = { fg = syn.constant },
        ["@lsp.type.selfTypeKeyword"] = { fg = syn.constant },
        ["@lsp.type.lifetime"] = { fg = syn.builtin },
        ["@lsp.type.generic"] = { fg = syn.variable },
        ["@lsp.type.deriveHelper"] = { fg = syn.func },
        ["@lsp.type.escapeSequence"] = { fg = syn.escape },
        ["@lsp.type.formatSpecifier"] = { fg = syn.control },
        ["@lsp.type.label"] = { fg = syn.label },
        ["@lsp.typemod.variable.constant"] = { fg = syn.constant },
        ["@lsp.typemod.variable.static"] = { fg = syn.constant },
        ["@lsp.typemod.variable.readonly"] = { fg = syn.constant },
        ["@lsp.typemod.variable.defaultLibrary"] = { fg = syn.type },
        ["@lsp.typemod.function.defaultLibrary"] = { fg = syn.func_builtin },
        ["@lsp.typemod.type.defaultLibrary"] = { fg = syn.type },
        ["@lsp.typemod.class.defaultLibrary"] = { fg = syn.type },
        ["@lsp.typemod.keyword.async"] = { fg = syn.control },
        ["@lsp.typemod.operator.injected"] = { fg = syn.operator },
        ["@lsp.typemod.string.injected"] = { fg = syn.string },
        ["@lsp.typemod.variable.injected"] = { fg = syn.variable },
        ["@lsp.mod.deprecated"] = { strikethrough = true },

        --------------------------------------------------------- diagnostics
        DiagnosticError = { fg = diag.error },
        DiagnosticWarn = { fg = diag.warn },
        DiagnosticInfo = { fg = diag.info },
        DiagnosticHint = { fg = diag.hint },
        DiagnosticOk = { fg = diag.ok },
        DiagnosticVirtualTextError = { fg = diag.error, italic = true },
        DiagnosticVirtualTextWarn = { fg = diag.warn, italic = true },
        DiagnosticVirtualTextInfo = { fg = diag.info, italic = true },
        DiagnosticVirtualTextHint = { fg = diag.hint, italic = true },
        DiagnosticVirtualTextOk = { fg = diag.ok, italic = true },
        DiagnosticUnderlineError = { sp = diag.error, undercurl = true },
        DiagnosticUnderlineWarn = { sp = diag.warn, undercurl = true },
        DiagnosticUnderlineInfo = { sp = diag.info, undercurl = true },
        DiagnosticUnderlineHint = { sp = diag.hint, undercurl = true },
        DiagnosticUnderlineOk = { sp = diag.ok, undercurl = true },
        DiagnosticFloatingError = { fg = diag.error, bg = bg_float },
        DiagnosticFloatingWarn = { fg = diag.warn, bg = bg_float },
        DiagnosticFloatingInfo = { fg = diag.info, bg = bg_float },
        DiagnosticFloatingHint = { fg = diag.hint, bg = bg_float },
        DiagnosticSignError = { fg = diag.error },
        DiagnosticSignWarn = { fg = diag.warn },
        DiagnosticSignInfo = { fg = diag.info },
        DiagnosticSignHint = { fg = diag.hint },
        -- Code OSS dims unreachable / unused code instead of underlining it.
        DiagnosticUnnecessary = { fg = ui.fg_ghost },
        DiagnosticDeprecated = { sp = ui.fg_muted, strikethrough = true },

        LspInlayHint = { fg = ui.fg_ghost, bg = NONE },
        LspCodeLens = { fg = ui.fg_ghost, italic = true },
        LspCodeLensSeparator = { fg = ui.fg_ghost },
        LspReferenceText = { bg = ui.bg_visual_soft },
        LspReferenceRead = { bg = ui.bg_visual_soft },
        LspReferenceWrite = { bg = ui.bg_visual_soft, underline = true },
        LspSignatureActiveParameter = { fg = ui.accent, bold = true },
        LspInfoBorder = { fg = ui.border_light, bg = bg_float },

        ------------------------------------------------------------ telescope
        TelescopeNormal = { fg = ui.fg, bg = bg_float },
        TelescopeBorder = { fg = ui.border_light, bg = bg_float },
        TelescopeTitle = { fg = ui.fg_muted, bg = bg_float },
        TelescopePromptNormal = { fg = ui.fg, bg = bg_float },
        TelescopePromptBorder = { fg = ui.border_light, bg = bg_float },
        TelescopePromptTitle = { fg = ui.bg, bg = ui.accent, bold = true },
        TelescopePromptPrefix = { fg = ui.accent },
        TelescopePromptCounter = { fg = ui.fg_muted },
        TelescopeResultsNormal = { fg = ui.fg, bg = bg_float },
        TelescopeResultsBorder = { fg = ui.border_light, bg = bg_float },
        TelescopeResultsTitle = { fg = bg_float, bg = bg_float },
        TelescopeResultsDiffAdd = { fg = git.added },
        TelescopeResultsDiffChange = { fg = git.modified },
        TelescopeResultsDiffDelete = { fg = git.deleted },
        TelescopePreviewNormal = { fg = ui.fg, bg = bg_float },
        TelescopePreviewBorder = { fg = ui.border_light, bg = bg_float },
        TelescopePreviewTitle = { fg = ui.bg, bg = diag.ok, bold = true },
        TelescopePreviewLine = { bg = ui.bg_visual_soft },
        TelescopeSelection = { fg = ui.fg_bright, bg = ui.bg_active },
        TelescopeSelectionCaret = { fg = ui.accent, bg = ui.bg_active },
        TelescopeMultiSelection = { fg = syn.constant },
        TelescopeMultiIcon = { fg = syn.constant },
        TelescopeMatching = { fg = ui.match, bold = true },

        ------------------------------------------------------------- neo-tree
        NeoTreeNormal = { fg = ui.fg, bg = bg_dark },
        NeoTreeNormalNC = { fg = ui.fg, bg = bg_dark },
        NeoTreeEndOfBuffer = { fg = transparent and ui.bg_dark or ui.bg_dark, bg = bg_dark },
        NeoTreeWinSeparator = { fg = ui.border, bg = bg_dark },
        NeoTreeVertSplit = { fg = ui.border, bg = bg_dark },
        NeoTreeRootName = { fg = ui.fg_bright, bold = true },
        NeoTreeTitleBar = { fg = ui.bg, bg = ui.accent, bold = true },
        NeoTreeDirectoryName = { fg = ui.fg },
        NeoTreeDirectoryIcon = { fg = syn.type },
        NeoTreeFileName = { fg = ui.fg },
        NeoTreeFileNameOpened = { fg = ui.fg_bright, bold = true },
        NeoTreeFileIcon = { fg = ui.fg_dim },
        NeoTreeIndentMarker = { fg = ui.indent },
        NeoTreeExpander = { fg = ui.fg_muted },
        NeoTreeDimText = { fg = ui.fg_muted },
        NeoTreeMessage = { fg = ui.fg_muted, italic = true },
        NeoTreeModified = { fg = git.modified },
        NeoTreeFilterTerm = { fg = ui.match, bold = true },
        NeoTreeCursorLine = { bg = bg_hover, bold = true },
        NeoTreeFloatBorder = { fg = ui.border_light, bg = bg_float },
        NeoTreeFloatTitle = { fg = ui.accent, bg = bg_float, bold = true },
        NeoTreeGitAdded = { fg = git.added },
        NeoTreeGitModified = { fg = git.modified },
        NeoTreeGitDeleted = { fg = git.deleted },
        NeoTreeGitRenamed = { fg = git.modified },
        NeoTreeGitUntracked = { fg = git.untracked },
        NeoTreeGitIgnored = { fg = git.ignored },
        NeoTreeGitConflict = { fg = git.conflict, bold = true },
        NeoTreeGitStaged = { fg = git.added },
        NeoTreeGitUnstaged = { fg = git.modified },
        NeoTreeTabActive = { fg = ui.fg_bright, bg = bg, bold = true },
        NeoTreeTabInactive = { fg = ui.fg_muted, bg = bg_dark },
        NeoTreeTabSeparatorActive = { fg = ui.accent, bg = bg },
        NeoTreeTabSeparatorInactive = { fg = ui.border, bg = bg_dark },

        ------------------------------------------------------------ which-key
        WhichKey = { fg = syn.control },
        WhichKeyGroup = { fg = ui.accent },
        WhichKeyDesc = { fg = ui.fg },
        WhichKeySeparator = { fg = ui.fg_muted },
        WhichKeyValue = { fg = ui.fg_muted },
        WhichKeyNormal = { fg = ui.fg, bg = bg_float },
        WhichKeyBorder = { fg = ui.border_light, bg = bg_float },
        WhichKeyTitle = { fg = ui.accent, bg = bg_float, bold = true },

        ----------------------------------------------------------- blink.cmp
        BlinkCmpMenu = { fg = ui.fg, bg = bg_float },
        BlinkCmpMenuBorder = { fg = ui.border_light, bg = bg_float },
        BlinkCmpMenuSelection = { fg = ui.fg_bright, bg = ui.bg_active, bold = true },
        BlinkCmpScrollBarThumb = { bg = ui.scrollbar },
        BlinkCmpScrollBarGutter = { bg = bg_input },
        BlinkCmpLabel = { fg = ui.fg },
        BlinkCmpLabelDeprecated = { fg = ui.fg_muted, strikethrough = true },
        BlinkCmpLabelMatch = { fg = ui.match, bold = true },
        BlinkCmpLabelDetail = { fg = ui.fg_muted },
        BlinkCmpLabelDescription = { fg = ui.fg_muted },
        BlinkCmpSource = { fg = ui.fg_muted },
        BlinkCmpGhostText = { fg = ui.fg_ghost, italic = true },
        BlinkCmpDoc = { fg = ui.fg, bg = bg_float },
        BlinkCmpDocBorder = { fg = ui.border_light, bg = bg_float },
        BlinkCmpDocSeparator = { fg = ui.border, bg = bg_float },
        BlinkCmpDocCursorLine = { bg = ui.bg_visual_soft },
        BlinkCmpSignatureHelp = { fg = ui.fg, bg = bg_float },
        BlinkCmpSignatureHelpBorder = { fg = ui.border_light, bg = bg_float },
        BlinkCmpSignatureHelpActiveParameter = { fg = ui.accent, bold = true },
        BlinkCmpKind = { fg = ui.fg_dim },

        ------------------------------------------------------------- gitsigns
        GitSignsAdd = { fg = git.added },
        GitSignsChange = { fg = git.modified },
        GitSignsDelete = { fg = git.deleted },
        GitSignsUntracked = { fg = git.untracked },
        GitSignsAddInline = { bg = git.bg_add },
        GitSignsChangeInline = { bg = git.bg_change },
        GitSignsDeleteInline = { bg = git.bg_delete },
        GitSignsCurrentLineBlame = { fg = ui.fg_ghost, italic = true },

        ---------------------------------------------------------------- flash
        FlashBackdrop = { fg = ui.fg_muted },
        FlashMatch = { fg = ui.fg_bright, bg = ui.bg_search },
        FlashCurrent = { fg = ui.fg_bright, bg = ui.bg_search_cur },
        FlashLabel = { fg = ui.bg, bg = syn.func, bold = true },
        FlashPrompt = { fg = ui.fg, bg = bg_float },
        FlashPromptIcon = { fg = ui.accent, bg = bg_float },

        -------------------------------------------------------------- trouble
        TroubleNormal = { fg = ui.fg, bg = bg_dark },
        TroubleNormalNC = { fg = ui.fg, bg = bg_dark },
        TroubleText = { fg = ui.fg },
        TroubleCount = { fg = syn.control, bg = bg_input },
        TroubleIndent = { fg = ui.indent },
        TroublePos = { fg = ui.fg_muted },
        TroubleSource = { fg = ui.fg_muted, italic = true },
        TroubleFilename = { fg = syn.type },
        TroubleIconDirectory = { fg = syn.type },

        ------------------------------------------------------------- grug-far
        GrugFarHelpHeader = { fg = ui.fg_muted },
        GrugFarHelpHeaderKey = { fg = syn.control },
        GrugFarHelpWinHeader = { fg = ui.accent, bold = true },
        GrugFarHelpWinActionPrefix = { fg = ui.fg_muted },
        GrugFarHelpWinActionText = { fg = ui.fg },
        GrugFarHelpWinActionKey = { fg = syn.control },
        GrugFarHelpWinActionDescription = { fg = ui.fg_muted },
        GrugFarInputLabel = { fg = syn.keyword, bold = true },
        GrugFarInputPlaceholder = { fg = ui.fg_ghost, italic = true },
        GrugFarResultsHeader = { fg = ui.fg_muted },
        GrugFarResultsStats = { fg = ui.fg_muted },
        GrugFarResultsActionMessage = { fg = ui.accent },
        GrugFarResultsCmdHeader = { fg = ui.fg_muted, italic = true },
        GrugFarResultsPath = { fg = syn.type, bold = true },
        GrugFarResultsLineNo = { fg = ui.fg_muted },
        GrugFarResultsLineColumn = { fg = ui.fg_muted },
        GrugFarResultsMatch = { fg = ui.fg_bright, bg = ui.bg_search },
        GrugFarResultsMatchAdded = { fg = git.added, bg = git.bg_add },
        GrugFarResultsMatchRemoved = { fg = git.deleted, bg = git.bg_delete, strikethrough = true },
        GrugFarResultsChangeIndicator = { fg = git.modified },
        GrugFarResultsAddIndicator = { fg = git.added },
        GrugFarResultsRemoveIndicator = { fg = git.deleted },
        GrugFarResultsDiffSeparatorIndicator = { fg = ui.fg_muted },

        --------------------------------------------------------------- snacks
        SnacksIndent = { fg = ui.indent },
        SnacksIndentScope = { fg = ui.indent_active },
        SnacksIndentChunk = { fg = ui.indent_active },
        SnacksNormal = { fg = ui.fg, bg = bg_float },
        SnacksNormalNC = { fg = ui.fg, bg = bg_float },
        SnacksWinBar = { fg = ui.fg_bright, bg = bg_float, bold = true },
        SnacksBackdrop = { bg = ui.bg_darker },
        SnacksNotifierInfo = { fg = diag.info, bg = bg_float },
        SnacksNotifierWarn = { fg = diag.warn, bg = bg_float },
        SnacksNotifierError = { fg = diag.error, bg = bg_float },
        SnacksNotifierDebug = { fg = ui.fg_muted, bg = bg_float },
        SnacksNotifierTrace = { fg = syn.control, bg = bg_float },
        SnacksNotifierBorderInfo = { fg = diag.info, bg = bg_float },
        SnacksNotifierBorderWarn = { fg = diag.warn, bg = bg_float },
        SnacksNotifierBorderError = { fg = diag.error, bg = bg_float },
        SnacksNotifierTitleInfo = { fg = diag.info, bg = bg_float, bold = true },
        SnacksNotifierTitleWarn = { fg = diag.warn, bg = bg_float, bold = true },
        SnacksNotifierTitleError = { fg = diag.error, bg = bg_float, bold = true },
        SnacksDashboardHeader = { fg = ui.accent, bold = true },
        SnacksDashboardTitle = { fg = ui.fg_bright, bold = true },
        SnacksDashboardDesc = { fg = ui.fg },
        SnacksDashboardIcon = { fg = syn.type },
        SnacksDashboardKey = { fg = syn.control },
        SnacksDashboardFooter = { fg = ui.fg_muted, italic = true },
        SnacksDashboardSpecial = { fg = syn.type },
        SnacksDashboardDir = { fg = ui.fg_muted },
        SnacksInputNormal = { fg = ui.fg, bg = bg_float },
        SnacksInputBorder = { fg = ui.accent, bg = bg_float },
        SnacksInputTitle = { fg = ui.accent, bg = bg_float, bold = true },

        ----------------------------------------------------------------- mini
        MiniIndentscopeSymbol = { fg = ui.indent_active },
        MiniSurround = { fg = ui.fg_bright, bg = ui.bg_search_cur },
        MiniIconsAzure = { fg = ui.match },
        MiniIconsBlue = { fg = syn.keyword },
        MiniIconsCyan = { fg = syn.type },
        MiniIconsGreen = { fg = diag.ok },
        MiniIconsGrey = { fg = ui.fg_dim },
        MiniIconsOrange = { fg = syn.string },
        MiniIconsPurple = { fg = syn.control },
        MiniIconsRed = { fg = diag.error },
        MiniIconsYellow = { fg = syn.func },

        ---------------------------------------------------------------- misc
        FidgetTask = { fg = ui.fg_muted },
        FidgetTitle = { fg = ui.accent, bold = true },
        RainbowDelimiterRed = { fg = "#ffd700" },
        RainbowDelimiterYellow = { fg = "#da70d6" },
        RainbowDelimiterBlue = { fg = "#179fff" },
        healthError = { fg = diag.error },
        healthSuccess = { fg = diag.ok },
        healthWarning = { fg = diag.warn },
    }
end

--- Apply the colorscheme.
---@param opts? { transparent?: boolean } Defaults to `vim.g.dark_2026_transparent`.
function M.load(opts)
    opts = opts or {}
    local transparent = opts.transparent
    if transparent == nil then
        transparent = vim.g.dark_2026_transparent ~= false
    end
    vim.g.dark_2026_transparent = transparent

    if vim.g.colors_name then
        vim.cmd.hi("clear")
    end
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.g.colors_name = "dark-2026"

    local set_hl = vim.api.nvim_set_hl
    for group, spec in pairs(build(transparent)) do
        set_hl(0, group, spec)
    end

    -- `:terminal` and any plugin reading g:terminal_color_* picks these up.
    for index, colour in ipairs(p.ansi) do
        vim.g["terminal_color_" .. (index - 1)] = colour
    end
end

--- Flip transparency on/off without restarting Neovim.
function M.toggle()
    M.load({ transparent = not vim.g.dark_2026_transparent })
    vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "dark-2026" })
    vim.notify(
        "Transparency " .. (vim.g.dark_2026_transparent and "on" or "off"),
        vim.log.levels.INFO,
        { title = "dark-2026" }
    )
end

--- Highlight overrides handed to bufferline.nvim.
---
--- bufferline generates its own `BufferLine*` groups at setup time, so the
--- colours have to be injected through its `highlights` option rather than
--- defined by the colorscheme.
---@return table<string, table> highlights
function M.bufferline()
    local ui, diag, git = p.ui, p.diag, p.git
    local transparent = vim.g.dark_2026_transparent ~= false
    local bar = transparent and "NONE" or ui.bg_dark
    local sel = transparent and "NONE" or ui.bg

    local groups = {
        fill = { bg = bar },
        background = { fg = ui.fg_muted, bg = bar },
        buffer_visible = { fg = ui.fg_dim, bg = bar },
        buffer_selected = { fg = ui.fg_bright, bg = sel, bold = true, italic = false },
        separator = { fg = ui.border, bg = bar },
        separator_visible = { fg = ui.border, bg = bar },
        separator_selected = { fg = ui.border, bg = sel },
        indicator_visible = { fg = bar, bg = bar },
        indicator_selected = { fg = ui.accent, bg = sel },
        modified = { fg = git.modified, bg = bar },
        modified_visible = { fg = git.modified, bg = bar },
        modified_selected = { fg = git.modified, bg = sel },
        duplicate = { fg = ui.fg_muted, bg = bar, italic = true },
        duplicate_visible = { fg = ui.fg_dim, bg = bar, italic = true },
        duplicate_selected = { fg = ui.fg_dim, bg = sel, italic = true },
        close_button = { fg = ui.fg_muted, bg = bar },
        close_button_visible = { fg = ui.fg_dim, bg = bar },
        close_button_selected = { fg = ui.fg_bright, bg = sel },
        numbers = { fg = ui.fg_muted, bg = bar },
        numbers_visible = { fg = ui.fg_dim, bg = bar },
        numbers_selected = { fg = ui.fg_bright, bg = sel, bold = true },
        offset_separator = { fg = ui.border, bg = bar },
        trunc_marker = { fg = ui.fg_muted, bg = bar },
        pick = { fg = diag.error, bg = bar, bold = true },
        pick_visible = { fg = diag.error, bg = bar, bold = true },
        pick_selected = { fg = diag.error, bg = sel, bold = true },
    }

    -- Diagnostic counts reuse the severity colours in all three tab states.
    for name, colour in pairs({
        error = diag.error,
        warning = diag.warn,
        info = diag.info,
        hint = diag.hint,
        diagnostic = ui.fg_muted,
    }) do
        groups[name] = { fg = colour, bg = bar }
        groups[name .. "_visible"] = { fg = colour, bg = bar }
        groups[name .. "_selected"] = { fg = colour, bg = sel, bold = true }
        if name ~= "diagnostic" then
            groups[name .. "_diagnostic"] = { fg = colour, bg = bar }
            groups[name .. "_diagnostic_visible"] = { fg = colour, bg = bar }
            groups[name .. "_diagnostic_selected"] = { fg = colour, bg = sel, bold = true }
        end
    end

    return groups
end

--- Lualine theme derived from the same palette.
---@return table lualine_theme
function M.lualine()
    local ui, diag, syn = p.ui, p.diag, p.syn
    local bar = vim.g.dark_2026_transparent and "NONE" or ui.bg_dark
    local section = function(fg)
        return { a = { fg = ui.bg, bg = fg, gui = "bold" }, b = { fg = fg, bg = bar }, c = { fg = ui.fg_dim, bg = bar } }
    end
    return {
        normal = section(ui.accent),
        insert = section(diag.ok),
        visual = section(syn.control),
        replace = section(diag.error),
        command = section(syn.func),
        inactive = {
            a = { fg = ui.fg_muted, bg = bar },
            b = { fg = ui.fg_muted, bg = bar },
            c = { fg = ui.fg_muted, bg = bar },
        },
    }
end

return M
