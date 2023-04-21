local gears = require("gears")
local awful = require("awful")
local chart = require('gui.indicators.charts')
local helpers = require 'helpers'
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

function get_cmd(diskname)
    return "df --output=pcent "..diskname.." | tail -n 1 | sed 's/%//g' | xargs"
end

function get_used(diskname)
    --return "echo $(printf '%0.1f' $(df "..diskname.." | tail -n 1 | awk '{print $3/10^6}'))/$(printf '%0.1fG' $(df "..diskname.." | tail -n 1 | awk '{print $2/10^6}'))"
    return "echo $(printf '%0.1f G' $(df "..diskname.." | tail -n 1 | awk '{print $3/10^6}'))"
end


local disk1 = chart.bar('', 'linux ', '', 305)
local disk2 = chart.bar('', ' home ', '', 305)

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

gears.timer {
    timeout = 10,
    call_now = true,
    autostart = true,
    callback = function ()
        -- disk 1
        awful.spawn.easy_async_with_shell(get_cmd("/"), function (used)
            disk1:get_children_by_id('chart')[1].value = used / 100
        end)
        -- disk 1
        awful.spawn.easy_async_with_shell(get_used("/"), function (used)
            disk1:get_children_by_id('chart_end')[1].markup = ' '..helpers.trim(used)
        end)
        -- disk 2        
        awful.spawn.easy_async_with_shell(get_cmd("/home"), function (used)
            disk2:get_children_by_id('chart')[1].value = used / 100
        end)
        -- disk 2        
        awful.spawn.easy_async_with_shell(get_used("/home"), function (used)
            disk2:get_children_by_id('chart_end')[1].markup = ' '..helpers.trim(used)
        end)
    end
}


return disk