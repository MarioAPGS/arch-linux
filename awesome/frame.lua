local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local helpers = require 'helpers'
local naughty = require("naughty")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local frame = {}



function frame.build(listenerkey, widget, placement, screen)
    frame.widget = widget
    frame.listenerkey = listenerkey
    if(screen == nil)
    then screen = awful.screen.focused()
    end

    frame.popup = awful.popup {
        visible = false,
        screen = screen,
        shape = helpers.mkroundedrect(),
        bg = beautiful.bg_normal .. '00',
        fg = beautiful.fg_normal,
        ontop = true,
        placement = placement or awful.placement.centered,
        widget = helpers.mkroundedcontainer(frame.widget, beautiful.bg_normal),
    }

    awesome.connect_signal(frame.listenerkey .. '::toggle', function ()
        frame.toggle()
    end)
    
    awesome.connect_signal(frame.listenerkey .. '::show', function ()
        frame.show()
    end)
    
    awesome.connect_signal(frame.listenerkey .. '::hide', function ()
        frame.hide()
    end)
    
    return frame
end

function frame.show()
    frame.popup.screen = awful.screen.focused()
    frame.popup.visible = true
end

function frame.hide()
    frame.popup.visible = false
end

function frame.toggle()
    if not frame.popup.visible and frame.popup.screen ~= awful.screen.focused() then
        frame.popup.screen = awful.screen.focused()
    end
    frame.popup.visible = not frame.popup.visible
end




return frame