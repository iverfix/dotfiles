return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,

        default_component_configs = {
          indent = {
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            expander_collapsed = "",
            expander_expanded = "",
          },
          git_status = {
            symbols = {
              added = "✚",
              modified = "",
              deleted = "✖",
              renamed = "󰁕",
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
            },
          },
        },

        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
          },
          window = {
            width = 32,
            mappings = {
              ["<space>"] = "toggle_node",
              ["<cr>"] = "open",
              ["S"] = "open_split",
              ["s"] = "open_vsplit",
              ["P"] = {
                "toggle_preview",
                config = { use_float = false },
              },
              ["<esc>"] = "close_window",
            },
          },
        },

        buffers = {
          follow_current_file = {
            enabled = true,
          },
        },

        git_status = {
          window = {
            position = "float",
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", {
        desc = "Toggle Neo-tree",
      })
      vim.keymap.set("n", "<leader>bf", "<cmd>Neotree buffers toggle<CR>", {
        desc = "Neo-tree buffers",
      })
      vim.keymap.set("n", "<leader>gs", "<cmd>Neotree git_status toggle<CR>", {
        desc = "Neo-tree git status",
      })
    end,
  },
}
