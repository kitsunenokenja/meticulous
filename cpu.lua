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

local cores = {}

return function()
   local f = io.popen("cat /proc/stat | grep cpu")
   local i = 1
   local j = 1
   local v

   -- Skip summary line
   f:read()

   for line in f:lines() do
      local core = cores[i] or {}

      -- Read stats user, nice, system, idle, iowait, irq, softirq
      line = string.match(line, " %d+ %d+ %d+ %d+ %d+ %d+ %d+")

      -- "Split" the line
      for v in string.gmatch(line, "%s+(%d+)") do
         core[j] = tonumber(v)
         j = j + 1
      end
      cores[i] = core
      i = i + 1
      j = 1
   end
   f:close()

   for i = 1, #cores do
      -- used = user + nice + system + irq + softirq
      local used = cores[i][1] + cores[i][2] + cores[i][3] + cores[i][6] + cores[i][7]
      -- total = used + idle + iowait
      local total = used + cores[i][4] + cores[i][5]

      if(cores[i]["usage"] == nil or (total - cores[i]["total"]) == 0) then
         cores[i]["usage"] = 0
      else
         cores[i]["usage"] = 100 * (used - cores[i]["used"]) / (total - cores[i]["total"])
      end

      cores[i]["used"] = used
      cores[i]["total"] = total
   end

   return cores
end

