local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local helpers = require 'helpers'
local fs = gears.filesystem

local emitter = {}

emitter.volume = {}

emitter.volume.cmd_get_volume = function (device) 
    return "pactl list sinks | grep -i 'volume: front' | sed -n '" .. tostring(device+1) .. " p' | awk '{print $5}' | sed 's/%//g'" 
end
emitter.volume.cmd_set_volume = function (device, volume) 
    return "pactl set-sink-volume " .. device .. " " .. volume .. "%" 
end
-- device: index of the device (1,2,3...)
-- volume: volume in percentage ex: 65 or nil,in this case, emit signal whit the current value
--   emit: device|volume ex: 0|65
emitter.volume.set = function (device, volume)
    if volume == nil then
        local get_volume_cmd = 
        awful.spawn.easy_async_with_shell(emitter.volume.cmd_get_volume(device), function (value)
            awesome.emit_signal('volume::change', device.."|"..value)
        end)
    else
        awful.spawn(emitter.volume.cmd_set_volume(device, volume))
        awesome.emit_signal('volume::change', device.."|"..volume)
    end
end

emitter.mute = {}
emitter.mute.cmd_get_mute = function (device) 
    return "pactl list sinks | grep -i 'Mute: ' | sed -n '" .. tostring(device+1) .. " p' | awk '{print $2}'" 
end
emitter.mute.cmd_set_mute = function (device, status) 
    return "pactl set-sink-mute " .. device .. " " .. status
end
-- device: index of the device (1,2,3...)
-- status: 0 = unputed, 1 = muted or nil,in this case, emit signal whit the current value
--   emit: device|status ex: 0|0
emitter.mute.set = function (device, status)
    if status == nil then
        awful.spawn.easy_async_with_shell(emitter.mute.cmd_get_mute(device), function (value)
            if helpers.trim(value) == 'no' then
                current_mute = 0
            else
                current_mute = 1
            end
            awesome.emit_signal('mute::change', device.."|"..current_mute)
        end)
    else
        awful.spawn(emitter.mute.cmd_set_mute(device, volume))
        awesome.emit_signal('mute::change', device.."|"..status)
    end
end

-- device: audio device to toggle mute
--   emit: device|status ex: 0|0
emitter.mute.toggle = function (device)
    awful.spawn.easy_async_with_shell(emitter.mute.cmd_get_mute(device), function (value)
        if helpers.trim(value) == 'no' then
            toggle_value = 1
        else
            toggle_value = 0
        end
        awful.spawn(emitter.mute.cmd_set_mute(device, toggle_value))
        awesome.emit_signal('mute::change', device.."|"..toggle_value)
    end)
end

return emitter