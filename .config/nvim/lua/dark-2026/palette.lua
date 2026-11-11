--- Colour palette extracted from the Visual Studio Code / Code OSS
--- "2026 Dark" theme (`extensions/theme-defaults/themes/2026-dark.json`).
---
--- Two things to know about the source theme:
---
---  * Its chrome is near-black and low-contrast, with a teal accent (#3994BC)
---    in place of the older Dark Modern blue.
---  * Its `tokenColors` are GitHub-Dark derived, so syntax looks nothing like
---    Dark Modern's: keywords are red, functions purple, types orange.
---
--- VS Code expresses many of these as translucent overlays (`#FFFFFF22`).
--- A terminal cannot blend, so those are flattened against the layer they sit
--- on; the original value is noted next to each one.
local M = {}

--- Workbench / chrome colours.
M.ui = {
    bg = "#121314", -- editor.background
    bg_dark = "#191a1b", -- sideBar, activityBar, statusBar, tab strip
    bg_darker = "#0e0f10", -- backdrop behind modals
    bg_float = "#202122", -- editorWidget, hover, suggest, notifications
    bg_input = "#191a1b", -- input, dropdown
    bg_line = "#242526", -- editor.lineHighlightBackground
    bg_hover = "#2b2c2d", -- list.hoverBackground (#FFFFFF14 on bg_dark)
    bg_active = "#383839", -- list.activeSelectionBackground (#FFFFFF22 on bg_dark)
    bg_visual = "#245c73", -- editor.selectionBackground (#276782DD on bg)
    bg_visual_soft = "#1a333d", -- editor.inactiveSelectionBackground (#27678260)
    bg_search = "#1d3d4b", -- editor.findMatchHighlightBackground (#27678280)
    bg_search_cur = "#276782", -- editor.findMatchBackground, at full opacity so
    -- the match under the cursor stays distinct
    bg_paren = "#1f3e4c", -- editorBracketMatch.background (#3994BC55 on bg)

    fg = "#bbbebf", -- editor.foreground
    fg_bright = "#ededed", -- list.activeSelectionForeground
    fg_dim = "#8c8c8c", -- descriptionForeground
    fg_muted = "#858889", -- editorLineNumber.foreground
    fg_ghost = "#555555", -- disabledForeground, input.placeholderForeground

    border = "#2a2b2c", -- panel.border, sideBar.border, widget.border
    border_light = "#333536", -- input.border, dropdown.border
    accent = "#3994bc", -- focusBorder, tab.activeBorderTop
    accent_dim = "#297aa0", -- button.background
    match = "#48a0c7", -- list.highlightForeground (fuzzy match characters)
    cursor = "#bbbebf", -- editorCursor.foreground
    indent = "#343536", -- editorIndentGuide.background1 (#8384854D)
    indent_active = "#838485", -- editorIndentGuide.activeBackground1
    whitespace = "#373838", -- editorWhitespace.foreground (#8C8C8C4D)
    scrollbar = "#606162", -- scrollbarSlider.background (#A8A9AA85)
    none = "NONE",
}

--- Diagnostic severities. 2026 Dark does not restate `editorError.foreground`
--- and friends, so these follow the colours it *does* pick for the problem
--- list, the overview ruler and the notification icons.
M.diag = {
    error = "#f48771", -- errorForeground, list.errorForeground
    warn = "#e5ba7d", -- list.warningForeground
    info = "#3a94bc", -- notificationsInfoIcon.foreground
    hint = "#8c8c8c", -- descriptionForeground
    ok = "#73c991",
}

--- Source-control decorations and diff backgrounds.
M.git = {
    added = "#73c991",
    modified = "#e5ba7d",
    deleted = "#f48771",
    untracked = "#73c991",
    ignored = "#8c8c8c",
    conflict = "#f48771",
    bg_add = "#17231a", -- diffEditor.insertedLineBackground (#347D3926)
    bg_delete = "#2d1919", -- diffEditor.removedLineBackground (#C93C3726)
    bg_change = "#1a333d",
    bg_text = "#276782",
}

--- Token colours.
---
--- `2026-dark.json` inherits `dark_modern -> dark_plus -> dark_vs`, and its own
--- GitHub-Dark rules are appended to theirs rather than replacing them.
--- TextMate resolves a scope to the rule with the *most specific* selector, so
--- the inherited Dark+ rules still win wherever they are more specific:
--- `entity.name.type` (3 segments) beats 2026's `entity.name` (2), which is why
--- types stay Dark+ teal instead of GitHub orange. Every value below is the
--- resolved winner for that scope across the whole chain.
M.syn = {
    comment = "#8b949e", -- comment                          (2026)
    string = "#a5d6ff", -- string                            (2026)
    regex = "#a5d6ff", -- string.regexp                      (2026)
    escape = "#d7ba7d", -- constant.character.escape         (dark_vs)
    number = "#b5cea8", -- constant.numeric                  (dark_vs)
    constant = "#79c0ff", -- variable.other.enummember, variable.language (2026)
    builtin = "#569cd6", -- constant.language, storage.modifier (dark_vs)
    keyword = "#ff7b72", -- storage, storage.type            (2026)
    control = "#c586c0", -- keyword.control                  (dark_plus)
    func = "#d2a8ff", -- entity.name.function                (2026)
    func_builtin = "#dcdcaa", -- support.function            (dark_vs)
    type = "#4ec9b0", -- entity.name.type.*, namespaces      (dark_vs)
    variable = "#c9d1d9", -- variable.other                  (2026)
    tag = "#7ee787", -- entity.name.tag, json property names (2026)
    attribute = "#9cdcfe", -- entity.other.attribute-name    (dark_vs)
    operator = "#d4d4d4", -- keyword.operator                (dark_vs)
    punct = "#bbbebf", -- falls through to editor.foreground
    label = "#c8c8c8", -- entity.name.label                  (dark_vs)
    invalid = "#ffa198", -- invalid.*, markup.deleted        (2026)
    -- The only orange the resolved theme actually uses.
    changed = "#ffa657", -- markup.changed, markdown list bullets (2026)
}

--- 16 ANSI colours. The theme leaves `terminal.ansi*` unset, so these are
--- derived from its resolved token palette to keep `:terminal` coherent.
M.ansi = {
    "#121314", "#ff7b72", "#7ee787", "#d7ba7d",
    "#569cd6", "#c586c0", "#4ec9b0", "#bbbebf",
    "#858889", "#ffa198", "#b5cea8", "#dcdcaa",
    "#79c0ff", "#d2a8ff", "#48a0c7", "#ededed",
}

return M
