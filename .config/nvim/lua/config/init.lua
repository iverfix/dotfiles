require("config.remap")
require("config.set")
require("config.lazy_init")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
