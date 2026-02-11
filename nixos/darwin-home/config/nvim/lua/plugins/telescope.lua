return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  config = {
    defaults = {
      layout_strategy = "flex",
      layout_config = { width = 0.95 },
      path_display = { "smart" },
    },
  },
  dependencies = { "nvim-lua/plenary.nvim" },
}
