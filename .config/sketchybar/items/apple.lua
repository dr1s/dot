local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", { width = 5 })

local apple = sbar.add("item", {
  icon = {
    font = { size = 14.0 },
    string = icons.apple,
    padding_right = 6,
    padding_left = 6,
  },
  label = { drawing = false },
  background = {
    color = colors.bg1,
    border_color = colors.bg1,
    border_width = 1
  },
  padding_left = 1,
  padding_right = 1,
  click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0"
})

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
  background = {
    color = colors.transparent,
    height = 22,
    border_color = colors.bg1,
    border_width = 2
  }
})

-- Padding item required because of bracket
sbar.add("item", { width = 7 })
