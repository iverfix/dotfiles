return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        cpp  =  {"clang_format_18" },
        lua  = { "stylua" },
        -- add more filetypes if needed
      },
      formatters = {
        clang_format_18 = {
          command = "clang-format-18",
          args = { "$FILENAME" },  -- optional args
        }
      },
      format_on_save = true,  -- optional: automatically format on save
    })
  end,
}
