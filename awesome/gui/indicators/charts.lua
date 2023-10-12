local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require 'helpers'
local gears = require("gears")

local dpi = beautiful.xresources.apply_dpi

local chart = {}

function chart.bar (label, inittext, endtext, width, max_value)
    if max_value == nil then
        max_value = 1
    end
    return wibox.widget {
        {
            id="chart_init",
            markup = inittext, --helpers.get_colorized_markup(label, beautiful.light_black),
            widget = wibox.widget.textbox,
            align = 'center',
            valign = 'center',
        },
        {
            {
                id = 'chart',
                max_value     = max_value,
                value         = 0,
                forced_height = dpi(5),
                forced_width  = width,
                shape         = gears.shape.rounded_bar,
                border_color  = beautiful.border_color,
                widget        = wibox.widget.progressbar,
                background_color = beautiful.dimblack,
                color = beautiful.blue, 
            },
            {
                id="chart_label",
                text   = label,
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.stack
        },
        {
            id="chart_end",
            markup = endtext, --helpers.get_colorized_markup(label, beautiful.light_black),
            widget = wibox.widget.textbox,
            align = 'center',
            valign = 'center',
        },
        layout = wibox.layout.align.horizontal,
        widget = wibox.container.margin,
    }
end

function chart.circle (icon, label)
    return wibox.widget {
        {
            {
                {
                    id="chart_label",
                    markup = '<span size="medium">'..label..'</span>', --helpers.get_colorized_markup(label, beautiful.light_black),
                    widget = wibox.widget.textbox,
                    align = 'center',
                    valign = 'center',
                },
                {
                    {
                        {
                            {
                                {
                                    {
                                        id = 'chart_icon',
                                        text = icon,
                                        font = beautiful.nerd_font .. '',
                                        align = "center",
                                        valign = "center",
                                        widget = wibox.widget.textbox,
                                    },
                                    direction = 'south',
                                    widget = wibox.container.rotate,
                                },
                                bottom = dpi(18),
                                widget = wibox.container.margin,
                            },
                            id = 'chart',
                            value = 0,
                            max_value = 1,
                            min_value = 0,
                            widget = wibox.container.radialprogressbar,
                            border_color = beautiful.dimblack,
                            color = beautiful.blue,
                            border_width = dpi(10),
                            forced_height = dpi(70),
                            forced_width = dpi(70),
                        },
                        direction = 'south',
                        widget = wibox.container.rotate,
                        set_chart_value = function (self, value)
                            self:get_children_by_id('chart')[1].value = value
                        end,
                    },
                    left = dpi(20),
                    right = dpi(20),
                    bottom = dpi(8),
                    widget = wibox.container.margin,
                },
                nil,
                layout = wibox.layout.align.vertical,
            },
            margins = dpi(7),
            widget = wibox.container.margin,
        },
        shape = helpers.mkroundedrect(),
        bg = beautiful.bg_contrast,
        widget = wibox.container.background,
    }
end

return chart