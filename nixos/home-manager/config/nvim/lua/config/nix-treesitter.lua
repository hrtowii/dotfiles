local ok, ts_install = pcall(require, "nvim-treesitter.install")
if ok then
  ts_install.prefer_git = false
  ts_install.compilers = {}
  ts_install.skip = true
end

-- optional: prevent LazyVim from trying to install missing ones
require("nvim-treesitter.configs").setup({
  auto_install = false,
})
