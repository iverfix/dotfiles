local function switch_source_header(bufnr, client)
  local method_name = "textDocument/switchSourceHeader"
  ---@diagnostic disable-next-line:param-type-mismatch
  if not client or not client:supports_method(method_name) then
    return vim.notify(("method %s is not supported by any servers active on the current buffer"):format(method_name))
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  ---@diagnostic disable-next-line:param-type-mismatch
  client:request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify("corresponding file cannot be determined")
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

local function symbol_info(bufnr, client)
  local method_name = "textDocument/symbolInfo"
  ---@diagnostic disable-next-line:param-type-mismatch
  if not client or not client:supports_method(method_name) then
    return vim.notify("Clangd client not found", vim.log.levels.ERROR)
  end
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
  ---@diagnostic disable-next-line:param-type-mismatch
  client:request(method_name, params, function(err, res)
    if err or #res == 0 then
      -- Clangd always returns an error, there is no reason to parse it
      return
    end
    local container = string.format("container: %s", res[1].containerName) ---@type string
    local name = string.format("name: %s", res[1].name) ---@type string
    vim.lsp.util.open_floating_preview({ name, container }, "", {
      height = 2,
      width = math.max(string.len(name), string.len(container)),
      focusable = false,
      focus = false,
      title = "Symbol Info",
    })
  end, bufnr)
end

---@class ClangdInitializeResult: lsp.InitializeResult
---@field offsetEncoding? string

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      vim.diagnostic.config({
        virtual_text = true, -- ← this is the key line
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        filetypes = { "c", "cpp", "cuda" },
        root_markers = {
          ".clangd",
          ".clang-tidy",
          ".clang-format",
          "compile_commands.json",
          "compile_flags.txt",
          "configure.ac", -- AutoTools
          ".git",
        },
        capabilities = {
          textDocument = {
            completion = {
              editsNearCursor = true,
            },
          },
          offsetEncoding = { "utf-8", "utf-16" },
        },
        ---@param init_result ClangdInitializeResult
        on_init = function(client, init_result)
          if init_result.offsetEncoding then
            client.offset_encoding = init_result.offsetEncoding
          end
        end,
        on_attach = function(client, bufnr)
          vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
            switch_source_header(bufnr, client)
          end, { desc = "Switch between source/header" })

          vim.api.nvim_buf_create_user_command(bufnr, "LspClangdShowSymbolInfo", function()
            symbol_info(bufnr, client)
          end, { desc = "Show symbol info" })

          -- add hotkey
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "<leader>hh", "<cmd>LspClangdSwitchSourceHeader<cr>", opts)
          vim.keymap.set("n", "<leader>ci", "<cmd>LspClangdShowSymbolInfo<CR>", opts)
          vim.keymap.set("n", "<leader>ci", "<cmd>LspClangdShowSymbolInfo<CR>", opts)

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- go to definition
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- go to implementation
          vim.keymap.set("n", "<leader>ca", function()
            vim.lsp.buf.code_action()
          end, { noremap = true, silent = true, buffer = bufnr })
        end,
      })

      vim.lsp.config("rust_analyzer", {
        filetypes = { "rust" },
        root_markers = {
          "Cargo.toml",
          "rust-project.json",
          ".git",
        },
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            checkOnSave = true,
            check = {
              command = "clippy",
            },
          },
        },
        on_attach = function(client, bufnr)
          -- keymaps for Rust
          local opts = { noremap = true, silent = true, buffer = bufnr }

          vim.keymap.set("n", "<leader>ca", function()
            vim.lsp.buf.code_action({
              filter = function(action)
                return action.kind == "quickfix" or action.kind == "refactor"
              end,
            })
          end, opts)

          vim.keymap.set("n", "<leader>rf", vim.lsp.buf.format, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        end,
      })

      vim.lsp.enable({ "lua_ls", "clangd", "cmake", "rust_analyzer" })
    end,
  },
}
