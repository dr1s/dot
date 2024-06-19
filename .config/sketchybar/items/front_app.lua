-- local colors = require("colors")
-- local settings = require("settings")
--
-- local front_app = sbar.add("item", "front_app", {
--   display = "active",
--   icon = { drawing = false },
--   label = {
--     font = {
--       style = settings.font.style_map["Black"],
--       size = 10.0,
--     },
--   },
--   updates = true,
-- })
--
-- front_app:subscribe("front_app_switched", function(env)
--   front_app:set({ label = { string = env.INFO } })
-- end)
--
-- front_app:subscribe("mouse.clicked", function(env)
--   sbar.trigger("swap_menus_and_spaces")
-- end)

local colors = require("colors")
local settings = require("settings")

-- Events that get pushed by yabai
sbar.add("event", "window_focus")
sbar.add("event", "title_change")

local front_app = sbar.add("item", "front_app", {
  position = "left",
  display = "active",
  icon = {
    background = {
      drawing = true,
      image = {
        border_width = 0,
        border_color = colors.bg1,
        scale = 0.5,
        padding_left = 8,
        padding_right = 2,
      },
    },
  },
  label = {
    font = {
      style = settings.font.style_map["Semibold"],
      size = 10.0,
    },
    padding_left = 2,
    padding_right = 8
  },
  updates = true,
  background = {
    color = colors.bg1,
    border_width = 1,
    height = 24,
    border_color = colors.orange,
  },
})

local function set_window_title()
  -- Offloading the "yabai -m query --windows --window" script to an external shell script so that we can determine whether the space has no windows
  sbar.exec("~/.config/sketchybar/helpers/query_window.sh", function(result)
    if result ~= "empty" and type(result) == "table" and result.app then
      local window_title = result.app
      if #window_title > 50 then
        window_title = window_title:sub(1, 50) .. "..."
      end
      front_app:set({ label = { string = window_title } })
    else
      -- Set title to Finder, as empty spaces will not return a window title
      front_app:set({ label = { string = "Finder" } })
    end
  end)
end

front_app:subscribe("front_app_switched", function(env)
  front_app:set({
    icon = { background = { image = "app." .. env.INFO } }
  })
  set_window_title()
end)

front_app:subscribe("space_change", function()
  set_window_title()
end)

front_app:subscribe("window_focus", function()
  set_window_title()
end)

front_app:subscribe("title_change", function()
  set_window_title()
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
