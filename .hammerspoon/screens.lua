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
  [''] = 'bench'
}

local left = {x=0, y=0, w=0.45, h=1}
local right = {x=0.45, y=0, w=0.55, h=1}
local full = layout.maximized

local locationLayouts = {
  laptop = {
    { 'iTerm2', nil, 'Color LCD', full, nil, nil },
    { 'Sublime Text', nil, 'Color LCD', full, nil, nil },
    { 'IntelliJ IDEA', nil, 'Color LCD', full, nil, nil }
  },
  home = {
    { 'Safari', nil, 'ASUS PB278', right, nil, nil },
    { 'iTerm2', nil, 'ASUS PB278', left, nil, nil },
    { 'Sublime Text', nil, 'ASUS PB278', right, nil, nil },
    { 'IntelliJ IDEA', nil, 'ASUS PB278', right, nil, nil },
    { 'IntelliJ IDEA', 'Run', 'ASUS PB278', left, nil, nil }
  }
}

local function detectLocation()
  local primary = screen.primaryScreen()
  local location = locationsByScreen[primary:name()]
  logger.d('Detected location ' .. location)
  return location
end

local mod = {}

function mod.setLayout()
  local location = detectLocation()
  hs.alert.show(location)
  layout.apply(locationLayouts[location])
end

function mod.init()
  hs.hotkey.bind({"cmd", "alt", "ctrl"}, "l", mod.setLayout)
  hs.application.enableSpotlightForNameSearches(false)

  local screenWatcher = screen.watcher.new(mod.setLayout):start()
  mod.setLayout()
end

return mod

