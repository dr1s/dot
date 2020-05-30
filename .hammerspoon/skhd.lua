
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


