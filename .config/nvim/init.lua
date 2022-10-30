-- global configs
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.g.mapleader = ' '
vim.g.gruvbox_material_background = 'hard'

vim.opt.termguicolors = true
vim.o.background = 'dark'


-- Install Packer:
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local install_plugins = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  print('Installing packer...')
  local packer_url = 'https://github.com/wbthomason/packer.nvim'
  vim.fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
  print('Done.')

  vim.cmd('packadd packer.nvim')
  install_plugins = true
end


-- Here for installing packages using packer
require('packer').startup(function(use)

--  use 'github-user/repo'

  -- Package manager
  use 'wbthomason/packer.nvim'

  -- Theme
  use 'sainnhe/gruvbox-material'

  -- Telescope:
  use "nvim-lua/plenary.nvim"
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Coments
  use 'tpope/vim-commentary'

  -- i3 syntax
  use 'PotatoesMaster/i3-vim-syntax'

  

  --- tmux integration
  use { 'alexghergh/nvim-tmux-navigation', config = function()

        local nvim_tmux_nav = require('nvim-tmux-navigation')

        nvim_tmux_nav.setup {
            disable_when_zoomed = true -- defaults to false
        }

        vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
        vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
        vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
        vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
        vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
        vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)

    end
}
  

  -- Markdown
  use 'plasticboy/vim-markdown'

  -- Treesitter and lsp
  use 'neovim/nvim-lspconfig'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  
  use {
    'hrsh7th/nvim-cmp', tag = '*', requires = {
      'f3fora/cmp-spell',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
    }
  }
  use {
    'L3MON4D3/LuaSnip', tag = "v1.*", requires = {
      'saadparwaiz1/cmp_luasnip',
    }
  }

  -- Golang
  -- use 'ray-x/go.nvim'
  -- use 'ray-x/guihua.lua' -- recommanded if need floating window support
  use 'fatih/vim-go'

  if install_plugins then
    require('packer').sync()
  end
end)

if install_plugins then
  return
end


-- Set theme
vim.cmd('colorscheme gruvbox-material')

-- config Telescope:
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


-- Treesitter

require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  highlight = { enable = true },
}

-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'


-- LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

local servers = { 'gopls' }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities
  }

end


-- Completition
vim.opt.completeopt = 'menuone,noselect'
-- nvim-cmp setup

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local luasnip = require 'luasnip'
local cmp = require('cmp')

cmp.setup {
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        nvim_lua = '[Lua]',
        luasnip = '[Snippet]',
        calc = '[Calc]',
        path = '[Path]',
        spell = '[Spell]',
        buffer = '[Buffer]',
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
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
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'calc' },
    { name = 'path' },
    { name = 'spell' },
  },
  {
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
      },
    },
  }),
}

-- Golang
-- require('go').setup()
