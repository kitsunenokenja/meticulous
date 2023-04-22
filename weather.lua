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

local value = nil

return function(args)
   if args["lat"] == nil or args["lon"] == nil then
      return nil
   end

   local awful = require("awful")
   local url = "https://api.met.no/weatherapi/locationforecast/2.0/classic"
   local flag = false

   local cmd = "curl -m 8 -s '" .. url .. "/?lat=" .. args["lat"] ..
      "&lon=" .. args["lon"] .. "'" ..  " -H 'User-Agent: Firefox'"
   awful.spawn.with_line_callback(cmd, {
      stdout = function(line)
         if flag then
            return
         end
         if string.match(line, "temperature") ~= nil then
            value = tonumber(string.match(line, "value=\"(.+)\""))
            flag = true
         end
      end
   })

   if value == nil then
      return "N/A"
   else
      return value
   end
end

-- vim: set ts=3 sw=3 et :
