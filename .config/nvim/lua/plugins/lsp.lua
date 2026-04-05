-- Configure Mason
require('mason').setup({
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
})

-- Helper functions
local function switch_source_header(bufnr, client)
  local method_name = 'textDocument/switchSourceHeader'
  if not client or not client:supports_method(method_name) then
    return vim.notify(('method %s is not supported by any servers on this buffer'):format(method_name))
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client:request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify('corresponding file cannot be determined')
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

local function symbol_info(bufnr, client)
  local method_name = 'textDocument/symbolInfo'
  if not client or not client:supports_method(method_name) then
    return vim.notify('Clangd client not found', vim.log.levels.ERROR)
  end
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  client:request(method_name, params, function(err, res)
    if err or #res == 0 then
      return
    end
    local container = string.format('container: %s', res[1].containerName)
    local name = string.format('name: %s', res[1].name)
    vim.lsp.util.open_floating_preview({ name, container }, '', {
      height = 2,
      width = math.max(#name, #container),
      focusable = false,
      title = 'Symbol Info',
    })
  end, bufnr)
end

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

-- Setup clangd
require('lspconfig').clangd.setup({
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
  root_dir = require('lspconfig.util').root_pattern(
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    'configure.ac',
    '.git'
  ),
  capabilities = {
    textDocument = { completion = { editsNearCursor = true } },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
  on_init = function(client, init_result)
    if init_result.offsetEncoding then
      client.offset_encoding = init_result.offsetEncoding
    end
  end,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdSwitchSourceHeader', function()
      switch_source_header(bufnr, client)
    end, { desc = 'Switch between source/header' })

    vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdShowSymbolInfo', function()
      symbol_info(bufnr, client)
    end, { desc = 'Show symbol info' })

    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>hh', '<cmd>LspClangdSwitchSourceHeader<cr>', opts)
    vim.keymap.set('n', '<leader>ci', '<cmd>LspClangdShowSymbolInfo<CR>', opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

-- Setup rust_analyzer
require('lspconfig').rust_analyzer.setup({
  filetypes = { 'rust' },
  root_dir = require('lspconfig.util').root_pattern('Cargo.toml', 'rust-project.json', '.git'),
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
      check = { command = 'clippy' },
    },
  },
  on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>ca', function()
      vim.lsp.buf.code_action({
        filter = function(action)
          return action.kind == 'quickfix' or action.kind == 'refactor'
        end,
      })
    end, opts)
    vim.keymap.set('n', '<leader>rf', vim.lsp.buf.format, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  end,
})

-- Optionally enable other LSPs
vim.lsp.start({ name = 'lua_ls' })
vim.lsp.start({ name = 'cmake' })
vim.lsp.start({ name = 'clangd' })
vim.lsp.start({ name = 'rust_analyzer' })
