local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later


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

  -- Install blink.cmp
  if jit.os == 'OSX' and jit.arch == 'arm64' then
    -- Build from source
    add({
      source = 'saghen/blink.cmp',
      depends = { "rafamadriz/friendly-snippets" },
      hooks = {
        post_install = build_blink,
        post_checkout = build_blink,
      },
    })
  else
    -- Download pre-built binaries
    add({
      source = "saghen/blink.cmp",
      depends = { "rafamadriz/friendly-snippets" },
    })
  end


  local cmp = require('blink.cmp')
  cmp.setup({
    completion = {
      documentation = { auto_show = true },
      ghost_text = { enabled = true },
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
