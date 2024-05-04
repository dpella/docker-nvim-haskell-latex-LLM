-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "onedark",
  statusline = {
    theme = "minimal",
    separator_style = "round",
  },
  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
  nvdash = {
    load_on_startup = true,

    header = {
       "     _            _ _        ",
       "  __| |_ __   ___| | | __ _  ",
       " / _` | '_ \\ / _ \\ | |/ _` | ",
       "| (_| | |_) |  __/ | | (_| | ",
       " \\__,_| .__/ \\___|_|_|\\__,_| ",
       "      |_|                    ",
    },

    buttons = {
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "  Bookmarks", "Spc m a", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },
}

return M

