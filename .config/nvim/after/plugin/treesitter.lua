require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "javascript", "typescript" },

    sync_install = false,

    auto_install = true,


    highlight = {
        enable = true,
    },
    indent = {
        enable = true },
}
