call plug#begin('~/.local/share/nvim/plugged')

" Plugin for LSP configurations
Plug 'neovim/nvim-lspconfig'

" Highlighting and LSP support
Plug 'scalameta/nvim-metals'
Plug 'nvim-lua/plenary.nvim'

" Asynchronous Lint Engine (ALE)
Plug 'dense-analysis/ale'

" Autocompletion plugin (nvim-cmp)
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" Optional themes
Plug 'morhetz/gruvbox', { 'as': 'gruvbox' }
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'joshdick/onedark.vim', { 'as': 'onedark' }
Plug 'arcticicestudio/nord-vim', { 'as': 'nord' }
Plug 'sickill/vim-monokai', { 'as': 'monokai' }
Plug 'altercation/vim-colors-solarized', { 'as': 'solarized' }

call plug#end()

" Enable true color support
set termguicolors

" Set Solarized color scheme
syntax enable
set background=dark
colorscheme solarized

" Set up nvim-cmp for autocompletion
lua << EOF
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `LuaSnip` users.
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For LuaSnip users.
  }, {
    { name = 'buffer' },
    { name = 'path' },
    { name = 'calc' },
    { name = 'nvim_lua' },
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Configure LSP servers
require('lspconfig')['metals'].setup {
  capabilities = capabilities
}
require('lspconfig')['clangd'].setup {
  capabilities = capabilities
}
require('lspconfig')['ccls'].setup {
  capabilities = capabilities
}
--require('lspconfig')['tsserver'].setup {
--  capabilities = capabilities
--}
--require('lspconfig')['html'].setup {
--  capabilities = capabilities
--}
--require('lspconfig')['cssls'].setup {
--  capabilities = capabilities
--}
--require('lspconfig')['jsonls'].setup {
--  capabilities = capabilities
--}
--require('lspconfig')['jdtls'].setup {
--  capabilities = capabilities
--}
--require('lspconfig')['pyright'].setup {
--  capabilities = capabilities
--}
--require('lspconfig')['gopls'].setup {
--  capabilities = capabilities
--}

-- Set up nvim-metals
local api = vim.api
local metals_config = require("metals").bare_config()

metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl"
  }
}

-- Autocmd that will actually be in charge of starting Metals
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})
EOF

" Optional: Add some basic mappings for LSP
nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <C-k> :lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> gR :lua vim.lsp.buf.rename()<CR>

" Snippet expansion
imap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
smap <expr> <Tab>   vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<Tab>"
smap <expr> <S-Tab> vsnip#available(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-Tab>"

" UltiSnips settings (if using UltiSnips)
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"

" LuaSnip settings (if using LuaSnip)
lua << EOF
  vim.cmd [[
    imap <silent><expr> <C-l> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-l>'
    inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
    snoremap <silent> <Tab> <cmd>lua require'luasnip'.jump(1)<Cr>
    snoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
  ]]
EOF
