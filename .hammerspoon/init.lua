--- Keyboard layout
function selectKarabinerProfile(profile)
  hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile '" .. profile .. "'")
end

function plainInputSourceChange()
  isrc = hs.keycodes.currentLayout():gsub('%.', '')
  selectKarabinerProfile(isrc)
end
hs.keycodes.inputSourceChanged(plainInputSourceChange)

--- SKHD mode menu
skhd_mode = nil
skhdmenu = hs.menubar.new()
function updateSkhdMode()
  if skhd_mode ~= nil then
    skhdmenu:setIcon(hs.configdir .. '/assets/' .. skhd_mode .. '.tiff')
    --skhdmenu:setTitle(mode)
  else
    --skhdmenu:setTitle("")
    skhdmenu:setIcon(hs.configdir .. '/assets/code.tiff')
    ---skhdmenu:setIcon()
    ---shkdmebu = nil
  end
end

updateSkhdMode()

hs.urlevent.bind("skhd_mode", function(eventName, params)
  if params["mode"] then
    skhd_mode = params["mode"]
  else  
    skhd_mode = nil
  end
  updateSkhdMode()
end)

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

--- hammerspoon config
hs.autoLaunch(true)
hs.automaticallyCheckForUpdates(true)
hs.consoleOnTop(true)
hs.dockIcon(false)
hs.menuIcon(true)
hs.uploadCrashData(false)
hs.alert.show('Config loaded!')

function reloadConfig()
    if configFileWatcher ~= nil then
        configFileWatcher:stop()
        configFileWatcher = nil
    end

    hs.reload()
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/init.lua", reloadConfig)
configFileWatcher:start()
