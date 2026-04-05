require('conform').setup({
  formatters_by_ft = {
    cpp = { 'clang_format_18' },
    lua = { 'stylua' },
    rust = { 'rustfmt' },
    -- add more filetypes if needed
  },
  formatters = {
    clang_format_18 = {
      command = 'clang-format-18',
    },
  },
  format_on_save = {
    timeout_ms = 500,
  }, -- optional: automatically format on save
})
