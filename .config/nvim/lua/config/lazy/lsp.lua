return {
{
    "mason-org/mason.nvim",
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    }
},
  {
    "neovim/nvim-lspconfig",
    dependencies= {
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
  },},
    config = function()

       vim.diagnostic.config({
        virtual_text = true, -- ← this is the key line
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.lsp.enable({'lua_ls', 'clangd'})
    end,
  }
}
