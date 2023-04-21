local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty") 
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require 'helpers'
local emitter = require 'events.emitter'

local get_mute_cmd = function (device) return "pactl list sinks | grep -i 'Mute: ' | sed -n '" .. tostring(device+1) .. " p' | awk '{print $2}'" end
local set_mute_cmd = function (device, value) return "pactl set-sink-mute " .. device .. " " .. value end

local volume = {}

volume.slider = wibox.widget {
    id = "volume_slider",
    bar_shape = gears.shape.rounded_bar,
    bar_height = 3,
    bar_active_color = beautiful.blue,
    bar_color = beautiful.black,
    handle_color = beautiful.blue,
    handle_shape = gears.shape.circle,
    handle_width = 5,
    handle_border_width = 1,
    value = 40,
    forced_width = 380,
    forced_height = 10,
    widget = wibox.widget.slider
}

volume.mute = wibox.widget {
    widget = wibox.widget.textbox,
    markup = '<span size="large"> </span>',
}

---======================---
--|        Volume        |--
---======================---

-- emit current value
emitter.volume.set(0)

-- set value when slider change
volume.slider:connect_signal('property::value', function (_, value)
    emitter.volume.set(0, value)
end)
-- change slider value
awesome.connect_signal('volume::change', function (value)
    local segments = helpers.split(value, "|")
    volume.slider:get_children_by_id('volume_slider')[1].value = segments[2]+0
end)

---======================---
--|         Mute         |--
---======================---

-- emit current value
emitter.mute.set(0)

-- set value when button is clicked
volume.mute:connect_signal('button::press', function (_, value)
    emitter.mute.toggle(0)
end)
-- change slider value
awesome.connect_signal('mute::change', function (value)
    local segments = helpers.split(value, "|")
    if(segments[2] == "1") then
        volume.mute.markup = '<span size="large">婢 </span>'
    else
        volume.mute.markup = '<span size="large"> </span>'
    end
end)


return volume
