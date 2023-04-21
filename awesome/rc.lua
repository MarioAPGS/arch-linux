pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox") -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local naughty = require("naughty") -- Notification library
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local helpers = require 'helpers'
require("awful.hotkeys_popup.keys")


local dpi = beautiful.xresources.apply_dpi
local set_wallpaper = require('gui.wallpaper')

---======================---
--|        Errors        |--
---======================---

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

--naughty.notify({ preset = naughty.config.presets.info, title = "Log", text = tostring(gears.filesystem.get_themes_dir() .. "default/theme.lua") })

---======================---
--|         Init         |--
---======================---

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
beautiful.get().wallpaper = "/home/dxt0r/.wallpapers/aot.png"


-- This is used later as the default terminal and editor to run.
terminal = "kitty"
modkey = "Mod4"


-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.floating
}

---======================---
--|         Wibar        |--
---======================---

-- {{{ Wibar
local get_launcher = require("gui.launcher")
local get_taglist = require('gui.taglist')
local get_tasklist = require('gui.tasklist')
local get_layoutbutton = require('gui.layoutbutton')
local datetime = require('gui.indicators.datetime')
local mykeyboardlayout = awful.widget.keyboardlayout() -- Keyboard map indicator and switcher
local dashboard = require('gui.dashboard')

local power = require("gui.power")

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    -- Each screen has its own tag table.
    local names = { "1", "2", "3", "4"}
    awful.tag(names, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    
    -- Create the wibox
    s.mywibox = awful.wibar( {
        position = "top", 
        border_width = 10,
        screen = s, 
        height = beautiful.bar_height,
        shape = gears.shape.rounded_rect 
    }) --border_width = 10, width = 30, bg = "#000000" 


    s.mywibox:setup {
        {
            layout = wibox.layout.align.horizontal,
            {
                {
                    helpers.apply_margin ( {
                        get_launcher(s),
                        get_taglist(s),
                        s.mypromptbox,
                        get_tasklist(s),
                        spacing = dpi(12),
                        layout = wibox.layout.fixed.horizontal,
                    }, nil,dpi(6),dpi(6), dpi(8), dpi(8)),
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            nil,
            {
                helpers.apply_margin ({
                    {
                        tray_dispatcher,
                        right = dpi(5),
                        widget = wibox.container.margin,
                    },
                    mykeyboardlayout,
                    wibox.widget.systray(),
                    datetime,
                    get_layoutbutton(s),
                    helpers.mkbtn(power.shutdown, beautiful.black, beautiful.dimblack),
                    spacing = dpi(8),
                    layout = wibox.layout.fixed.horizontal,
                }, nil,dpi(6),dpi(6), dpi(8), dpi(8)),
                layout = wibox.layout.fixed.horizontal,
            },
        },
        {
            helpers.apply_margin ({
                tasklist,
                layout = wibox.layout.fixed.horizontal
            }, nil,dpi(6),dpi(6), dpi(8), dpi(8)),
            halign = 'center',
            widget = wibox.widget.margin,
            layout = wibox.container.place,
        },
        layout = wibox.layout.stack
    }

end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
local globalkeys = require 'keybinding.globalkeys'
local clientkeys = require 'keybinding.clientkeys'
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
function add_titlebar()
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
end
-- asaadd_titlebar()


-- Enable sloppy focus, so that focus follows mouse.
function add_sloppy_focus()
client.connect_signal("mouse::enter", function(c)
     c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)
end
-- add_sloppy_focus()


client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- gaps
beautiful.useless_gap = 5

-- Autostart
awful.spawn.with_shell("sh ~/.config/awesome/scripts/init.sh")
