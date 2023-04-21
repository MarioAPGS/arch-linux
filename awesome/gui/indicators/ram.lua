local chart = require('gui.indicators.charts')
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require 'helpers'

local ram_base = chart.circle('RAM', ' RAM\n')

local ram = helpers.apply_margin({
    ram_base,
    bg = beautiful.bg_lighter,
    widget = wibox.container.background,
}, nil, dpi(10),dpi(10),dpi(10),dpi(10))

awesome.connect_signal('resource::ram', function (usage)
    -- change color
    if usage[2]/100 <= 0.20 then
        ram_base:get_children_by_id('chart')[1].color = beautiful.green
    elseif usage[2]/100 > 0.20 and usage[2]/100 < 0.80 then
        ram_base:get_children_by_id('chart')[1].color = beautiful.blue
    else
        ram_base:get_children_by_id('chart')[1].color = beautiful.red
    end
    
    -- set chart value and usage in Gb
    ram_base:get_children_by_id('chart')[1].value = usage[2] / 100
    ram_base:get_children_by_id('chart_icon')[1].text = helpers.trim(usage[1]) .. "G\n"
end)


return ram