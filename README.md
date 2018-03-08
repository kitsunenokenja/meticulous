# meticulous
Simple resource monitoring library for
[AwesomeWM](https://github.com/awesomeWM/awesome)

This library was originally written as an exercise to recreate the monitoring
tools available in XFCE after having migrated to Awesome. These are very simple
and easy to read, useful for new Awesome users particularly not familiar with
Lua yet. This outline will describe how to use meticulous with examples of
Awesome widgets consuming the data from this library.

Note: at this time the latest release of AwesomeWM is 4.2; in this version the
call_now property for `gears.timer` was not yet available. Upgrade to the latest
developer version from the project repo or remove call_now if using the example
widgets.

Note: most of these monitors depend on information provided by the kernel, and
everything is tailored to the Linux kernel. Most of these will probably not work
on a BSD system.

In `rc.lua`, simply add:

```lua
local meticulous = require("meticulous")
```

## cpufreq
CPU frequency monitor. Useful for CPUs with frequency scaling. This monitor
simply returns a number, so the example widget is just a text box that displays
the frequency in GHz every two seconds.

```lua
cpufreqwidget = wibox.widget.textbox()
gears.timer {
   timeout = 2,
   autostart = true,
   call_now = true,
   callback = function()
      cpufreqwidget.text = meticulous.cpufreq() .. "GHz"
   end
}
```

## cpu
CPU core load monitor. This library accounts for the number of cores on its own,
but it will only read the first CPU on a system with multiple physical CPUs. A
table of load percentages will be returned for each core. With this, an
XFCE-style load monitor can be built as vertical progressbars, one for each
core.

Below is an example of displaying 4 vertical progressbars to represent the
CPU load, being updated at regular intervals. A tooltip is also included to
display the 4 percentages in numeric form.

```lua
cpu0widget = wibox.widget.progressbar()
cpu0widget.color = "#0000dd"
cpu0widget.background_color = beautiful.bg_minimize
cpu1widget = wibox.widget.progressbar()
cpu1widget.color = "#0000dd"
cpu1widget.background_color = beautiful.bg_minimize
cpu2widget = wibox.widget.progressbar()
cpu2widget.color = "#0000dd"
cpu2widget.background_color = beautiful.bg_minimize
cpu3widget = wibox.widget.progressbar()
cpu3widget.color = "#0000dd"
cpu3widget.background_color = beautiful.bg_minimize
cpuwidget_container = wibox.widget {
   {
      {
         widget = cpu0widget,
	      id = "mypb0",
	      min_value = 0,
	      max_value = 100
      },
      {
         widget = cpu1widget,
	      id = "mypb1",
	      min_value = 0,
	      max_value = 100
      },
      {
         widget = cpu2widget,
	      id = "mypb2",
	      min_value = 0,
	      max_value = 100
      },
      {
         widget = cpu3widget,
	      id = "mypb3",
	      min_value = 0,
	      max_value = 100
      },
      layout = wibox.layout.flex.vertical,
      id = "cpus"
   },
   direction = "east",
   forced_width = 20,
   layout = wibox.container.rotate,
   get_cores = function()
      return cores
   end,
   set_cores = function(self, val)
      self.cpus.mypb0.value = val[1]["usage"]
      self.cpus.mypb1.value = val[2]["usage"]
      self.cpus.mypb2.value = val[3]["usage"]
      self.cpus.mypb3.value = val[4]["usage"]
      self.cores = val
   end
}
cpuwidget_container_t = awful.tooltip({
   objects = {cpuwidget_container},
   timer_function = function()
      cores = cpuwidget_container:get_cores()
      return math.floor(cores[1]["usage"] + 0.5) .. "% " ..
         math.floor(cores[2]["usage"] + 0.5) .. "% " ..
         math.floor(cores[3]["usage"] + 0.5) .. "% " ..
         math.floor(cores[4]["usage"] + 0.5) .. "%"
   end
})
gears.timer {
   timeout = 2,
   autostart = true,
   callback = function()
      cores = meticulous.cpu()
      cpuwidget_container.cores = cores
   end
}
```

## thermal
CPU temperature monitor. Reports on the current temperature of every core on the
first physical CPU.

The following example builds a 2x2 grid for a 4-core CPU showing the
temperatures and updating their values regularly. It also includes a tooltip
that will display a readout of all system fan speeds.

```lua
thermal0 = wibox.widget.textbox("0°")
thermal0.font = "M+ 2c 8"
thermal1 = wibox.widget.textbox("0°")
thermal1.font = "M+ 2c 8"
thermal2 = wibox.widget.textbox("0°")
thermal2.font = "M+ 2c 8"
thermal3 = wibox.widget.textbox("0°")
thermal3.font = "M+ 2c 8"
thermalwidget = wibox.widget {
   thermal0,
   thermal1,
   thermal2,
   thermal3,
   forced_num_cols = 2,
   forced_num_rows = 2,
   homogenous = true,
   expand = true,
   layout = wibox.layout.grid
}
thermalwidget_t = awful.tooltip({
   objects = {thermalwidget},
   timer_function = function()
      local s = meticulous.sensors()
      local line = ""
      for i = 1, #s["fans"] do
         line = line .. " " .. s["fans"][i] .. "RPM"
      end
      return line
   end
})
gears.timer {
   timeout = 2,
   autostart = true,
   call_now = true,
   callback = function()
      local s = meticulous.sensors()
      thermal0.text = s["temp"][1] .. "°"
      thermal1.text = s["temp"][2] .. "°"
      thermal2.text = s["temp"][3] .. "°"
      thermal3.text = s["temp"][4] .. "°"
   end
}
```

## memory
Memory utilisation monitor. This simple library will report on the current usage
and total available memory.

This example will construct an analogue vertical gauge to represent the current
usage, and includes a tooltip to show the numeric amount against the total
amount available.

```lua
memorywidget = wibox.widget.progressbar()
memorywidget.color = "#00aa00"
memorywidget.background_color = beautiful.bg_minimize
memorywidget_container = {
   {
      {
         widget = memorywidget,
      },
      layout = wibox.layout.flex.vertical
   },
   direction = "east",
   forced_width = 5,
   widget = wibox.container.rotate
}
memorywidget_t = awful.tooltip({
   objects = {memorywidget},
   timer_function = function()
      local m = meticulous.mem()
      return m["used"] .. "MiB / " .. m["total"] .. "MiB"
   end
})
gears.timer {
   timeout = 3,
   autostart = true,
   call_now = true,
   callback = function()
      local m = meticulous.mem()
      memorywidget.value = m["usage"]
   end
}
```

## volume
Volume setting monitor. Reports on the percentage set within ALSA for a
specified device, defaulting to Master on device 0.

The following example demonstrates a margin-padded text box to display the
volume value.

```lua
volumewidget = wibox.widget.textbox(meticulous.volume() .. "%")
volumecontainer = {
   {
      widget = volumewidget
   },
   left = 3,
   layout = wibox.container.margin
}
```

To select Master on a device other than card 0, pass in a table specifying a
card like so:

```lua
meticulous.volume({card = 1})
```

Assuming the card is 0, this additional example shows the keybinding definition
to `Mod+NumPad+` and `Mod+NumPad-` to control volume adjustment to the ALSA
device's master, and promptly update the volume monitor's value accordingly,
rather than poll for the volume setting value regularly.

```lua
-- Volume bindings
awful.key({ modkey }, "#" .. 86, -- NumPad +
           function()
              awful.util.spawn("amixer -c 0 set Master 1%+ > /dev/null", false)
              volumewidget.text = meticulous.volume() .. "%"
           end,
           {description = "increase master volume", group = "awesome"}),
awful.key({ modkey }, "#" .. 82, -- NumPad -
          function()
             awful.util.spawn("amixer -c 0 set Master 1%- > /dev/null", false)
             volumewidget.text = meticulous.volume() .. "%"
          end,
          {description = "decrease master volume", group = "awesome"})
```

## weather
Queries Meteorologisk Institutt for a weather forecast and parses just the
current temperature. Requires passing latitude and longitude. This is another
basic text box widget as well.
[MET Norway API](https://api.met.no/)

```lua
weatherwidget = wibox.widget.textbox()
weathercontainer = {
   {
      widget = weatherwidget
   },
   left = 3,
   layout = wibox.container.margin
}
weather_timer = gears.timer {
   timeout = 1800,
   autostart = true,
   call_now = true,
   callback = function()
      weatherwidget.text = meticulous.weather({lat = 51.5, lon = 0.1}) .. "°C"
   end
}
```

## net
Network interface monitor. Reports on the average bandwidth consumption for
upstream and downstream in bytes. Specifying the interface is required when
calling this library. 

For example, if your ethernet interface is `eth0`, pass a table to meticulous as
follows:

```lua
meticulous.net({interface = "eth0"})
```

Refer to the example below for usage, which demonstrates a vertically
stacked pair of text box widgets.

```lua
netdown = wibox.widget {
   widget = wibox.widget.textbox,
   text = "0KB/s",
   font = "M+ 2c 8",
   align = "right"
}
netup = wibox.widget {
   widget = wibox.widget.textbox,
   text = "0KB/s",
   font = "M+ 2c 8",
   align = "right"
}
netwidget = wibox.widget {
   netdown,
   netup,
   forced_num_cols = 1,
   forced_num_rows = 2,
   homogenous = true,
   expand = true,
   layout = wibox.layout.grid
}
netwidget_timer = gears.timer {
   timeout = 2,
   autostart = true,
   call_now = true,
   callback = function()
      eth = meticulous.net({interface = "enp5s0"})
      eth["down"] = math.floor(eth["down"] / 1024 + 0.5)
      eth["up"] = math.floor(eth["up"] / 1024 + 0.5)
      netdown.text = eth["down"] .. "KB/s"
      netup.text = eth["up"] .. "KB/s"
   end
}
```

