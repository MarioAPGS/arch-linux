local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local helpers = require 'helpers'
local fs = gears.filesystem


---======================---
--|          CPU         |--
---======================---
-- format: <percentage of use> ex: 13.4

local cpu = [[ echo $(top -bcn1 | grep -i "%Cpu(s): " | awk '{print $4}')"" ]]

gears.timer {
    timeout = 2,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(cpu, function (used)
            awesome.emit_signal('resource::cpu', used)
        end)
    end
}

---======================---
--|          RAM         |--
---======================---
-- format: {<usage in Gb>, <percentage of use>}| ex: {3.1, 19}

local ram = [[ LC_NUMERIC=C;echo $(printf "%0.1f" $(free | grep Mem | awk '{print $3 / 10^6}'))"|"$(printf "%0.0f" $(free | grep Mem | awk '{print $3/$2 * 100.0}')) ]]

gears.timer {
    timeout = 2,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(ram, function (used)
            local segments = helpers.split(used, "|")
            awesome.emit_signal('resource::ram', segments)
        end)
    end
}

---======================---
--|         Temp         |--
---======================---
-- format: <temperature> ex: 65

local temp = fs.get_configuration_dir() .. "scripts/temp.sh get | awk '{print $1}'"

gears.timer {
    timeout = 2,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(temp, function (used)
            awesome.emit_signal('resource::temp', helpers.trim(used))
        end)
    end
}

---======================---
--|          Net         |--
---======================---
-- format: <temperature> ex: <download in kb>|<upload in kb> ex: 243.42|54.238

local net = 'echo $(cat ~/.cache/netrx)"|"$(cat ~/.cache/nettx)'

gears.timer {
    timeout = 2,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(net, function (used)
            local segments = helpers.split(used, "|")
            awesome.emit_signal('resource::net', segments)
            --naughty.notify({ preset = naughty.config.presets.info, title = "Log", text = helpers.trim(used) })
        end)
    end
}

---======================---
--|        Battery       |--
---======================---
local batery = "batdir=/sys/class/power_supply/BAT1; echo $(cat $batdir/capacity)'|'$(cat $batdir/status)'|'$(cat $batdir/voltage_now) | grep -i '|'"
-- batery percentage, status, voltage consuming
gears.timer {
    timeout = 2,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(batery, function (used)
            local segments = helpers.split(used, "|")
            awesome.emit_signal('resource::bat', segments)
            --naughty.notify({ preset = naughty.config.presets.info, title = "Log", text = helpers.trim(used) })
        end)
    end
}

---======================---
--|         Disk         |--
---======================---
local disk = "df | grep -i /dev/nvm | awk '{print $6\"|\"$3*10^-6\"|\"$2*10^-6}' | xargs"
gears.timer {
    timeout = 10,
    call_now = true,
    autostart = true,
    callback = function ()
        awful.spawn.easy_async_with_shell(disk, function (used)
            local segments = helpers.split(used, " ")
            awesome.emit_signal('resource::disk', segments)
            --naughty.notify({ preset = naughty.config.presets.info, title = "Log", text = helpers.trim(used) })
        end)
    end
}