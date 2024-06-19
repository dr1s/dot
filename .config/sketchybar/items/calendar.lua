local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
  icon = {
    color = colors.white,
    font = {
      style = settings.font.style_map["Semibold"],
      size = 10.0,
    },
  },
  label = {
    color = colors.white,
    width = 39,
    align = "right",
    font = {
      family = settings.font.numbers,
      size = 10.0,
    },
  },
  position = "right",
  update_freq = 30,
  padding_left = 4,
  padding_right = 4,
})

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal.name }, {
  background = {
    color = colors.transparent,
    height = 22,
    border_color = colors.bg2,
  }
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  cal:set({ icon = os.date("%a. %d %b."), label = os.date("%H:%M") })
end)
