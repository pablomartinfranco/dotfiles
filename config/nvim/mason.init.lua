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
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/williamboman/mason-lspconfig.nvim', mason_lspconfi>
  vim.cmd 'packadd mason-lspconfig.nvim'
end

local servers = { 'rust_analyzer', 'ocamllsp', 'gopls', 'pyright', 'jdtls', 'asm_lsp', 'clangd' }

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = servers,
})

local on_attach = function(_, _)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
