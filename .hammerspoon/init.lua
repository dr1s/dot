
require "border"
require "yabai"
require "skhd"

--- Keyboard layout
function selectKarabinerProfile(profile)
  hs.execute("'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile '" .. profile .. "'")
end

function plainInputSourceChange()
  isrc = hs.keycodes.currentLayout():gsub('%.', '')
  selectKarabinerProfile(isrc)
end
hs.keycodes.inputSourceChanged(plainInputSourceChange)

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
