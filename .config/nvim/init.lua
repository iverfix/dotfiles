require("config")

-- Disable netrw banner/header
vim.g.netrw_banner = 0

-- Optional: cleaner netrw setup
vim.g.netrw_liststyle = 3 -- tree-style view
vim.g.netrw_browse_split = 4 -- open files in previous window
vim.g.netrw_altv = 1 -- open splits to the right
vim.g.netrw_winsize = 25 -- set netrw width
vim.opt.clipboard:append("unnamedplus")

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
