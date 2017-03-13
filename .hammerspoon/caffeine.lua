local logger = hs.logger.new('caffeine', 'debug')

local caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle("☕")
  else
    caffeine:setTitle("😴")
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

function setBackground()
  os.execute("/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background &")
end

function resetBackground()
  os.execute("pkill ScreenSaverEngine")
end

local mod = {}

function mod.init()
  if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    hs.caffeinate.set("acAndBattery", false)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
  end

  hs.caffeinate.watcher.new(function(event)
    if event == hs.caffeinate.watcher.systemWillSleep then
      setBackground()
    elseif event == hs.caffeinate.watcher.systemDidWake then
      resetBackground()
    end
  end):start()
  setBackground()
end

return mod