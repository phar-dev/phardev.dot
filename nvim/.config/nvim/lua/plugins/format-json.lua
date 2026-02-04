return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      json = { "prettier" },
      jsonc = { "prettier" },
    },
    formatters = {
      prettier = {
        prepend_args = {
          "--trailing-comma",
          "none",
        },
      },
    },
  },
}
