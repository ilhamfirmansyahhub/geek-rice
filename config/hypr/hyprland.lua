-- optional(mod): load a drop-in only when its file exists. most of these are
-- never shipped (user overrides, hub and theme output), and hyprland reports
-- even a pcall'd require() of a missing module in the config-error overlay,
-- so a fresh home flashed "Your config has errors" on first boot. probe the
-- path first; a file that exists but is torn or corrupt still degrades via
-- pcall instead of emergency mode, and ryoku doctor repairs it.
local function optional(mod)
    if package.searchpath == nil or package.searchpath(mod, package.path) then
        local ok, err = pcall(require, mod)
        if not ok then
            print("ryoku: optional config module '" .. mod .. "' failed to load: " .. tostring(err))
        end
    end
end

require("modules.env")
optional("keyboard")
optional("gpu")
optional("monitors")
optional("monitors_user")
require("modules.displays")
require("modules.input")
require("modules.misc")
require("modules.decoration")
require("modules.animations")
require("modules.binds")
require("modules.resize")
require("modules.record")
require("modules.ryoshot")
require("modules.lid")
require("modules.window_rules")
require("modules.fullscreen")
require("modules.autostart")

-- machine-state written by the hub (ryoku-hub), never shipped. after the base
-- modules so the GUI's tweaks override the defaults, before user.lua so a
-- hand-written user file still wins.
optional("settings")

-- Power Saver strips compositor blur and shadow (the heaviest present-time GPU
-- cost). After settings so the active power profile wins over the Hub's
-- decoration tweaks; before user.lua so a hand file still wins. Gated by the
-- shell-written cache, which reflects Performance's "Follow the power profile".
optional("modules.perf_saver")

optional("modules.private")
optional("ghosttype")

-- last word: ~/.config/hypr/user.lua. This file is user-owned and is not
-- modified by Ryoku updates. Persistent Geek Rice overrides, including the
-- Brain Desktop integration, live there.
optional("user")
