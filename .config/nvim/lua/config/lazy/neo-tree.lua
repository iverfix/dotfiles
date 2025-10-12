return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will load immediately
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["P"] = {
              "toggle_preview",
              config = {
                use_float = false,
                -- use_image_nvim = true,
                -- use_snacks_image = true,
                -- title = 'Neo-tree Preview',
              },
            },
          },
        },
      })
      -- Global keymap: <leader>t toggles the Neo-tree file explorer
      vim.keymap.set("n", "<leader>t", "<cmd>Neotree toggle<CR>", {
        desc = "Toggle Neo-tree",
      })
    end,
  },
}
