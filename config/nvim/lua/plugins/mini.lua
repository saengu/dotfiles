--          ╔═════════════════════════════════════════════════════════╗
--          ║                                                         ║
--          ║                  Load mini.nvim Modules                 ║
--          ║                                                         ║
--          ╚═════════════════════════════════════════════════════════╝
--
--  ─( Import Helper Functions )─────────────────────────────────────────────
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later


--          ┌─────────────────────────────────────────────────────────┐
--            We took this from echasnovski's personal configuration
--           https://github.com/echasnovski/nvim/blob/master/init.lua
--          └─────────────────────────────────────────────────────────┘

-- Make 'mini.nvim' part of the 'mini-deps-snap'
add({ name = 'mini.nvim' })

--  ─( Step One )──────────────────────────────────────────────────────
now(function()
  require('mini.basics').setup({
    -- Manage options manually in a spirit of transparency
    options = { basic = false },
    mappings = { windows = true, move_with_alt = true },
    autocommands = { relnum_in_visual_mode = true },
  })
end)

now(function()
  local not_lua_diagnosing = function(notif) return not vim.startswith(notif.msg, 'lua_ls: Diagnosing') end
  local filterout_lua_diagnosing = function(notif_arr)
    return MiniNotify.default_sort(vim.tbl_filter(not_lua_diagnosing, notif_arr))
  end
  require('mini.notify').setup({
    content = { sort = filterout_lua_diagnosing },
    window = { config = { border = 'double' } },
  })
  vim.notify = MiniNotify.make_notify()
end)

now(function() require('mini.sessions').setup() end)
now(function() require('mini.starter').setup() end)
now(function() require('mini.statusline').setup() end)
now(function() require('mini.tabline').setup() end)

now(function()
  require('mini.icons').setup({
    use_file_extension = function(ext, _)
      local suf3, suf4 = ext:sub(-3), ext:sub(-4)
      return suf3 ~= 'scm' and suf3 ~= 'txt' and suf3 ~= 'yml' and suf4 ~= 'json' and suf4 ~= 'yaml'
    end,
  })
  MiniIcons.mock_nvim_web_devicons()
  later(MiniIcons.tweak_lsp_kind)
end)


--  ─( Step Two )──────────────────────────────────────────────────────
later(function() require('mini.extra').setup() end)

later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(),
      F = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
    },
  })
end)

later(function() require('mini.align').setup() end)
later(function() require('mini.animate').setup({ scroll = { enable = false } }) end)
later(function() require('mini.bracketed').setup() end)
later(function() require('mini.bufremove').setup() end)

later(function()
    local mappings = require('mappings')
    require("mini.clue").setup({
        triggers = {
            -- Leader triggers
            { mode = "n", keys = "<Leader>" },
            { mode = "x", keys = "<Leader>" },
            { mode = "n", keys = "<Space>" },
            { mode = "x", keys = "<Space>" },

            -- Mini Basics
            { mode = 'n', keys = "\\" },      -- mini.basics

            -- Mini Bracketed
            { mode = 'n', keys = '[' },       -- mini.bracketed
            { mode = 'n', keys = ']' },
            { mode = 'x', keys = '[' },
            { mode = 'x', keys = ']' },

            -- Built-in completion
            { mode = "i", keys = "<C-x>" },

            -- `g` key
            { mode = "n", keys = "g" },
            { mode = "x", keys = "g" },

            -- Marks
            { mode = "n", keys = "'" },
            { mode = "n", keys = "`" },
            { mode = "x", keys = "'" },
            { mode = "x", keys = "`" },

            -- Registers
            { mode = "n", keys = '"' },
            { mode = "x", keys = '"' },
            { mode = "i", keys = "<C-r>" },
            { mode = "c", keys = "<C-r>" },

            -- Window commands
            { mode = "n", keys = "<C-w>" },

            -- `z` key
            { mode = "n", keys = "z" },
            { mode = "x", keys = "z" },
        },

        clues = {
            mappings.buffer(),
            mappings.git(),
            mappings.helix(),
            mappings.lsp(),
            mappings.plugin(),
            mappings.session(),

            --{ mode = "n", keys = "<Leader>b", desc = "Manage buffers →" },
            --{ mode = "n", keys = "<Leader>g", desc = "Git operations →" },
            --{ mode = "n", keys = "<Leader>l", desc = "Language server actions →" },
            --{ mode = "n", keys = "<Leader>m", desc = "Plugin actions →" },
            --{ mode = "n", keys = "<Leader>s", desc = "Manage sessions →" },
            --{ mode = "n", keys = "<Leader>f", desc = " Find" },
            --{ mode = "n", keys = "<Leader>i", desc = "󰏪 Insert" },
            --{ mode = "n", keys = "<Leader>m", desc = " Mini" },
            --{ mode = "n", keys = "<Leader>q", desc = " NVim" },
            --{ mode = "n", keys = "<Leader>s", desc = "󰆓 Session" },
            --{ mode = "n", keys = "<Leader>u", desc = "󰔃 UI" },
            --{ mode = "n", keys = "<Leader>w", desc = " Window" },


            require("mini.clue").gen_clues.g(),
            require("mini.clue").gen_clues.builtin_completion(),
            require("mini.clue").gen_clues.marks(),
            require("mini.clue").gen_clues.registers(),
            require("mini.clue").gen_clues.windows(),
            require("mini.clue").gen_clues.z(),
        },
        window = {
            delay = 100,
            config = { width = "auto", border = "single" },
        },
    })

end)

later(function() require('mini.colors').setup() end)
later(function() require('mini.comment').setup() end)

later(function() require('mini.cursorword').setup() end)

later(function()
  require('mini.diff').setup()
  local rhs = function() return MiniDiff.operator('yank') .. 'gh' end
  vim.keymap.set('n', 'ghy', rhs, { expr = true, remap = true, desc = "Copy hunk's reference lines" })
end)

later(function() require('mini.doc').setup() end)
later(function() require('mini.git').setup() end)

later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function() require('mini.indentscope').setup() end)
later(function() require('mini.jump').setup() end)

later(function()
  local jump2d = require('mini.jump2d')
  jump2d.setup({
    -- TODO remove below line as it is deprecated.
    -- spotter = jump2d.gen_pattern_spotter('[^%s%p]+'),

    spotter = jump2d.gen_spotter.pattern('[^%s%p]+'),
    view = { dim = true, n_steps_ahead = 2 },
  })
end)

later(function()
  local map = require('mini.map')
  local gen_integr = map.gen_integration
  map.setup({
    symbols = { encode = map.gen_encode_symbols.dot('4x2') },
    integrations = { gen_integr.builtin_search(), gen_integr.diff(), gen_integr.diagnostic() },
  })
  vim.keymap.set('n', [[\h]], ':let v:hlsearch = 1 - v:hlsearch<CR>', { desc = 'Toggle hlsearch' })
  for _, key in ipairs({ 'n', 'N', '*' }) do
    vim.keymap.set('n', key, key .. 'zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>')
  end
end)

later(function()
  require('mini.misc').setup({ make_global = { 'put', 'put_text', 'stat_summary', 'bench_time' } })
  MiniMisc.setup_auto_root()
  MiniMisc.setup_termbg_sync()
end)

later(function() require('mini.move').setup({ options = { reindent_linewise = false } }) end)

later(function()
  local remap = function(mode, lhs_from, lhs_to)
    local keymap = vim.fn.maparg(lhs_from, mode, false, true)
    local rhs = keymap.callback or keymap.rhs
    if rhs == nil then error('Could not remap from ' .. lhs_from .. ' to ' .. lhs_to) end
    vim.keymap.set(mode, lhs_to, rhs, { desc = keymap.desc })
  end
  --remap('n', 'gx', '<Leader>ox')
  --remap('x', 'gx', '<Leader>ox')

  require('mini.operators').setup()
end)

later(function()
  require('mini.pairs').setup({ modes = { insert = true, command = true, terminal = true } })
--  vim.keymap.set('i', '<CR>', 'v:lua.Config.cr_action()', { expr = true })
end)

later(function() require('mini.pairs').setup() end)

later(function() require('mini.splitjoin').setup() end)

later(function()
  require('mini.surround').setup({ search_method = 'cover_or_next' })
  -- Disable `s` shortcut (use `cl` instead) for safer usage of 'mini.surround'
  vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
end)

later(function() require('mini.trailspace').setup() end)

later(function() require('mini.visits').setup() end)

