return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha', -- dark base
        transparent_background = true,
        term_colors = true,
        styles = {
          comments = { 'italic' },
          functions = { 'bold' },
          keywords = { 'italic' },
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          treesitter = true,
          telescope = { enabled = true },
          native_lsp = { enabled = true },
          which_key = true,
        },
        color_overrides = {
          mocha = {
            base = '#0e0e12', -- deep background
            mantle = '#111118',
            crust = '#0b0b0e',
            text = '#d2d8ff', -- slightly bluish white
            red = '#ff6b6b', -- strong crimson red
            maroon = '#ff5c5c', -- darker red for contrasts
            peach = '#ff7b72', -- warm reddish orange
            yellow = '#ff7676', -- shifted from yellow → light red
            green = '#ff8585', -- shifted green → pastel red
            teal = '#89b4fa', -- blue-ish highlight
            blue = '#82aaff', -- vivid blue for keywords
            mauve = '#b48ef7', -- purple tone for structure
            lavender = '#a5adff', -- soft blue-purple
            sky = '#91d7e3',
            sapphire = '#74c7ec',
          },
        },
        highlight_overrides = {
          mocha = function(c)
            return {
              Normal = { fg = c.text, bg = 'none' },
              NormalFloat = { bg = 'none' },
              FloatBorder = { fg = c.lavender },
              Comment = { fg = c.surface2, italic = true },
              Function = { fg = c.blue, bold = true },
              Keyword = { fg = c.mauve, italic = true },
              Conditional = { fg = c.blue, italic = true },
              Constant = { fg = c.red },
              String = { fg = c.peach },
              Number = { fg = c.red },
              Boolean = { fg = c.red },
              Operator = { fg = c.lavender },
              Type = { fg = c.blue },
              Identifier = { fg = c.text },
              Variable = { fg = c.text },
              CursorLineNr = { fg = c.lavender, bold = true },
              LineNr = { fg = c.surface2 },
              Visual = { bg = c.surface1 },
              Pmenu = { bg = 'none' },
              PmenuSel = { bg = c.surface1, fg = c.red, bold = true },
              TelescopeBorder = { fg = c.lavender, bg = 'none' },
              TelescopeTitle = { fg = c.blue, bold = true },
              TelescopeSelection = { fg = c.red, bg = c.surface1 },
              DiagnosticError = { fg = c.red },
              DiagnosticWarn = { fg = c.peach },
              DiagnosticInfo = { fg = c.blue },
              DiagnosticHint = { fg = c.mauve },
              DiffAdd = { fg = c.red },
              DiffChange = { fg = c.peach },
              DiffDelete = { fg = c.red },
              DiffText = { fg = c.red, bold = true },
            }
          end,
        },
      })

      vim.cmd.colorscheme('catppuccin')
    end,
  },
}
