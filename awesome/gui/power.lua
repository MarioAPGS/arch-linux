local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local powerbutton = {}

powerbutton.shutdown = wibox.widget {
    {
        markup = '⏻ ',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox,
        --font = icon_font,
    },
    fg = beautiful.red,
    widget = wibox.container.background,
}
powerbutton.shutdown:connect_signal('button::press', function (_, value)
    awful.spawn.with_shell('systemctl poweroff')
end)

powerbutton.reboot = wibox.widget {
    {
        markup = '勒 ',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox,
        --font = icon_font,
    },
    fg = beautiful.blue,
    widget = wibox.container.background
}
powerbutton.reboot:connect_signal('button::press', function (_, value)
    awful.spawn.with_shell('systemctl reboot')
end)

powerbutton.leave = wibox.widget {
    {
        markup = ' ',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox,
        --font = icon_font,
    },
    fg = beautiful.green,
    widget = wibox.container.background,
}
powerbutton.leave:connect_signal('button::press', function (_, value)
    awful.spawn.with_shell('pkill awesome')
    --awesome.quit
end)

powerbutton.suspend = wibox.widget {
    {
        markup = 'Z',
        align = 'center',
        valign = 'center',
        widget = wibox.widget.textbox,
        --font = icon_font,
    },
    fg = beautiful.blue,
    widget = wibox.container.background,
}
powerbutton.suspend:connect_signal('button::press', function (_, value)
    awful.spawn.with_shell('systemctl suspend')
end)

return powerbutton