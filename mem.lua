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
   for line in io.lines("/proc/meminfo") do
      for label, value in string.gmatch(line, "(%a+):%s+(%d+)") do
         if label == "MemTotal" then
            total = math.floor(value / 1024)
         elseif label == "MemFree" then
            free = math.floor(value / 1024)
         elseif label == "Buffers" then
            buffers = math.floor(value / 1024)
         elseif label == "Cached" then
            cached = math.floor(value / 1024)
         else
            -- Nothing left to read, exit the loop
            break
         end
      end
   end

   return {
      total = total,
      used = total - (free + buffers + cached),
      usage = (total - (free + buffers + cached)) / total
   }
end

