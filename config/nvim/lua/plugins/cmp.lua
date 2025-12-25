local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  add('hrsh7th/nvim-cmp')
  add('hrsh7th/cmp-nvim-lsp')
  add('hrsh7th/cmp-buffer')
  add('hrsh7th/cmp-path')
  add('hrsh7th/cmp-cmdline')

  -- Setup snippet engine with LuaSnip
  add('L3MON4D3/LuaSnip')
  add('saadparwaiz1/cmp_luasnip')
  add('rafamadriz/friendly-snippets')

  local luasnip = require("luasnip")
  require("luasnip.loaders.from_vscode").lazy_load()

  local cmp = require('cmp')
  cmp.setup({
    preselect = cmp.PreselectMode.Item,
    completion = { completeopt = 'menu,menuone,noinsert,fuzzy,preview' },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)

        -- Use NeoVim native snippet engine
        -- vim.snippet.expand(args.body)
      end
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
          -- cmp.select_next_item()  -- This will insert the current candidate to buffer
          -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })  -- ONLY choose next candidate without update buffer

          if #cmp.get_entries() == 1 then
            -- Trigger an 'Enter'('<CR>') key event to expand snippet. Use 'm' to allow remap '<CR>', otherwise insert newline.
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'm', true)
          else
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })  -- ONLY choose next candidate without update buffer
          end
        elseif luasnip.locally_jumpable(1) then
          luasnip.jump(1)
        elseif vim.snippet.active({ direction = 1 }) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })  -- ONLY choose next candidate without update buffer
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        elseif vim.snippet.active({ direction = -1 }) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    }),
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })
end)
