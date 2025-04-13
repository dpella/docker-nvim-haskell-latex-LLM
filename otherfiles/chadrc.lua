-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  theme_toggle = { "catppuccin", "github_light" },
  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.ui = {
  statusline = {
    theme = "minimal",
    separator_style = "round",
  },
}

M.nvdash = {
  load_on_startup = true,

  header = {
    "     _            _ _        ",
    "  __| |_ __   ___| | | __ _  ",
    " / _` | '_ \\ / _ \\ | |/ _` | ",
    "| (_| | |_) |  __/ | | (_| | ",
    " \\__,_| .__/ \\___|_|_|\\__,_| ",
    "      |_|                    ",
  },
}
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

return M
