return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate', -- keeps parsers up to date
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'cpp',
        'javascript',
        'typescript',
        'lua',
        'rust',
        'vim',
        'vimdoc',
      },
      sync_install = false, -- install asynchronously
      auto_install = true, -- install missing parsers on buffer open
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      -- you can add other modules here (e.g., incremental_selection, textobjects)
    },
  },
}
