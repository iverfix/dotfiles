-- 1. Mason Setup (Remains relevant for installing binaries)
require('mason').setup({
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
})

-- 2. Global Diagnostic Config (Modern 0.12 defaults)
vim.diagnostic.config({
  virtual_text = false, -- Disabled in favor of virtual_lines
  virtual_lines = { current_line = true }, -- Native multi-line diagnostics
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN]  = '▲',
      [vim.diagnostic.severity.HINT]  = '⚑',
      [vim.diagnostic.severity.INFO]  = '»',
    },
  },
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})
--
-- 4. Server Configurations (The 0.12 Native Way)
-- We use vim.lsp.config() to override defaults and vim.lsp.enable() to start them.

-- Clangd
vim.lsp.config('clangd', {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--header-insertion=iwyu',
    '--completion-style=detailed',
    '--function-arg-placeholders',
    '--fallback-style=llvm',
  },
  filetypes = { 'c', 'cpp', 'cuda' },
  root_markers = { '.clangd', '.clang-tidy', 'compile_commands.json', '.git' },
  capabilities = {
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false, -- Prevents annoying "Do you want to configure your workspace?" popups
      },
      telemetry = { enable = false },
    },
  },
})

-- Rust Analyzer
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
      check = { command = 'clippy' },
    },
  },
})

-- 5. Enable Servers
-- This replaces the old .setup() loop. Neovim 0.12 will now look for
-- these in your runtime path (or from nvim-lspconfig's internal library)
vim.lsp.enable({ 'clangd', 'rust_analyzer', 'lua_ls', 'cmake' })

-- 6. Bonus: Neovim 0.12 Native Autocomplete
-- You can now replace nvim-cmp with this one line:
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'fuzzy' }
-- (0.12+ features a built-in completion UI that triggers automatically)im.lsp.start({ name = 'rust_analyzer' })
