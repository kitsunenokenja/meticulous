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
   local current = 0
   local total = 1

   for line in io.lines("/sys/class/power_supply/BAT0/uevent") do
      for label, value in string.gmatch(line, "POWER_SUPPLY_(.+)=(.+)") do
         if label == "CHARGE_NOW" then
            current = tonumber(value)
         elseif label == "CHARGE_FULL" then
            total = tonumber(value)
         elseif label == "PRESENT" then
            supply = value
         end
      end
   end

   return {
      level = current / total * 100,
      supply = supply
   }
end

-- vim: set ts=3 sw=3 et :
