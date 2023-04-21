local gears = require("gears")
local awful = require("awful")
local chart = require('gui.indicators.charts')
local naughty = require("naughty") 
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require 'helpers'

local network_base1 = wibox.widget {
    helpers.apply_margin({
        id="chart_init",
        markup = '<span size="medium"> Net</span>',
        widget = wibox.widget.textbox,
        align = 'center',
        valign = 'center',
    }, nil, dpi(10), dpi(10), nil, nil),
    {
        id="download",
        markup = label, --helpers.get_colorized_markup(label, beautiful.light_black),
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
    },
    {
        id="upload",
        markup = label, --helpers.get_colorized_markup(label, beautiful.light_black),
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
    },
    
    layout = wibox.layout.align.vertical,
}


-- helpers.apply_margin({
--    markup = '<span size="medium"> Net</span>',
--    widget = wibox.widget.textbox,
--}, nil, dpi(10), dpi(10), dpi(10), dpi(10)),

local network = helpers.apply_margin({
    {
        {
            id = "label",
            markup = label,
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
        },
        top = dpi(10),
        bottom = dpi(10),
        widget = wibox.container.margin,
    },
    bg = beautiful.bg_lighter,
    widget = wibox.container.background,
    
}, nil, dpi(10),dpi(10),dpi(10),dpi(10))

awesome.connect_signal('resource::net', function (usage)
    if(usage[1] == nil or string.len(usage[1]) <= 0) then
        usage[1] = 0
    end
    if(usage[2] == nil or string.len(usage[2]) <= 0) then
        usage[2] = 0
    end
    network.value = used
    network:get_children_by_id('label')[1].markup = '<span size="medium">  '..helpers.trim(tostring(usage[1]))..'</span><span size="medium">  '..helpers.trim(tostring(usage[2]))..'</span>'
end)



return network