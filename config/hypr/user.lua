-- --- hypr/user.lua --------------------------------------------------------
-- Your Hyprland overrides, in Ryoku's `hl` Lua API. Loaded LAST, so anything
-- here wins over Ryoku's defaults and over Ryoku Settings. Updates never touch
-- it. Keep persistent cross-component overrides here instead of editing
-- Ryoku-managed modules directly.
--
-- Brain Desktop is installed outside Ryoku's Quickshell config tree at:
--   ~/.local/share/brain-desktop
-- Its keybind file is kept in Ryoku's user_edits overlay and loaded here.

-- Persistent personal input/decoration overrides.
hl.config({
    input = {
        follow_mouse = 1,
    },
})

hl.config({
    decoration = {
        blur = {
            enabled = true,
            size = 5,
            passes = 1,
        },
    },
})

-- Brain Desktop keybinds must be loaded after Ryoku's defaults.
local brain = os.getenv("HOME") .. "/.config/ryoku/user_edits/Brain_Shell/Brain_ShellKeybinds.lua"
local ok, err = pcall(dofile, brain)
if not ok then
    print("geek-rice: failed to load Brain Desktop keybinds: " .. tostring(err))
end

-- Final personal ownership of shared shortcuts.
-- Super + Space -> Brain Desktop launcher.
hl.unbind("SUPER + SPACE")
hl.bind(
    "SUPER + SPACE",
    hl.dsp.exec_cmd(
        "qs ipc -c " .. os.getenv("HOME") .. "/.local/share/brain-desktop call dashboard-launcher toggle"
    )
)

-- Super + N -> Kate. Brain/Ryoku notifications do not own this shortcut.
hl.unbind("SUPER + N")
hl.bind("SUPER + N", hl.dsp.exec_cmd("kate"))
