local gears = require("gears")
local awful = require("awful")
local chart = require('gui.indicators.charts')
local helpers = require 'helpers'
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local disk1 = chart.bar('', ' ', '', 100)
local disk2 = chart.bar('', ' ', '', 100)

local disk = helpers.apply_margin({
    {
        helpers.apply_margin({
            id="chart_init",
            markup = '<span size="medium"> Disk</span>',
            widget = wibox.widget.textbox,
            align = 'center',
            valign = 'center',
        }, nil, dpi(10),dpi(10), nil, nil),
        helpers.apply_margin(disk1, nil, dpi(10), dpi(10), dpi(10), dpi(10)),
        helpers.apply_margin(disk2, nil, nil, dpi(0), dpi(10), dpi(10)),
        layout = wibox.layout.align.vertical,
    },
    bg = beautiful.bg_lighter,
    widget = wibox.container.background,
}, nil, dpi(10),dpi(10),dpi(10),dpi(10))

awesome.connect_signal('resource::disk', function(usage)
    local sg1 = helpers.split(usage[1], "|")
    disk1:get_children_by_id('chart')[1].value = sg1[2] / 100
    disk1:get_children_by_id('chart_end')[1].markup = ' '..string.format("%0.1fG", sg1[2]).." "..string.format("%0.0f", sg1[3])
    disk1:get_children_by_id('chart_init')[1].markup = zhelpers.trim(sg1[1])..'linux'

    local sg2 = helpers.split(usage[3], "|")
    disk2:get_children_by_id('chart')[1].value = sg2[2] / 100
    disk2:get_children_by_id('chart_end')[1].markup = ' '..string.format("%0.1fG", sg2[2]).." "..string.format("%0.0f", sg2[3])
    disk2:get_children_by_id('chart_init')[1].markup = ' '..helpers.trim(sg2[1])
end
)


return disk