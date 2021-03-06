local spaces = require 'hs._asm.undocumented.spaces'
local application = require 'hs.application'
local fnutils = require 'hs.fnutils'
local layout = require 'hs.layout'
local screen = require 'hs.screen'

local logger = hs.logger.new('screens', 'debug')

local locations = {
  'laptop',
  'home',
  'office'
}

local locationsByPrimaryScreen = {
  ['Color LCD'] = 'laptop',
  ['ASUS PB278'] = 'home',
  ['DELL P2715Q'] = 'bench'
}

local leftSmall = {x=0, y=0, w=0.45, h=1}
local rightLarge = {x=0.45, y=0, w=0.55, h=1}
local leftLarge = {x=0, y=0, w=0.60, h=1}
local rightSmall = {x=0.60, y=0, w=0.40, h=1}
local full = layout.maximized

local function screen1()
  return hs.screen.allScreens()[1]
end

local function screen2()
  return hs.screen.allScreens()[2]
end

local function screen3()
  return hs.screen.allScreens()[3]
end

local function laptop()
  if location == 'laptop' then return screen1()
  else return screen2()
  end
end

local function monitor1()
  if not (location == 'laptop') then return screen1()
  else return nil
  end
end

local function monitor2()
  if location == 'bench' then return screen3()
  else return nil
  end
end

local locationLayouts = {
  laptop = {
    { 'Google Chrome', nil, laptop, full, nil, nil },
    { 'Safari', nil, laptop, full, nil, nil },
    { 'Slack', nil, laptop, full, nil, nil },
    { 'iTunes', nil, laptop, full, nil, nil },
    { 'iTerm2', nil, laptop, full, nil, nil },
    { 'Sublime Text', nil, laptop, full, nil, nil },
    { 'IntelliJ IDEA', nil, laptop, full, nil, nil }
  },
  home = {
    { 'Google Chrome', nil, laptop, full, nil, nil },
    { 'Safari', nil, monitor1, rightLarge, nil, nil },
    { 'Slack', nil, laptop, full, nil, nil },
    { 'iTunes', nil, laptop, full, nil, nil },
    { 'iTerm2', nil, monitor1, leftSmall, nil, nil },
    { 'Sublime Text', nil, monitor1, rightLarge, nil, nil },
    { 'IntelliJ IDEA', nil, monitor1, rightLarge, nil, nil },
    { 'IntelliJ IDEA', 'Run', monitor1, leftSmall, nil, nil }
  },
  bench = {
    { 'Google Chrome', nil, laptop, full, nil, nil },
    { 'Safari', nil, monitor1, leftLarge, nil, nil },
    { 'Slack', nil, laptop, full, nil, nil },
    { 'iTunes', nil, laptop, full, nil, nil },
    { 'iTerm2', nil, monitor1, rightSmall, nil, nil },
    { 'Sublime Text', nil, monitor1, leftLarge, nil, nil },
    { 'IntelliJ IDEA', nil, monitor1, leftLarge, nil, nil },
    { 'IntelliJ IDEA', 'Run', monitor1, rightSmall, nil, nil }
  }
  -- {
  --   { 'Google Chrome', nil, laptop, full, nil, nil },
  --   { 'Slack', nil, laptop, full, nil, nil },
  --   { 'iTunes', nil, laptop, full, nil, nil },
  --   { 'iTerm2', nil, monitor1, full, nil, nil },
  --   { 'IntelliJ IDEA', nil, monitor2, full, nil, nil },
  --   { 'Sublime Text', nil, monitor2, leftLarge, nil, nil } 
  -- }
}

-- local locationApplications = fnutils.map(locationLayouts, function (locationLayout)
--   fnutils.map(locationLayout, function (layout)
--     return layout[1]
--   end)
-- end)

local appLayoutEvents = {
  [application.watcher.hidden] = true,
  [application.watcher.launched] = true,
  [application.watcher.terminated] = true,
  [application.watcher.unhidden] = true
}

local function detectLocation()
  local primary = screen.primaryScreen()
  location = locationsByPrimaryScreen[primary:name()]
  logger.d('Detected location ' .. location)
  return location
end

local function layoutOnAppLaunch(appName, event, app)
  -- for k,v in pairs(appLayoutEvents) do logger.d(k, v) end
  -- logger.d(event .. ' - ' .. appName .. ' - ') --  .. appLayoutEvents[event])
  -- if appLayoutEvents[event] then 
  --   logger.d(event .. ' - ' .. appName) 
  --   logger.d(locationLayouts[detectLocation()])
  --   logger.d(locationLayouts[detectLocation()])
  -- end
  if appLayoutEvents[event] and locationLayouts[detectLocation()][0] == appName then mod.setLayout() end
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
  local appWatcher = application.watcher.new(layoutOnAppLaunch):start()
  mod.setLayout()
end

return mod

