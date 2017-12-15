--[[
-- Meticulous, simple resource monitoring library for AwesomeWM
--
-- This file belongs to Meticulous, an open-source project distributed under
-- the GPL license. This license is included as part of the project and is
-- also available at the following web page:
--
-- http://www.gnu.org/licenses/gpl.html
--
-- Copyright (c) 2017
]]--

local eth = {
   last_down = nil,
   last_up = nil,
   down = 0,
   up = 0,
}

return function(args)
   args = args or {interface = nil}
   if args["interface"] == nil then
      return nil
   end

   local f = io.popen("cat /proc/net/dev | grep " .. args["interface"])
   local line = f:read()
   f:close()

   local down = tonumber(string.match(line, ":%s+(%d+)"))
   local up = tonumber(string.match(line, "(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d$"))

   if eth["last_down"] == nil then
      eth["last_down"] = down
      eth["last_up"] = up
      eth["down"] = 0
      eth["up"] = 0
   else
      eth["down"] = down - eth["last_down"]
      eth["up"] = up - eth["last_up"]
      eth["last_down"] = down
      eth["last_up"] = up
   end

   return eth
end

