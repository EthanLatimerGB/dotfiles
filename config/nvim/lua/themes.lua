return {
    {
        "savq/melange-nvim",
        priority = 1000,
        init = function()
            vim.cmd.colorscheme("melange")

            -- You can configure highlights by doing something like:
            vim.cmd.hi("Comment gui=none")
        end,
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
    },
}
