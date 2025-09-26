return {
  "nvimdev/guard.nvim",
  dependencies = {
    "nvimdev/guard-collection",
  },
  event = { "BufReadPre", "BufNewFile" }, -- only load when editing files
  config = function()
    local ft = require("guard.filetype")

    ft("c"):fmt("clang-format")
    ft("cpp"):fmt("clang-format")
    ft("json"):fmt("clang-format")

    -- This must run *after* guard.nvim is loaded
    vim.g.guard_config = {
      fmt_on_save = true,
      lsp_as_default_formatter = false,
    }
  end,
}

