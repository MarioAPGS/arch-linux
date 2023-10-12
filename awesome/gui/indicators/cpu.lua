local gears = require("gears")
local awful = require("awful")
local chart = require('gui.indicators.charts')
local naughty = require("naughty") 
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require 'helpers'


local cpu_base = chart.circle('', ' CPU\n')

local cpu = helpers.apply_margin({
    cpu_base,
    bg = beautiful.bg_lighter,
    widget = wibox.container.background,
}, nil, dpi(10),dpi(10),dpi(10),dpi(10))

awesome.connect_signal('resource::cpu', function (used)
    -- change color
    if (used/100) < 0.10 then
        cpu_base:get_children_by_id('chart')[1].color = beautiful.green
    elseif (used/100) > 0.10 and (used/100) < 0.60 then
        cpu_base:get_children_by_id('chart')[1].color = beautiful.blue
    else
        cpu_base:get_children_by_id('chart')[1].color = beautiful.red
    end
    cpu_base:get_children_by_id('chart')[1].value = used / 100
    cpu_base:get_children_by_id('chart_icon')[1].text = helpers.trim(tostring(used)).."%\n"
end)



return cpu