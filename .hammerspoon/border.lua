
--- highlight active window with boarder
global_border = nil
borderEnabled = true

function drawBorder(top_left, size)
  global_border = hs.drawing.rectangle(hs.geometry.rect(top_left['x'], top_left['y'], size['w'], size['h']))
  global_border:setStrokeColor({["red"]=0.9020,["blue"]=0.1961,["green"]=0.5020,["alpha"]=0.8})
  global_border:setFill(false)
  global_border:setStrokeWidth(2)
  global_border:setRoundedRectRadii(5,5)
  global_border:show()
end

function removeBorder()
  if global_border ~= nil then
    global_border:delete()
    global_border = nil
  end
end


function redrawBorder()
  if borderEnabled then
    win = hs.window.focusedWindow()
    if win ~= nil then
        screenWin = win:screen():frame()
        top_left = win:topLeft()
        size = win:size()
        removeBorder()
        if top_left ~= screenWin.topleft or size ~= screenWin.size then
          drawBorder(top_left, size)
        end
    else
      removeBorder()
    end
  else
    removeBorder()
  end
end

--redrawBorder()

hs.urlevent.bind("activeBorder", function(eventName, params)
    if borderEnabled then
      borderEnabled = false
    else
      borderEnabled = true
    end
    redrawBorder()
end)

if borderEnabled then
  allwindows = hs.window.filter.new(nil)
  allwindows:subscribe(hs.window.filter.windowCreated, redrawBorder)
  allwindows:subscribe(hs.window.filter.windowFocused, redrawBorder)
  allwindows:subscribe(hs.window.filter.windowMoved, redrawBorder)
  allwindows:subscribe(hs.window.filter.windowUnfocused, redrawBorder)
end
