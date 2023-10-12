local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require 'helpers'
local gears = require("gears")
local naughty = require("naughty")
local frame = require('frame')
local dpi = beautiful.xresources.apply_dpi

require "events.resource"
local ram = require("gui.indicators.ram")
local cpu = require("gui.indicators.cpu")
local disk = require("gui.indicators.disk")
local temperature = require("gui.indicators.temperature")
local network = require("gui.indicators.network")
local volume = require("gui.indicators.volume")
local battery = require("gui.indicators.battery")
local power = require("gui.power")
--local music = require('gui.music-player')


local username = helpers.apply_margin({
    id="username",
    markup = 'loading...',
    widget = wibox.widget.textbox,
    fg = beautiful.blue,
}, nil, dpi(10),dpi(10),dpi(10),dpi(10))

awful.spawn.easy_async_with_shell('whoami', function (whoami)
    username:get_children_by_id('username')[1].markup = '<span size="xx-large">'.. helpers.capitalize(helpers.trim(whoami))..'</span>'
end)

local cal = wibox.widget.calendar.month(os.date('*t'))
local function mkwidget()
    return wibox.widget {
        {
            username,
            battery,
            {
                {
                    helpers.apply_margin(power.leave,nil, dpi(10),dpi(10),dpi(10),dpi(10)),
                    layout = wibox.layout.align.horizontal,
                    widget = wibox.container.background,
                },
                {
                    helpers.mkbtn(power.suspend,nil, dpi(10),dpi(10),dpi(10),dpi(10)),
                    helpers.mkbtn(power.reboot,nil, dpi(10),dpi(10),dpi(10),dpi(10)),
                    helpers.mkbtn(power.shutdown,nil, dpi(10),dpi(10),dpi(10),dpi(10)),
                    widget = wibox.container.background,
                    layout = wibox.layout.align.horizontal,

                },
                layout = wibox.layout.align.horizontal,
            },
            layout = wibox.layout.align.horizontal,
        },
        {
            helpers.apply_margin(volume.mute,nil, dpi(10),dpi(10),dpi(5),dpi(10)),
            helpers.apply_margin(volume.slider,nil, dpi(10),dpi(10),dpi(10),dpi(5)),
            widget = wibox.container.background,
            layout = wibox.layout.align.horizontal,
        },
        {
            {
                network,
                widget = wibox.container.background,
                layout = wibox.layout.align.vertical,
            },
            {
                cpu,
                ram,
                temperature,
                bg = beautiful.bg_lighter,
                layout = wibox.layout.align.horizontal,
            },
            {
                disk,
                widget = wibox.container.background,
                layout = wibox.layout.align.vertical,
            },
            layout = wibox.layout.align.vertical,
            
        },
        {
            {
                --music,
                widget = wibox.container.background,
                layout = wibox.layout.align.vertical,
            },
            layout = wibox.layout.align.vertical,
            
        },
        layout = wibox.layout.align.vertical,
        shape = helpers.mkroundedrect(),
    }
end


frame.build('dashboard',
 mkwidget(),
 function (d)
    return awful.placement.bottom(d, {
        margins = {
            bottom = beautiful.bar_height + beautiful.useless_gap * 2,
        },
    })
end)
