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
   local f = io.open("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq")
   local freq = tonumber(f:read())
   f:close()

   return math.floor(freq / 100000) / 10
end

-- vim: set ts=3 sw=3 et :
