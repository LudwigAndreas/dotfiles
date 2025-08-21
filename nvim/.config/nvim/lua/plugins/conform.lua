return {
  "stevearc/conform.nvim",
  opts = {},
  config = function()
      require("conform").setup({
          formetters_by_ft = {
              lua = { "stylua" },
          },
      })
  end,
}
