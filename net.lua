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

local devices = {}

return function(args)
   args = args or {interface = nil}
   if args["interface"] == nil then
      return nil
   end
   local net = args["interface"]

   if devices[args["interface"]] == nil then
      devices[net] = {
         last_down = nil,
         last_up = nil,
         down = 0,
         up = 0
      }
   end

   local f = io.popen("cat /proc/net/dev | grep " .. args["interface"])
   local line = f:read()
   f:close()

   local down = tonumber(string.match(line, ":%s+(%d+)"))
   local up = tonumber(string.match(line, "(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d$"))

   if devices[net]["last_down"] == nil then
      devices[net]["last_down"] = down
      devices[net]["last_up"] = up
      devices[net]["down"] = 0
      devices[net]["up"] = 0
   else
      devices[net]["down"] = down - devices[net]["last_down"]
      devices[net]["up"] = up - devices[net]["last_up"]
      devices[net]["last_down"] = down
      devices[net]["last_up"] = up
   end

   return devices[net]
end

-- vim: set ts=3 sw=3 et :
