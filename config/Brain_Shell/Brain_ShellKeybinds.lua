-- ==============================================================================
-- Brain Shell Keybinds
-- User-owned copy installed through Ryoku's user_edits overlay.
-- ===============================================================================

local shell = os.getenv("HOME") .. "/.local/share/brain-desktop"

-- ==============================================================================
-- BrainShell Capture Submap (Disables all normal binds during recording)
-- ==============================================================================
hl.define_submap("BrainShell_clean", function()
    hl.bind("CTRL + ESCAPE", function()
        hl.dispatch(hl.dsp.exec_cmd("notify-send 'BrainShell' 'Emergency Exit: Keybinds re-enabled.'"))
        hl.dispatch(hl.dsp.submap("reset"))
    end, { description = "Emergency return to global submap" })
end)

-- ==============================================================================
-- Dashboard
-- ==============================================================================
hl.bind("SUPER + D", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call dashboard-home toggle"))
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call dashboard-stats toggle"))
hl.bind("SUPER + Z", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call dashboard-kanban toggle"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call dashboard-launcher toggle"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call dashboard-config toggle"))

-- ==============================================================================
-- Popups
-- ==============================================================================
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call PowerMenu-toggle toggle"))
-- Super + N is intentionally not owned by Brain Desktop.
hl.bind("SUPER + W", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call wallpaper-toggle toggle"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call clipboard-toggle toggle"))

-- ==============================================================================
-- Network Tabs
-- ==============================================================================
hl.bind("SUPER + ALT + W", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call wifi-toggle toggle"))
hl.bind("SUPER + ALT + B", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call bluetooth-toggle toggle"))
hl.bind("SUPER + ALT + G", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call vpn-toggle toggle"))
hl.bind("SUPER + ALT + H", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call hotspot-toggle toggle"))

-- ==============================================================================
-- Audio Tabs
-- ==============================================================================
hl.bind("SUPER + A", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call audioOut-toggle toggle"))
hl.bind("SUPER + ALT + I", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call audioIn-toggle toggle"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call audioMix-toggle toggle"))

-- ==============================================================================
-- Quick Settings
-- ==============================================================================
hl.bind("SUPER + F", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call focus-toggle toggle"))
hl.bind("ALT + F9", hl.dsp.exec_cmd("qs ipc -c " .. shell .. " call screenrec-on toggle"))
