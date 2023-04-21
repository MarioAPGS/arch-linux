local gears = require("gears")
local awful = require("awful")
local chart = require('gui.indicators.charts')
local naughty = require("naughty") 
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require 'helpers'

local battery = helpers.apply_margin({
    id="battery",
    markup = '0%',
    widget = wibox.widget.textbox,
    fg = beautiful.blue,
    align = "center",
    valign = "center",
}, nil, dpi(10),dpi(10),dpi(10),dpi(10))

awesome.connect_signal('resource::bat', function (used)
    battery:get_children_by_id('battery')[1].markup = '<span size="medium">'.. used[1]..'%</span>'
end)


return battery