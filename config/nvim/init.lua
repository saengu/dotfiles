--          ╔═════════════════════════════════════════════════════════╗
--          ║                          MVIM                           ║
--          ╚═════════════════════════════════════════════════════════╝

--  ─( mini.nvim )──────────────────────────────────────────────────────
--          ┌─────────────────────────────────────────────────────────┐
--                Bootstrap 'mini.nvim' manually in a way that it
--                          gets managed by 'mini.deps'
--                Borrowed from echasnovski's personal nvim config
--                  https://github.com/echasnovski/nvim/init.lua
--          └─────────────────────────────────────────────────────────┘

-- Manually with git clone
--[[
local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
--]]

-- Borrow from https://github.com/nvim-mini/MiniMax
-- Use vim pack (neovim >= 0.12)
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

local misc = require('mini.misc')

-- Define main config table to be able to use it in scripts
_G.Core = {}

Core.now = function(fn) misc.safely('now', fn) end
Core.later = function(fn) misc.safely('later', fn) end
Core.now_if_args = vim.fn.argc(-1) > 0 and Core.now or Core.later
Core.on_event = function(evt, fn) misc.safely('event:' .. evt, fn) end
Core.on_filetype = function(ft, fn) misc.safely('filetype:' .. ft, fn) end

local group = vim.api.nvim_create_augroup('custom-config', {})
Core.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = group, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

-- Define custom `vim.pack.add()` hook helper. See `:h vim.pack-events`.
-- Example usage: see 'plugin/40_plugins.lua'.
Core.on_packchanged = function(plugin_name, kinds, callback, desc)
  local fn = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Core.new_autocmd('PackChanged', '*', fn, desc)
end


--          ┌─────────────────────────────────────────────────────────┐
--                  Load mini.nvim modules and third-party plugins
--          └─────────────────────────────────────────────────────────┘
require("options")
require("plugins")
require("mappings")

--          ┌─────────────────────────────────────────────────────────┐
--                  This is for work related, non mini Plugins.
--                  Borrowed from https://gitlab.com/domsch1988/mvim
--          └─────────────────────────────────────────────────────────┘
local path_modules = vim.fn.stdpath("config") .. "/lua/"
if vim.uv.fs_stat(path_modules .. "work.lua") then
    require("work")
end
