--- yabai/hammerspoon menu

json = require "json"
yabai = '/usr/local/bin/yabai'

menu = hs.menubar.new()

function yabaiSwitchMode(yabai_mode)
  if yabai_mode == "bsp" then
    hs.execute(yabai .. " -m space --layout float")
  else
    hs.execute(yabai .. " -m space --layout bsp")
  end
  updateMenu()
end

function updateMenu()
  yjson = hs.execute(yabai .. " -m query --spaces --space")
  if yjson ~= '' then
    space = json.decode(yjson)
    yabai_mode = space['type']
    menu:setIcon(hs.configdir .. '/assets/' .. yabai_mode .. '.tiff')
    menu:setMenu(function() yabaiSwitchMode(yabai_mode) end )
  else
    menu:setIcon(hs.configdir .. '/assets/x.tiff')
  end
end

updateMenu()

hs.timer.doEvery(30, updateMenu)
hs.urlevent.bind("cmenu", function(eventName, params)
  updateMenu()
end)


