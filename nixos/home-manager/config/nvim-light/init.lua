vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require('mini.deps').setup({path = {package = path_package}})
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function() require('mini.notify').setup() end)
now(function() require('mini.icons').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end)

later(function() require('mini.ai').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.surround').setup() end)

now(function()
  require('mini.files').setup({
    windows = {
      preview = true,
      width_focus = 30,
      width_preview = 50,
    },
    options = {
      use_as_default_explorer = true,  -- this handles the dir hijacking natively
    },
  })
  vim.keymap.set('n', '<leader>e', function() MiniFiles.open() end, { desc = "File explorer" })
end)

later(function()
  require('mini.pick').setup()
  vim.keymap.set('n', '<leader>ff', function() MiniPick.builtin.files() end,   { desc = "Find files" })
  vim.keymap.set('n', '<leader>/',  function() MiniPick.builtin.grep_live() end, { desc = "Project grep (ripgrep)" })
end)

later(function()
  vim.o.termguicolors = true
  vim.cmd('colorscheme rose-pine-dawn')
  vim.cmd('TransparentEnable')

  vim.keymap.set('n', '<leader>sr', '<cmd>lua require("spectre").toggle()<CR>',                        { desc = "Search & replace (Spectre)" })
  vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search current word" })
  vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>',              { desc = "Search current word" })
  vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search in current file" })
end)

now(function()
  add({ source = 'nikolvs/vim-sunbather' })
  add({ source = 'rose-pine/neovim' })
  add({ source = 'xiyaowong/transparent.nvim' })
  add({
    source  = 'nvim-pack/nvim-spectre',
    depends = { 'folke/trouble.nvim', 'nvim-lua/plenary.nvim' },
  })
end)

later(function()
  add({ source = 'williamboman/mason.nvim' })
  add({ source = 'neovim/nvim-lspconfig' })

  require('mason').setup()

  vim.lsp.config('*', {
    root_markers = { '.git' },
  })

  vim.lsp.config('ruff', {
    filetypes = { 'python' },
    init_options = {
      settings = {
        -- picks up pyproject.toml / ruff.toml automatically
      }
    }
  })

  vim.lsp.enable('ruff')

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
      local opts = { buffer = event.buf, silent = true }
      vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,  opts)
      vim.keymap.set('n', 'K',          vim.lsp.buf.hover,        opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,  opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,       opts)
    end
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.py',
    callback = function() vim.lsp.buf.format({ async = false }) end,
  })
end)

later(function()
  add({
    source   = 'nvim-treesitter/nvim-treesitter',
    checkout = 'master',
    monitor  = 'main',
    hooks    = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc', 'python' },
    highlight        = { enable = true },
  })
end)
