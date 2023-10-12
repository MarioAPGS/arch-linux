local gears = require("gears")
local awful = require("awful")
local chart = require('gui.indicators.charts')
local naughty = require("naughty") 
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require 'helpers'
local fs = gears.filesystem

local temp_base = chart.circle('', ' Temp\n', nil, nil, 1)
local temperature = helpers.apply_margin({
    temp_base,
    bg = beautiful.bg_lighter,
    widget = wibox.container.background,
}, nil, dpi(10),dpi(10),dpi(10),dpi(10)),

awesome.connect_signal('resource::temp', function (temp)
    -- change color
    if (temp/100) <= 0.50 then
        temp_base:get_children_by_id('chart')[1].color = beautiful.green
    elseif (temp/100) > 0.50 and (temp/100) < 0.85 then
        temp_base:get_children_by_id('chart')[1].color = beautiful.blue
    else
        temp_base:get_children_by_id('chart')[1].color = beautiful.red
    end
    temp_base:get_children_by_id('chart_icon')[1].text = helpers.split(tostring(temp), ".")[1].."º\n"
    temp_base:get_children_by_id('chart')[1].value = (temp/100)
end)

return temperature