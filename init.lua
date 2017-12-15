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
   cpufreq = require("meticulous.cpufreq"),
   cpu = require("meticulous.cpu"),
   volume = require("meticulous.volume"),
   sensors = require("meticulous.sensors"),
   net = require("meticulous.net"),
   mem = require("meticulous.mem"),
   weather = require("meticulous.weather")
}

return meticulous

