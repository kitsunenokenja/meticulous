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

return function(args)
   args = args or {airport = nil}
   if args["airport"] == nil then
      return nil
   end

   local f = io.popen("curl -s http://w1.weather.gov/xml/current_obs/" .. args["airport"] .. ".xml")
   for line in f:lines() do
      if string.match(line, "temperature_string") ~= nil then
         f:close()
         return tonumber(string.match(line, "(%d+%.?%d?) C"))
      end
   end
end

