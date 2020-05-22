json = require "json"
logger = hs.logger.new('new', 'debug')

--- highlight active window with boarder
global_border = nil
borderEnabled = true

function redrawBorder()
  if borderEnabled then
    win = hs.window.focusedWindow()
    if win ~= nil then
        top_left = win:topLeft()
        size = win:size()
        if global_border ~= nil then
            global_border:delete()
        end
        global_border = hs.drawing.rectangle(hs.geometry.rect(top_left['x'], top_left['y'], size['w'], size['h']))
        global_border:setStrokeColor({["red"]=0.9020,["blue"]=0.1961,["green"]=0.5020,["alpha"]=0.8})
        global_border:setFill(false)
        global_border:setStrokeWidth(2)
        global_border:setRoundedRectRadii(5,5)
        global_border:show()
    else
      if global_border ~= nil then
        global_border:delete()
        global_border = nil
      end
    end
  else
    if global_border ~= nil then
      global_border:delete()
        global_border = nil
    end
  end
end

redrawBorder()

hs.urlevent.bind("activeBorder", function(eventName, params)
    if borderEnabled then
      borderEnabled = false
    else
      borderEnabled = true
    end
    redrawBorder()
end)

allwindows = hs.window.filter.new(nil)
allwindows:subscribe(hs.window.filter.windowCreated, function () redrawBorder() end)
allwindows:subscribe(hs.window.filter.windowFocused, function () redrawBorder() end)
allwindows:subscribe(hs.window.filter.windowMoved, function () redrawBorder() end)
allwindows:subscribe(hs.window.filter.windowUnfocused, function () redrawBorder() end)

--- Keyboard layout
function selectKarabinerProfile(profile)
  hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile '" .. profile .. "'")
end

function plainInputSourceChange()
  isrc = hs.keycodes.currentLayout():gsub('%.', '')
  selectKarabinerProfile(isrc)
end
hs.keycodes.inputSourceChanged(plainInputSourceChange)

--- yabai/hammerspoon menu

yabai = '/usr/local/bin/yabai '

menu = hs.menubar.new()
function yabaiSwitchMode(yabai_mode)
  if yabai_mode == "bsp" then
    hs.execute("/usr/local/bin/yabai -m space --layout float")
  else
    hs.execute("/usr/local/bin/yabai -m space --layout bsp")
  end
  updateMenu()
end


function updateMenu(mode)
  yjson = hs.execute(yabai .. " -m query --spaces --space")
  space = json.decode(yjson)

  yabai_mode = space['type']
  if yabai_mode == '' then
    menu:setIcon(hs.configdir .. '/assets/x.tiff')
  else
    menu:setIcon(hs.configdir .. '/assets/' .. yabai_mode .. '.tiff')
  end
  menu:setMenu({
       { title = 'Yabai', disabled = true },
       { title = '-' },
       { title = 'mode: ' .. yabai_mode, fn = function() yabaiSwitchMode(yabai_mode) end },
       { title = '-' },
       { title = 'Hammerspoon ' .. hs.processInfo.version, disabled = true },
       { title = '-' },
       { title = 'Reload', fn = hs.reload },
       { title = 'Console...', fn = hs.openConsole },
       { title = '-' },
       { title = 'Quit', fn = function() hs.application.get(hs.processInfo.processID):kill() end }
  })
end

updateMenu()
---hs.timer.doEvery(20, updateMenu)

hs.urlevent.bind("cmenu", function(eventName, params)
  updateMenu()
end)

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

spacesMenu = hs.menubar.new()
function getActiveSpaces()
  yjson = hs.execute(yabai .. " -m query --displays")
  displays = json.decode(yjson)
  menu_title = ''
  for i = 1,#displays,1 do
    dspacetmp = hs.execute(yabai .. ' -m query --spaces --display ' .. i)
    --logger:d(dspacetmp)
    dspace = json.decode(dspacetmp)
    for d = 1,#dspace,1 do
      if dspace[d]['visible'] == 1 then
        menu_title = menu_title .. ' [' .. dspace[d]['index'] .. ']'
      else
        menu_title = menu_title .. ' ' .. dspace[d]['index']
      end
    end
    if i < #displays then
      menu_title = menu_title .. ' | '
    end
    --menu_title = menu_title .. ' ' .. i
  end
  spacesMenu:setTitle(menu_title)
end
getActiveSpaces()

spaceWatcher = hs.spaces.watcher.new(getActiveSpaces)
spaceswindows = hs.window.filter.new(nil)
spaceswindows:subscribe(hs.window.filter.windowCreated, function () getActiveSpaces(); updateMenu() end)
spaceswindows:subscribe(hs.window.filter.windowFocused, function () getActiveSpaces(); updateMenu()  end)
spaceswindows:subscribe(hs.window.filter.windowMoved, function () getActiveSpaces(); updateMenu()  end)
spaceswindows:subscribe(hs.window.filter.windowUnfocused, function () getActiveSpaces(); updateMenu()  end)
--- hammerspoon config
hs.autoLaunch(true)
hs.automaticallyCheckForUpdates(true)
hs.consoleOnTop(true)
hs.dockIcon(false)
hs.menuIcon(false)
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
