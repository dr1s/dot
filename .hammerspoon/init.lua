--- highlight active window with boarder
global_border = nil

function redrawBorder()
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
    end
end

redrawBorder()


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
  ytmp = hs.execute("/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.type'")
  yabai_mode = ytmp:gsub('%"', ''):gsub('\n', '')
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

hs.urlevent.bind("cmenu", function(eventName, params)
  updateMenu()
end)
--- SKHD mode menu

skhdmenu = hs.menubar.new()
function updateSkhdMode(mode)
  if mode ~= nil then
    skhdmenu:setTitle(mode)
  else
    skhdmenu:setTitle("")
  end
end

updateSkhdMode()

hs.urlevent.bind("skhd_mode", function(eventName, params)
  if params["mode"] then
    updateSkhdMode(params["mode"])
  else  
    updateSkhdMode()
  end
end)

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
