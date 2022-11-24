hs.spaces.setDefaultMCwaitTime(0.3)
debugMode = false

function adjustSpaceCount(screen, target, spaces)
  local lenSpaces = #spaces[screen]
  local spacesChanges = lenSpaces - target
  if spacesChanges > 0 then
    hs.spaces.gotoSpace(spaces[screen][1])
    hs.spaces.closeMissionControl()
    for i=0,spacesChanges-1 do
      print(i)
      print(lenSpaces-i)
      print(spaces[screen][lenSpaces-i])
      hs.spaces.removeSpace(spaces[screen][lenSpaces-i], true)
    end
  else if spacesChanges < 0 then
    for _=spacesChanges,1 do
      hs.spaces.addSpaceToScreen(screen, true)
    end
  end end
  hs.spaces.closeMissionControl()
end

function adjustScreen()
  -- Front screen by relative coordinate
  local main_screen = hs.screen.find("-1 -1")
  -- Right screen by relative coordinate
  local secondary_screen = hs.screen.find("0 -1")
  -- Mac screen by relative coordinate
  local builtin_screen = hs.screen.find("0 0")
  if main_screen == nil then
    print("main_screen")
    return
  end
  if secondary_screen == nil then
    print("secondary_screen")
    return
  end
  if builtin_screen == nil then
    print("builtin_screen")
    return
  end

  local spaces = hs.spaces.allSpaces()
  adjustSpaceCount(main_screen:getUUID(), 2, spaces)
  adjustSpaceCount(secondary_screen:getUUID(), 8, spaces)
  adjustSpaceCount(builtin_screen:getUUID(), 5, spaces)
end

function moveWindows()
  execTaskInShellSync("/Users/emmanueltran/bin/restoreWorkspaces.sh")
end

function screenWatcher()
  adjustScreen()
  moveWindows()
end

function onWakeUp(eventType)
  if eventType == hs.caffeine.watcher.screensDidUnlock then
    moveWindows()
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
        if not coroutine.isyieldable() then
            print("this function cannot be invoked on the main Lua thread")
        end

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

        while done == false do
            coroutine.applicationYield()
        end

        return out
    end

    return function(cmdWithArgs, callback, withEnv)
        if pathEnv == "" then
          pathEnv = "/opt/homebrew/bin:/Users/emmanueltran/bin"
        end
        return fn(cmdWithArgs, callback, withEnv)
    end
end)()

watcher = hs.screen.watcher.new(screenWatcher)
wakeWatcher = hs.caffeinate.watcher.new(onWakeUp)

watcher:start()
wakeWatcher:start()
