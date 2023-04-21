local beautiful = require 'beautiful'
local gears = require 'gears'

function set_wallpaper(s)
    if beautiful.wallpaper then
        gears.wallpaper.maximized(beautiful.wallpaper, s, false, nil)
     end
end

screen.connect_signal("property::geometry", set_wallpaper) -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)

return set_wallpaper