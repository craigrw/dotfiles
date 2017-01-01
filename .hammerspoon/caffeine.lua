

local caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle("AWAKE")
  else
    caffeine:setTitle("SLEEPY")
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

local mod = {}

function mod.init()
  if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    hs.caffeinate.set("acAndBattery", false)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
  end
end

return mod