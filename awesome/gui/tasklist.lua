---@diagnostic disable: undefined-global
local awful = require 'awful'
local wibox = require 'wibox'
local beautiful = require 'beautiful'
local gears = require 'gears'
local dpi = beautiful.xresources.apply_dpi

local tasklistbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
                            if c == client.focus then
                                c.minimized = true
                            else
                                c:emit_signal(
                                    "request::activate",
                                    "tasklist",
                                    {raise = true}
                                )
                            end
                        end),
    awful.button({ }, 3, function () awful.menu.client_list({ theme = { width = 250 } }) end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

local function set_tasklist(s)
    return awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        -- sort clients by tags
        source = function()
            local ret = {}

            for _, t in ipairs(s.tags) do
                gears.table.merge(ret, t:clients())
            end

            return ret
        end,
        style = {
            shape = gears.shape.circle,
        },
        layout = {
            spacing = dpi(5),
            layout = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    margins = 2,
                    widget = wibox.container.margin,
                },
                margins = dpi(4),
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background,
            create_callback = function (self, c, _, _)
                self:connect_signal('mouse::enter', function ()
                    awesome.emit_signal('bling::task_preview::visibility', s, true, c)
                end)
                self:connect_signal('mouse::leave', function ()
                    awesome.emit_signal('bling::task_preview::visibility', s, false, c)
                end)
            end
        },
        buttons = tasklistbuttons,
    }
end

return set_tasklist 