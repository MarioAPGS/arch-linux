---@diagnostic disable: undefined-global
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

globalkeys = gears.table.join(
    -- Awesome
    awful.key({ modkey }, "z", function () awesome.emit_signal('dashboard::toggle') end,
            {description="show dashboard", group="1.awesome"}),
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
            {description="show help", group="1.awesome"}),
    awful.key({ modkey, "Shift"}, "w", function () mymainmenu:show() end,
            {description = "show main menu", group = "1.awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
            {description = "reload awesome", group = "1.awesome"}),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
            {description = "quit awesome", group = "1.awesome"}),
    awful.key({ modkey }, "x",
    function ()
        awful.prompt.run {
        prompt       = "Run Lua code: ",
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval"
        }
    end,
    {description = "lua execute prompt", group = "1.awesome"}),
    --awful.key({ modkey, }, "Left",   awful.tag.viewprev,
    --          {description = "view previous", group = "tag"}),
    --awful.key({ modkey, }, "Right",  awful.tag.viewnext,
    --         {description = "view next", group = "tag"}),
    
    -- change focus
    awful.key({ modkey, }, "Right", function () awful.client.focus.bydirection("right") end,
            {description = "move focus right", group = "2.change.focus"}),
    awful.key({ modkey, }, "Left", function () awful.client.focus.bydirection("left") end,
            {description = "move focus left", group = "2.change.focus"}),
    awful.key({ modkey, }, "Up", function () awful.client.focus.bydirection("up") end,
            {description = "move focus top", group = "2.change.focus"}),
    awful.key({ modkey, }, "Down", function () awful.client.focus.bydirection("down") end,
            {description = "move focus bottom", group = "2.change.focus"}),

    -- Swap windows
    awful.key({ modkey, "Control" }, "Left", function () awful.client.swap.bydirection("left") end,
              {description = "swap with left client", group = "3.swap.window"}),
    awful.key({ modkey, "Control" }, "Right", function () awful.client.swap.bydirection("right") end,
              {description = "swap with right client", group = "3.swap.window"}),
    awful.key({ modkey, "Control" }, "Up", function () awful.client.swap.bydirection("up") end,
              {description = "swap with top client", group = "3.swap.window"}),
    awful.key({ modkey, "Control" }, "Down", function () awful.client.swap.bydirection("down") end,
              {description = "swap with botom client", group = "3.swap.window"}),
    
    --screen
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey, }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- tile layour keys
    awful.key({ modkey, "Shift" }, "Right", function () awful.tag.incmwfact( 0.05) end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Shift" }, "Left", function () awful.tag.incmwfact(-0.05) end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Alt_L" }, "Left", function () awful.tag.incncol( 1, nil, true) end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Alt_L" }, "Right", function () awful.tag.incncol(-1, nil, true) end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey, }, "space", function () awful.layout.inc( 1) end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
            {description = "run prompt", group = "launcher"}),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
            {description = "go back", group = "tag"}),
    awful.key({ modkey, }, "Return", function () awful.spawn(terminal) end,
            {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, }, "m", function () awful.spawn("rofi -show drun") end,
            {description = "open a menu", group = "launcher"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
            {description = "show the menubar", group = "launcher"})
    )

    for i = 1, 9 do
         globalkeys = gears.table.join(globalkeys,
                 -- View tag only.
                 awful.key({ modkey }, "#" .. i + 9,
                         function ()
                                 local screen = awful.screen.focused()
                                 local tag = screen.tags[i]
                                 if tag then
                                 tag:view_only()
                                 end
                         end,
                         {description = "view tag #"..i, group = "tag"}),
                 -- Toggle tag display.
                 awful.key({ modkey, "Control" }, "#" .. i + 9,
                         function ()
                                 local screen = awful.screen.focused()
                                 local tag = screen.tags[i]
                                 if tag then
                                 awful.tag.viewtoggle(tag)
                                 end
                         end,
                         {description = "toggle tag #" .. i, group = "tag"}),
                 -- Move client to tag.
                 awful.key({ modkey, "Shift" }, "#" .. i + 9,
                         function ()
                                 if client.focus then
                                 local tag = client.focus.screen.tags[i]
                                 if tag then
                                         client.focus:move_to_tag(tag)
                                 end
                                 end
                         end,
                         {description = "move focused client to tag #"..i, group = "tag"}),
                 -- Toggle tag on focused client.
                 awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                         function ()
                                 if client.focus then
                                 local tag = client.focus.screen.tags[i]
                                 if tag then
                                         client.focus:toggle_tag(tag)
                                 end
                                 end
                         end,
                         {description = "toggle focused client on tag #" .. i, group = "tag"})
        )
         end


return globalkeys