local logger = hs.logger.new('screens', 'debug')

local locationsByScreen = {
  ['Color LCD'] = 'laptop', 
  ['ASUS PB278'] = 'home', 
  [''] = 'office'
}

local locations = {
  'laptop', 
  'home', 
  'office'
}

local function detectLocation() 
  name = hs.screen.primaryScreen():name()  
  location = locationsByScreen[name]
  logger.d('Detected location ' .. location)
  return location
end

local mod = {}

function mod.setLayout()
  hs.alert.show(detectLocation())
end

function mod.init()
  local screenWatcher = hs.screen.watcher.new(mod.setLayout):start()
end

return mod