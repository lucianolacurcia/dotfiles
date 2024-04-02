vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.guicursor = ""
vim.opt.cursorline = true
vim.opt.nu = true
vim.opt.relativenumber = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"

local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('L3MON4D3/LuaSnip')
Plug('VonHeikemen/lsp-zero.nvim')
Plug('christoomey/vim-tmux-navigator')
Plug('github/copilot.vim')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-nvim-lua')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/nvim-cmp')
Plug('kyazdani42/nvim-web-devicons')
Plug('mbbill/undotree')
Plug('neovim/nvim-lspconfig')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-lualine/lualine.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('rose-pine/neovim')
Plug('saadparwaiz1/cmp_luasnip')
Plug('tpope/vim-fugitive')
Plug('williamboman/mason-lspconfig.nvim')
Plug('williamboman/mason.nvim')
vim.call('plug#end')


vim.cmd.colorscheme("rose-pine")


-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'go', 'c', 'python', 'lua', "rust" },
    sync_install = false,
    auto_install = false,
    indent = { enable = true },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "gopls", "clangd", "pylsp" }
})

--
-- LSP
--
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
    vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, opts)
    vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)

    local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = true })

    vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        pattern = { '*' }, -- or '*.go'
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        pattern = { '*' }, -- or '*.go'
        callback = function()
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { 'source.organizeImports' } }
            local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000) -- timeout in ms 1000
            for _, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                    if r.edit then
                        vim.lsp.util.apply_workspace_edit(r.edit, 'UTF-8')
                    else
                        vim.lsp.buf.execute_command(r.command)
                    end
                end
            end
        end,
    })
end

-- GOPLS
require('lspconfig').gopls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { 'gopls', 'serve' },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                unreachable = true,
            },
            staticcheck = true,
        },
    },
}

-- CLANGD
require('lspconfig').clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        -- "--fallback-style=webkit",
    },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
}

-- PYLSP
require('lspconfig').pylsp.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { 'pylsp' },
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = { 'W391' },
                    maxLineLength = 140,
                }
            }
        }
    }
}

-- SUMNEKO LUA
require('lspconfig').lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- LuaJIT in the case of Neovim
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}


--
-- AUTOCOMPLETION
--

-- luasnip setup
local luasnip = require('luasnip')

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
        ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

-- Copilot
vim.g.copilot_assume_mapped = true
-- Force disable everywhere
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = '*',
    command = "Copilot disable"
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = '*_test.go',
    command = "Copilot enable"
})
