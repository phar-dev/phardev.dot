return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    keys = { { "<C-J>", "<cmd>ToggleTerm<cr>", desc = "Toggle floating terminal" } },
    opts = {
      direction = "float",
      shade_filetypes = {},
      hide_numbers = true,
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      close_on_exit = true,
      size = 20,
      float_opts = {
        border = "single",
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
