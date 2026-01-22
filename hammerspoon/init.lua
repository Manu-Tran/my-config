Drag = hs.loadSpoon("Drag")

hs.spaces.setDefaultMCwaitTime(0.3)
require("hs.ipc")
debugMode = false

function adjustSpaceCount(screen, target, spaces)
  local lenSpaces = #spaces[screen]
  local spacesChanges = lenSpaces - target
  if spacesChanges > 0 then
    hs.spaces.gotoSpace(spaces[screen][1])
    hs.spaces.closeMissionControl()
    for i=0,spacesChanges-1 do
      -- print(i)
      -- print(lenSpaces-i)
      -- print(spaces[screen][lenSpaces-i])
      hs.spaces.removeSpace(spaces[screen][lenSpaces-i], true)
    end
  else if spacesChanges < 0 then
    for _=spacesChanges,1 do
      hs.spaces.addSpaceToScreen(screen, true)
    end
  end end
  hs.spaces.closeMissionControl()
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function adjustScreen()
  -- Front screen by relative coordinate
  local main_screen = hs.screen.find("-1 -1")
  -- Right screen by relative coordinate
  local secondary_screen = hs.screen.find("0 -1")
  -- Mac screen by relative coordinate
  local builtin_screen = hs.screen.find("0 0")
  if main_screen == nil then
    adjustTwoScreen()
    return
  end
  print("main_screen found")
  if secondary_screen == nil then
    print("secondary_screen")
    adjustTwoScreen()
    return
  end
  print("secondary_screen found")
  if builtin_screen == nil then
    print("builtin_screen")
    adjustTwoScreen()
    return
  end
  print("builtin_screen found")

  print("Using 3 screens setup")
  local spaces = hs.spaces.allSpaces()
  adjustSpaceCount(main_screen:getUUID(), 3, spaces)
  adjustSpaceCount(secondary_screen:getUUID(), 9, spaces)
  adjustSpaceCount(builtin_screen:getUUID(), 5, spaces)
end

function adjustTwoScreen()
    -- Left screen by relative coordinate in 2 screens setup
    local main_screen = hs.screen.find("-1 0")
    -- Mac screen by relative coordinate
    local builtin_screen = hs.screen.find("0 0")
    if main_screen == nil then
        print("main_screen")
        return
    end
    print("main_screen found")
    if builtin_screen == nil then
        print("builtin_screen")
        return
    end
    print("builtin_screen found")
    print("Switching to 2 screens setup")
    local spaces = hs.spaces.allSpaces()
    adjustSpaceCount(main_screen:getUUID(), 8, spaces)
    adjustSpaceCount(builtin_screen:getUUID(), 7, spaces)
end


function moveWindows()
  execTaskInShellSync("/Users/emmanueltran/bin/restoreWorkspaces.sh")
end

function screenWatcher()
  -- adjustScreen()
  -- moveWindows()
  -- hs.notify.show("Hammerspoon", "Screen Watcher", "Script run successfully !")
end

function onWakeUp(eventType)
  if eventType == hs.caffeinate.watcher.screensDidUnlock then
    moveWindows()
    -- hs.notify.show("Hammerspoon", "Screen Watcher", "Script run successfully !")
  end
end

function append(source, ...)
    for k, v in ipairs({ ... }) do
        table.insert(source, v)
    end
    return source
end

execTaskInShellSync = (function()
    local pathEnv = ""
    local fn = function(cmdWithArgs, callback, withLogin)
        -- if not coroutine.isyieldable() then
        --     print("this function cannot be invoked on the main Lua thread")
        -- end

        if callback == nil then
            callback = function(exitCode, stdOut, stdErr)
            end
        end

        local done = false
        local out = nil

        local cmd = {}

        if withLogin == true then
            append(cmd, "-l", "-i", "-c")
        else
            append(cmd, "-c")
        end

        if pathEnv ~= "" then
            table.insert(cmd, "export PATH=\"" .. pathEnv .. "\";" .. cmdWithArgs)
        else
            table.insert(cmd, cmdWithArgs)
        end

        local t = hs.task.new(os.getenv("SHELL"), function(exitCode, stdOut, stdErr)
            callback(exitCode, stdOut, stdErr)
            if debugMode == true then
                print("cmd: ", cmdWithArgs)
                print("out: ", stdOut)
                print("err: ", stdErr)
            end
            out = stdOut
            done = true
        end, cmd)

        t:start()

        -- while done == false do
        --     coroutine.applicationYield()
        -- end

        return out
    end

    return function(cmdWithArgs, callback, withEnv)
        if pathEnv == "" then
          pathEnv = "/opt/homebrew/bin:/Users/emmanueltran/bin"
        end
        return fn(cmdWithArgs, callback, withEnv)
    end
end)()

function usbWatcher(t)
  if t["eventType"] == "removed" then
    if t["productName"] == "Moonlander Mark I" then
      hs.caffeinate.systemSleep()
    end
  end
end

usb = hs.usb.watcher.new(usbWatcher)
watcher = hs.screen.watcher.new(screenWatcher)
wakeWatcher = hs.caffeinate.watcher.new(onWakeUp)

usb:start()
watcher:start()
wakeWatcher:start()

-- Set up the logger
local log = hs.logger.new('WindowMover', 'info')

-- Convert seconds to microseconds
local timeUnit = 1000 * 1000
-- delay: in seconds
function asyncLeftClick(point, delay, onFinished)
    local module = hs.eventtap
    module.event.newMouseEvent(module.event.types["leftMouseDown"], point):post()

    hs.timer.doAfter(delay, function()
        module.event.newMouseEvent(module.event.types["leftMouseUp"], point):post()
        if onFinished then
            onFinished()
        end
    end)
end

-- Move window to space
function moveWindowToSpace(window, spaceNumber)
    log.i("Moving window " .. window:title() .. " to space " .. spaceNumber)
    local prevCursorPoint = hs.mouse.absolutePosition()
    local winFrame = window:frame()
    local point = hs.geometry(winFrame.x + 5, winFrame.y + 15)
    asyncLeftClick(point, 1, function()
        -- Restore cursor position
        hs.mouse.absolutePosition(prevCursorPoint)
    end)
    -- Switch to target space with Mission Control shortcuts
    if spaceNumber < 10 then
        hs.eventtap.keyStroke({ 'alt' }, tostring(spaceNumber), 0.2 * timeUnit)
    else
        hs.eventtap.keyStroke({ 'alt', 'ctrl' }, tostring(spaceNumber - 10), 0.2 * timeUnit)
    end
end

-- Function to move focused window to a specific space
function moveFocusedWindowToSpace(spaceNumber)
    local spaceName = "Desktop " .. spaceNumber
    log.i("Attempting to move window to " .. spaceName)
    local focusedWindow = hs.window.focusedWindow()
    if focusedWindow then
        moveWindowToSpace(focusedWindow, spaceNumber)
    else
        log.w("No focused window")
        hs.alert.show("No focused window")
    end
end

function centerWindow()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    f.x = max.x + ( max.w ) * 0.05
    f.y = max.y + ( max.h ) * 0.05
    f.w = max.w * 0.9
    f.h = max.h * 0.9
--    print(max)
--    print(f)
    win:setFrame(f)
end

-- TODO: cmd and alt are reversed?
-- Bind keys cmd + shift + 0-9
-- for i = 0, 9 do
--     hs.hotkey.bind({ "alt", "shift" }, tostring(i), function()
--         log.i("Hotkey pressed: cmd + shift + " .. i)
--         if i == 0 then
--             moveFocusedWindowToSpace(10)
--         else
--             moveFocusedWindowToSpace(i)
--         end
--     end)
-- end
-- -- Bind keys alt + shift + 1-6
-- for i = 1, 6 do
--     hs.hotkey.bind({ "cmd", "shift" }, tostring(i), function()
--         log.i("Hotkey pressed: alt + shift + " .. i)
--         moveFocusedWindowToSpace(i + 10)
--     end)
-- end
