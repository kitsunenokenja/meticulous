--[[
-- Meticulous, simple widget library for AwesomeWM
--
-- This file belongs to Meticulous, an open-source project distributed under
-- the GPL license. This license is included as part of the project and is
-- also available at the following web page:
--
-- http://www.gnu.org/licenses/gpl.html
--
-- Copyright (c) 2017
]]--

return function(args)
   args = args or {card = nil}
   if args["card"] == nil then
      -- Assume device 0
      args["card"] = 0
   end

   local f = io.popen("amixer -c " .. args["card"] .. " -M get Master | tail -n 1")
   local vol = string.match(f:read(), "([%d]+)%%")
   f:close()

   return tonumber(vol)
end

