-- init.lua configuration

-- Install mason.nvim if not installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/plugins/start/mason.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/williamboman/mason.nvim', install_path})
  vim.cmd 'packadd mason.nvim'
end

-- Install nvim-lspconfig if not installed
local lspconfig_path = vim.fn.stdpath('data') .. '/site/pack/plugins/start/nvim-lspconfig'
if vim.fn.empty(vim.fn.glob(lspconfig_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/neovim/nvim-lspconfig', lspconfig_path})
  vim.cmd 'packadd nvim-lspconfig'
end

-- Install mason-lspconfig.nvim if not installed
local mason_lspconfig_path = vim.fn.stdpath('data') .. '/site/pack/plugins/start/mason-lspconfig.nvim'
if vim.fn.empty(vim.fn.glob(mason_lspconfig_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/williamboman/mason-lspconfig.nvim', mason_lspconfig_path})
  vim.cmd 'packadd mason-lspconfig.nvim'
end

-- Mason setup
require('mason').setup()

-- Mason LSPconfig setup
require('mason-lspconfig').setup({
  ensure_installed = { 'gopls' }
})

-- LSP settings
local lspconfig = require('lspconfig')

-- Configure gopls
lspconfig.gopls.setup{
  on_attach = function(client, bufnr)
    -- Format Go code using gofmt on save
    vim.api.nvim_exec([[
      augroup GoFmt
        autocmd!
        autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting_sync(nil, 1000)
      augroup END
    ]], false)
  end,
}

-- General Neovim settings
vim.o.number = true -- Show line numbers
vim.o.relativenumber = true -- Show relative line numbers
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.tabstop = 4 -- Number of spaces tabs count for
vim.o.shiftwidth = 4 -- Size of an indent
vim.o.smartindent = true -- Insert indents automatically
vim.o.wrap = false -- Disable line wrap

-- Key mappings
vim.api.nvim_set_keymap('n', '<Leader>ff', '<cmd>lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
