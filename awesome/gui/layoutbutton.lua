---@diagnostic disable: undefined-global
local awful = require 'awful'
local helpers = require 'helpers'
local beautiful = require("beautiful")

local function set_layoutbutton(s)
    local base_layoutbox = awful.widget.layoutbox {
        screen = s
    }

    -- remove built-in tooltip.
    base_layoutbox._layoutbox_tooltip:remove_from_object(base_layoutbox)

    -- create button container
    local layoutbox = helpers.mkbtn(base_layoutbox, beautiful.black, beautiful.dimblack)

    -- function that returns the layout name but capitalized lol.
    local function layoutname()
        return 'Layout: ' .. helpers.capitalize(awful.layout.get(s).name)
    end

    -- make custom tooltip for the whole button
    local layoutbox_tooltip = helpers.make_popup_tooltip(layoutname(), function (d)
        return awful.placement.top_right(d, {
            margins = {
                top = beautiful.bar_height + beautiful.useless_gap * 2,
                right = beautiful.useless_gap * 2,
            }
        })
    end)

    layoutbox_tooltip.attach_to_object(layoutbox)

    -- updates tooltip content
    local update_content = function ()
        layoutbox_tooltip.widget.text = layoutname()
    end

    tag.connect_signal('property::layout', update_content)
    tag.connect_signal('property::selected', update_content)

    -- layoutbox buttons
    helpers.add_buttons(layoutbox, {
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end),
        awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)})
    return layoutbox
end
return set_layoutbutton