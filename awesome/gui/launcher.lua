local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local helpers = require 'helpers'
local dpi = beautiful.xresources.apply_dpi

---======================---
--|         Old          |--
---======================---

myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", "kitty -e man awesome" },
    { "edit config", "kitty -e code " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
 }
 
mymainmenu = awful.menu({items = {
        { "awesome", myawesomemenu, beautiful.launcher_icon },
        { "open terminal", terminal }
    }})

local launcher = helpers.mkbtn({
    image = beautiful.launcher_icon,
    forced_height = dpi(16),
    forced_width = dpi(16),
    halign = 'center',
    valign = 'center',
    widget = wibox.widget.imagebox,
    
}, beautiful.black, beautiful.dimblack)

mylauncher = awful.widget.launcher({ image = beautiful.launcher_icon, forced_height = dpi(6), forced_width = dpi(6), menu = mymainmenu })

---======================---
--|         Menu         |--
---======================---

local function set_launcher(s)

    local settings_button = helpers.mkbtn({
        widget = wibox.widget.imagebox,
        image = beautiful.menu_icon,
        forced_height = dpi(16),
        forced_width = dpi(16),
        halign = 'center',
    }, beautiful.black, beautiful.dimblack)

    local settings_tooltip = helpers.make_popup_tooltip('Toggle dashboard', function (d)
        return awful.placement.top_left(d, {
            margins = {
                top = beautiful.bar_height + beautiful.useless_gap * 2,
                left = beautiful.useless_gap * 2,
            }
        })
    end)

    settings_tooltip.attach_to_object(settings_button)

        settings_button:add_button(awful.button({}, 1, function ()
            --require 'ui.dashboard'
            awesome.emit_signal('dashboard::toggle')
        end))

    return settings_button
end


return set_launcher