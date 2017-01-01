local spaces = require 'hs._asm.undocumented.spaces'
local screen = require 'hs.screen'
local layout = require 'hs.layout'

local logger = hs.logger.new('screens', 'debug')

local locations = {
  'laptop', 
  'home', 
  'office'
}

local locationsByScreen = {
  ['Color LCD'] = 'laptop', 
  ['ASUS PB278'] = 'home', 
  [''] = 'office'
}

local locationLayouts = {
  laptop = {
    { 'iTerm2', nil, 'Color LCD', layout.maximized, nil, nil },
    { 'IntelliJ IDEA', nil, 'Color LCD', layout.maximized, nil, nil },
    { 'Sublime Text', nil, 'Color LCD', layout.maximized, nil, nil }
  },
  home = {
    { 'iTerm2', nil, 'ASUS PB278', {x=0, y=0, w=0.45, h=1}, nil, nil },
    { 'Sublime Text', nil, 'ASUS PB278', {x=0.45, y=0, w=0.55, h=1}, nil, nil },
    { 'IntelliJ IDEA', nil, 'ASUS PB278', {x=0.45, y=0, w=0.55, h=1}, nil, nil }
  }
}

local function detectLocation() 
  primary = screen.primaryScreen()
  location = locationsByScreen[primary:name()]
  logger.d('Detected location ' .. location)

  -- hs.fnutils.ieach(spaces.query(spaces.masks.currentSpaces), function (e)
  --   logger.d(e)
  -- end)
  -- screenUUID = spaces.mainScreenUUID()
  -- logger.d(screenUUID)
  -- hs.fnutils.ieach(spaces.spacesByScreenUUID(screenUUID), function (e)
  --   logger.d(e)
  -- end)
  -- logger.d(screen:spaces(screen.primaryScreen()))
  -- logger.d() -- spaces.UUIDforScreen(screen.primaryScreen())))
  return location
end

local mod = {}

function mod.setLayout()
  location = detectLocation()
  hs.alert.show(location)
  layout.apply(locationLayouts[location])
end

function mod.init()
  -- hs.grid.setGrid('10x5')
  -- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "g", hs.grid.show)
  hs.application.enableSpotlightForNameSearches(false)

  local screenWatcher = screen.watcher.new(mod.setLayout):start()
  mod.setLayout()
end

return mod

