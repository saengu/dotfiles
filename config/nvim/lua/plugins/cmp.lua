local add, now, now_if_args, later = vim.pack.add, Core.now, Core.now_if_args, Core.later


local function build_blink(params)
  vim.notify('Building blink.cmp', vim.log.levels.INFO)
  local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
  if obj.code == 0 then
    vim.notify('Building blink.cmp done', vim.log.levels.INFO)
  else
    vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
  end
end

later(function()
    -- After plugin installed.
    -- Go to `~/.local/share/nvim/site/pack/core/opt/blink.cmp`
    -- Run `cargo build --release`
    add({
      "https://github.com/rafamadriz/friendly-snippets",
      "https://github.com/saghen/blink.cmp"
    })
  --[[
  -- Install blink.cmp
  if jit.os == 'OSX' and jit.arch == 'arm64' then
    -- Build from source
    add("https://github.com/rafamadriz/friendly-snippets"")
    add("https://github.com/saghen/blink.cmp")
  else
    -- Download pre-built binaries
    add("https://github.com/rafamadriz/friendly-snippets"")
    add("https://github.com/saghen/blink.cmp")
  end
  --]]

  local cmp = require('blink.cmp')
  cmp.setup({
    cmdline = { enabled = false },
    completion = {
      --documentation = { auto_show = true }, -- press <C-Space> to show or hide signature
      ghost_text = { enabled = false },
      keyword = {
        -- 'prefix' will fuzzy match on the text before the cursor
        -- 'full' will fuzzy match on the text before _and_ after the cursor
        -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
        range = 'full'
      },
      list = { selection = { preselect = true, auto_insert = false } },
      menu = {
        auto_show = true,
      },
    },
    keymap = {
      ['<Tab>'] = { function(cmp)
        if cmp.snippet_active() then
          return cmp.snippet_forward()
        else
          return cmp.select_next()
        end
      end, 'fallback'},
      ['<S-Tab>'] = { function(cmp)
        if cmp.snippet_active() then
          return cmp.snippet_backward()
        else
          return cmp.select_prev()
        end
      end, 'fallback'},
      ['<C-x><C-f>'] = { function(cmp)
        cmp.show({ providers = { 'path' } })
      end, 'fallback' },

      ['<CR>'] = { 'select_and_accept', 'fallback' },
    },
    signature = { enabled = true },
    sources = {
      default = { "lsp", "snippets", "buffer" },
    },
  })

end)
