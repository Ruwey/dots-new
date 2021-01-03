-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- Helper Commands
local helper = require("helper")

-- Autostart
awful.spawn.with_shell("picom")
awful.spawn.with_shell("udiskie")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
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
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/nord/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "termite"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %l:%M %p ")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
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
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = beautiful.wibar_position, screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mytextclock,
        },
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

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "/",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, ",", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey,           }, ".", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "e", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

	-- Layout
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end, 
			  {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "u", 	  function () awful.layout.set(awful.layout.suit.tile) end,
              {description = "set to tiled layout", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "u", 	  function () awful.layout.set(awful.layout.suit.tile.left) end,
              {description = "set to tiled left layout", group = "layout"}),
    awful.key({ modkey, "Control" }, "u", 	  function () awful.layout.set(awful.layout.suit.tile.bottom) end,
              {description = "set to tiled bottom layout", group = "layout"}),
    awful.key({ modkey, "Control", "Shift" },"u",function () awful.layout.set(awful.layout.suit.tile.top) end,
              {description = "set to tiled top layout", group = "layout"}),
    awful.key({ modkey,           }, "i", 	  function () awful.layout.set(awful.layout.suit.spiral) end,
              {description = "set to spiral layout", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "i", 	  function () awful.layout.set(awful.layout.suit.spiral.dwindle) end,
              {description = "set to dwindle layout", group = "layout"}),
    awful.key({ modkey,           }, "y", 	  function () awful.layout.set(awful.layout.suit.floating) end,
              {description = "set to floating layout", group = "layout"}),

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
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "d", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
	
	-- Launcher
	-- Power Buttons
	awful.key({ modkey            }, "BackSpace",
		function() awful.spawn.with_shell("powerMenu") end,
		{description = "open power menu", group = "power"}),
	awful.key({ modkey, "Shift"   }, "BackSpace",
		function() awful.spawn.with_shell("blurlock") end,
		{description = "lock the screen", group = "power"}),
	-- Backlight
	awful.key({                   }, "XF86MonBrightnessUp",
		function() awful.spawn.with_shell("chBl +5") end,
		{description = "lower brightness 5%", group = "backlight"}),
	awful.key({                   }, "XF86MonBrightnessDown",
		function() awful.spawn.with_shell("chBl -5") end,
		{description = "raise brightness 5%", group = "backlight"}),
	-- Media Keys
	awful.key({ modkey            }, "m",
		function() awful.spawn.with_shell("chMp") end,
		{description = "change media player", group = "media"}),
	awful.key({ modkey, "Shift"   }, "m",
		function() awful.spawn.with_shell("chSink") end,
		{description = "change default sink", group = "media"}),
	awful.key({                   }, "XF86AudioRaiseVolume",
		function()
			awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ +5%",
				function() awesome.emit_signal("volume") end)
		end,
		{description = "raise volume (5%)", group = "media"}),
	awful.key({                   }, "XF86AudioLowerVolume",
		function()
			awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ -5%",
				function() awesome.emit_signal("volume") end)
		end,
		{description = "lower volume (5%)", group = "media"}),
	awful.key({ "Shift"           }, "XF86AudioRaiseVolume",
		function()
			awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ +2%",
				function() awesome.emit_signal("volume") end)
		end,
		{description = "raise volume (2%)", group = "media"}),
	awful.key({ "Shift"           }, "XF86AudioLowerVolume",
		function()
			awful.spawn.easy_async_with_shell("pactl set-sink-volume @DEFAULT_SINK@ -2%",
				function() awesome.emit_signal("volume") end)
		end,
		{description = "lower volume (2%)", group = "media"}),
	awful.key({                   }, "XF86AudioMute",
		function()
			awful.spawn.easy_async_with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle",
				function() awesome.emit_signal("volume") end)
		end,
		{description = "mute", group = "media"}),
	awful.key({                   }, "XF86AudioPlay",
		function() awful.spawn.with_shell("playerctl -p $(cat $HOME/.local/share/mediaPlayer) play-pause") end,
		{description = "Toggle Music", group = "media"}),
	awful.key({                   }, "XF86AudioNext",
		function() awful.spawn.with_shell("playerctl -p $(cat $HOME/.local/share/mediaPlayer) next") end,
		{description = "Next Song", group = "media"}),
	awful.key({                   }, "XF86AudioPrev",
		function() awful.spawn.with_shell("playerctl -p $(cat $HOME/.local/share/mediaPlayer) previous") end,
		{description = "Previous Song", group = "media"}),

	-- Passwords
	awful.key({ modkey,           }, "p",
		function() awful.spawn.with_shell("passmenu") end,
		{description = "Pass menu", group = "passwords"}),
	awful.key({ modkey, "Shift"   }, "p",
		function() awful.spawn.with_shell("ykOath") end,
		{description = "Yubico OATH Menu", group = "passwords"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "f",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
        {description = "toggle maximize", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey,           }, "space",
		function (c)
			if awful.client.urgent.get() then
				awful.client.urgent.jumpto()
				naughty.notification ({title="sup"})
			else
				c:swap(awful.client.getmaster())
			end
		end,
    	{description = "move to urgent or master", group = "client"}),
    awful.key({ modkey, "Shift"   }, ",",      function (c) c:move_to_screen(c.screen.index+1) end,
              {description = "move to next screen", group = "client"}),
    awful.key({ modkey, "Shift"   }, ".",      function (c) c:move_to_screen(c.screen.index-1) end,
              {description = "move to previous screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "s",      function (c) c.sticky = not c.sticky            end,
              {description = "toggle sticky", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
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

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
	c.floating = true;
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
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

    { rule_any = {name = "Picture-in-Picture"},
      properties = {
        sticky = true,
		floating = true,
		ontop = true
      }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Remove Firefox Titlebar
    --{ rule_any = { class = {"Firefox", "Nightly"} },
    --    properties = { titlebars_enabled = false }
    --},

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
	if not awesome.startup then
		awful.client.setslave(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
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

    --awful.titlebar(c) : setup {
    --	--{ -- Left
    --    --    awful.titlebar.widget.iconwidget(c),
    --    --    buttons = buttons,
    --    --    layout  = wibox.layout.fixed.horizontal
    --    --},
	--	null,
    --    { -- Middle
    --        { -- Title
    --            align  = "center",
    --            widget = awful.titlebar.widget.titlewidget(c)
    --        },
    --        buttons = buttons,
    --        layout  = wibox.layout.flex.horizontal
    --    },
    --    { -- Right
    --        awful.titlebar.widget.floatingbutton (c),
    --        awful.titlebar.widget.maximizedbutton(c),
    --        awful.titlebar.widget.stickybutton   (c),
    --        awful.titlebar.widget.ontopbutton    (c),
    --        awful.titlebar.widget.closebutton    (c),
    --        layout = wibox.layout.fixed.horizontal()
    --    },
    --    layout = wibox.layout.align.horizontal
    --}
	awful.titlebar(c, {size = 25}) : setup {
		{
			widget = wibox.widget.textbox,
			buttons = buttons
		},
		{
			widget = awful.titlebar.widget.titlewidget(c),
			align = "center",
			buttons = buttons
		},
		{
			awful.titlebar.widget.maximizedbutton	(c),
			awful.titlebar.widget.minimizebutton	(c),
			awful.titlebar.widget.closebutton		(c),
			layout = wibox.layout.fixed.horizontal
		},
		layout = wibox.layout.align.horizontal
	}
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Volume Change
local volNotif
awesome.connect_signal("volume", function()
	awful.spawn.easy_async_with_shell([[pacmd list-sinks | grep -C 11 "* index:" | tail -1 | awk '{print $2}']],
	function(stdout)
		if (tostring(stdout) == "yes\n") then
			volNotif = helper.notify({title="Volume Muted", message=null}, volNotif)
		else
			awful.spawn.easy_async_with_shell([[pacmd list-sinks | grep "* index:" -C 7 | tail -1 | sed 's/[/%]//g' | awk '{ print $4 }']],
			function(stdout)
				message=helper.progress(stdout, 20)
				volNotif = helper.notify({title="墳 Volume: "..tonumber(stdout).."%", message=message}, volNotif)
			end)
		end
	end)
end)
-- }}}
