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

local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/nvim-mini/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' immediately to have its `now()` and `later()` helpers
require('mini.deps').setup()

-- Define main config table to be able to use it in scripts
--_G.Config = {}


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
