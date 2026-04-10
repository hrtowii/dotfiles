-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
    'https://github.com/nvim-mini/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require('mini.deps').setup({path = {package = path_package}})
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  vim.o.termguicolors = true
  vim.cmd('colorscheme sunbather')
end)

now(function() require('mini.notify').setup() end)
now(function() require('mini.icons').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end)

-- Safely execute later
later(function() require('mini.ai').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('oil').setup() end)
now(function()
  -- Use other plugins with `add()`. It ensures plugin is available in current
  -- session (installs if absent)
  add({
	  source = 'stevearc/oil.nvim'
  })
  add({
   source = 'nikolvs/vim-sunbather'
  })
  add({
    source = 'neovim/nvim-lspconfig',
    -- Supply dependencies near target plugin
    depends = { 'williamboman/mason.nvim' },
  })
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  -- Possible to immediately execute code which depends on the added plugin
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc' },
    highlight = { enable = true },
  })
end)
