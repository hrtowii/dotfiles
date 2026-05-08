vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = " "

vim.o.undofile        = true
vim.o.scrolloff       = 10
vim.o.ignorecase      = true
vim.o.smartcase       = true
vim.o.splitright      = true
vim.o.splitbelow      = true
vim.o.number          = true
vim.o.relativenumber  = true
vim.o.signcolumn      = 'yes'
vim.o.cursorline      = true
vim.o.confirm         = true
vim.o.updatetime      = 500
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.diagnostic.config({ virtual_text = true })

vim.keymap.set('n', '<C-s>', '<cmd>w<cr>',      { desc = "Save file" })
vim.keymap.set('i', '<C-s>', '<esc><cmd>w<cr>', { desc = "Save file" })
vim.keymap.set('n', '<C-d>', '<C-d>zz',         { desc = "Scroll down centered" })
vim.keymap.set('n', '<C-u>', '<C-u>zz',         { desc = "Scroll up centered" })

vim.keymap.set('n', '<leader>bo', function()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.bo[buf].buflisted then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, { desc = "Delete other buffers" })

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
require('mini.deps').setup({ path = { package = path_package } })
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
  local clue = require('mini.clue')
  clue.setup({
     window = {
	delay = 20,
      },
    triggers = {
      { mode = 'n', keys = '<leader>' },
      { mode = 'x', keys = '<leader>' },
      { mode = 'n', keys = 'g' },
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'n', keys = '"' },
      { mode = 'n', keys = '<C-w>' },
      
    },
    clues = {
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
    },
  })
end)

now(function()
  require('mini.files').setup({
    windows = {
      preview = true,
      width_focus = 30,
      width_preview = 50,
    },
    options = {
      use_as_default_explorer = true,
    },
  })
  vim.keymap.set('n', '<leader>e', function() MiniFiles.open() end, { desc = "File explorer" })
end)

later(function()
  require('mini.pick').setup()
  vim.keymap.set('n', '<leader>ff', function() MiniPick.builtin.files() end,     { desc = "Find files" })
  vim.keymap.set('n', '<leader>/',  function() MiniPick.builtin.grep_live() end, { desc = "Project grep (ripgrep)" })
end)

later(function()
  vim.o.termguicolors = true
  vim.cmd('colorscheme rose-pine')
  require("transparent").setup({
    exclude_groups = { 'CursorLine' },
  })
  vim.cmd('TransparentEnable')

  vim.keymap.set('n', '<leader>sr', '<cmd>lua require("spectre").toggle()<CR>',                             { desc = "Search & replace (Spectre)" })
  vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',      { desc = "Search current word" })
  vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>',                   { desc = "Search current word" })
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
  add({
    source = 'saghen/blink.cmp',
    checkout = 'v1.3.1',
  })
  require('blink.cmp').setup({
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    keymap = { preset = 'super-tab' },
    enabled = function()
      return vim.bo.buftype ~= 'prompt'
    end,
  })
end)

later(function()
  add({ source = 'williamboman/mason.nvim' })
  add({ source = 'neovim/nvim-lspconfig' })

  require('mason').setup()

  local capabilities = require('blink.cmp').get_lsp_capabilities()

  vim.lsp.config('*', {
    capabilities = capabilities,
    root_markers = { '.git' },
  })

  vim.lsp.config('ruff', {
    filetypes = { 'python' },
  })
  vim.lsp.enable('ruff')

  vim.lsp.config('ts_ls', {
    filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    root_markers = { 'tsconfig.json', 'package.json' },
  })
  vim.lsp.enable('ts_ls')

  vim.lsp.config('svelte', {
    filetypes = { 'svelte' },
    root_markers = { 'svelte.config.js', 'svelte.config.ts', 'package.json' },
  })
  vim.lsp.enable('svelte')

  vim.lsp.config('clangd', {
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = { 'compile_commands.json', 'compile_flags.txt', 'CMakeLists.txt', '.git' },
  })
  vim.lsp.enable('clangd')

  vim.lsp.config('nixd', {
    filetypes = { 'nix' },
    root_markers = { 'flake.nix', 'default.nix', '.git' },
  })
  vim.lsp.enable('nixd')  

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
      local opts = { buffer = event.buf, silent = true }
      vim.keymap.set('n', 'gd',         vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K',          vim.lsp.buf.hover,       opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,      opts)
    end
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { '*.py', '*.ts', '*.tsx', '*.svelte', '*.nix' },
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
    ensure_installed = { 'lua', 'vimdoc', 'python', 'typescript', 'svelte' },
    highlight        = { enable = true },
  })
end)
