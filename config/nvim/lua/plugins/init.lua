--          ╔═════════════════════════════════════════════════════════╗
--          ║     Load mini.nvim Modules and Third-Party PLugins      ║
--          ╚═════════════════════════════════════════════════════════╝

--          ┌─────────────────────────────────────────────────────────┐
--                    We borrowed configurations from
--                1. https://github.com/echasnovski/nvim/init.lua
--                2. https://gitlab.com/domsch1988/mvim
--                3. https://github.com/pkazmier/nvim
--          └─────────────────────────────────────────────────────────┘


--  ─( mini.nvim modules)───────────────────────────────────────────────
require("plugins.mini")

--  ─( third-party plugins )────────────────────────────────────────────
require("plugins.extra")

--  ─( third-party plugins )────────────────────────────────────────────
require("plugins.cmp")
--require("plugins.blink")

--- Below modules are DEPRECATED as them have been merged into extra.lua
--
-- require("plugins.lsp")
-- require("plugins.telescope")
-- require("plugins.treesitter")
-- require("plugins.themes")
