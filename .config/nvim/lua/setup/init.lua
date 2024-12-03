require("setup.remap")
require("setup.set")
require("setup.lazy_init")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })

