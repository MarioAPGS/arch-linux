local awful = require("awful")
local wibox = require("wibox") -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local dpi = beautiful.xresources.apply_dpi

local clock_formats = {
    hour = '%H:%M',
    day = '%d/%m/%Y',
    both = "%H:%M %d/%m/%Y"
}

local clock = wibox.widget {
    format = clock_formats.both,
    widget = wibox.widget.textclock,
}

local datetime = wibox.widget {
    {
        clock,
        fg = beautiful.blue,
        widget = wibox.container.background,
    },
    margins = dpi(7),
    widget = wibox.container.margin,
}

datetime:connect_signal('mouse::enter', function ()
    awesome.emit_signal('calendar::visibility', true)
end)

datetime:connect_signal('mouse::leave', function ()
    awesome.emit_signal('calendar::visibility', false)
end)

datetime:add_button(awful.button({}, 1, function ()
    if (clock.format == clock_formats.hour) then
        clock.format = clock_formats.day

    elseif(clock.format == clock_formats.day) then
        clock.format = clock_formats.both
    
    elseif (clock.format == clock_formats.both) then
        clock.format = clock_formats.hour
    end
end))

return datetime