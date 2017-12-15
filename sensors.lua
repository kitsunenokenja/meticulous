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

return function()
   local f = io.popen("sensors | egrep '(Core|fan)'")
   local sensors = {
      temp = {},
      fans = {}
   }

   for line in f:lines() do
      if string.match(line, "Core") ~= nil then
         table.insert(sensors["temp"], tonumber(string.match(line, "+(%d+)\.")))
      else
         table.insert(sensors["fans"], tonumber(string.match(line, " (%d+) RPM")))
      end
   end
   f:close()

   return sensors
end

