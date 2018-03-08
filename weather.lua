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
   if args["lat"] == nil or args["lon"] == nil then
      return nil
   end
   local url = "https://api.met.no/weatherapi/locationforecast/1.9"

   local f = io.popen(
      "curl -s '" .. url .. "/?lat=" .. args["lat"] ..
      "&lon=" .. args["lon"] .. "'"
   )
   for line in f:lines() do
      if string.match(line, "temperature") ~= nil then
         f:close()
         return tonumber(string.match(line, "value=\"(.+)\""))
      end
   end
   return "N/A"
end

