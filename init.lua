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

local meticulous = {
   battery = require("meticulous.battery"),
   cpu = require("meticulous.cpu"),
   cpufreq = require("meticulous.cpufreq"),
   mem = require("meticulous.mem"),
   net = require("meticulous.net"),
   sensors = require("meticulous.sensors"),
   volume = require("meticulous.volume"),
   weather = require("meticulous.weather")
}

return meticulous

