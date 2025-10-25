--=====================================================================
--  SketchyBar + Aerospace workspace bar  –  CACHED + DYNAMIC
--=====================================================================
local colors     = require("colors")
local icons      = require("icons")
local settings   = require("settings")
local app_icons  = require("helpers.app_icons")

-- ---------------------------------------------------------------------
--  CLI snippets
-- ---------------------------------------------------------------------
local LIST_ALL   = "aerospace list-windows --all --format '%{workspace}|%{app-name}'"
local LIST_FOC   = "aerospace list-workspaces --focused"
local LIST_WS    = "aerospace list-workspaces --all"

-- ---------------------------------------------------------------------
--  Globals
-- ---------------------------------------------------------------------
local spaces     = {} -- spaces[idx] = { item=<sb>, bracket=<sb> }
local app_cache  = {} -- app_cache[idx] = { [app]=count }
-- ---------------------------------------------------------------------
--  second cache: last_known[workspace] = { [app] = true }
-- ---------------------------------------------------------------------
local last_known = {}
-- ---------------------------------------------------------------------
--  Helpers
-- ---------------------------------------------------------------------
local function iconForApp(app) return app_icons[app] or "?" end

local function tableKeys(t)
    local a = {}
    for k, _ in pairs(t) do a[#a + 1] = k end
    return a
end

local function setSpaceLabel(idx)
    local obj = spaces[idx]
    if not obj then return end -- safety
    local t   = app_cache[idx] or {}
    local arr = tableKeys(t)
    local lbl = ""
    for _, app in ipairs(arr) do lbl = lbl .. iconForApp(app) end
    if lbl == "" then lbl = "-" end
    obj.item:set({ label = { string = lbl, drawing = true } })
end

local function setSpaceHighlight(idx, selected)
    local obj = spaces[idx]
    if not obj then return end
    obj.item:set({
        icon       = { highlight = selected },
        label      = { highlight = selected },
        background = { border_color = selected and colors.black or colors.bg2 },
    })
    obj.bracket:set({
        background = {
            border_color = selected and colors.grey or colors.bg2,
            color        = colors.transparent,
            height       = 28,
            border_width = 2,
        },
    })
end

local function refreshHighlights()
    sbar.exec(LIST_FOC, function(out)
        local focused = tonumber(out:match("%d+"))
        for id, _ in pairs(spaces) do setSpaceHighlight(id, id == focused) end
    end)
end

local function updateWorkspaceIfNeeded(idx)
    sbar.exec("aerospace list-windows --workspace " .. idx .. " --format '%{app-name}'",
        function(out)
            local now = {}
            for line in out:gmatch("[^\r\n]+") do
                local app = line:match("^%s*(.-)%s*$")
                if app ~= "" then now[app] = true end
            end

            if not last_known[idx] then
                last_known[idx] = now
                app_cache[idx] = {}
                for app, _ in pairs(now) do
                    app_cache[idx][app] = (app_cache[idx][app] or 0) + 1
                end
                setSpaceLabel(idx)
                return
            end

            local changed = false
            for app, _ in pairs(now) do
                if not last_known[idx][app] then
                    changed = true
                    break
                end
            end
            for app, _ in pairs(last_known[idx]) do
                if not now[app] then
                    changed = true
                    break
                end
            end

            if changed then
                last_known[idx] = now
                app_cache[idx] = {}
                for app, _ in pairs(now) do
                    app_cache[idx][app] = (app_cache[idx][app] or 0) + 1
                end
                setSpaceLabel(idx)
            end
        end)
end

-- ---------------------------------------------------------------------
--  Create UI for a workspace (idempotent)
-- ---------------------------------------------------------------------
local function createSpaceItem(idx)
    if spaces[idx] then return spaces[idx] end
    local name = "space." .. idx

    local space = sbar.add("space", name, {
        space         = idx,
        icon          = {
            font            = { family = settings.font.space_numbers },
            string          = tostring(idx),
            padding_left    = 8,
            padding_right   = 3,
            color           = colors.white,
            highlight_color = colors.blue,
            y_offset        = 1,
        },
        label         = {
            padding_left    = 4,
            padding_right   = 10,
            color           = colors.grey,
            highlight_color = colors.white,
            font            = "sketchybar-app-font:Regular:16.0",
        },
        padding_left  = 1,
        padding_right = 1,
        background    = {
            color        = colors.bg1,
            border_width = 1,
            height       = 26,
            border_color = colors.black,
        },
        popup         = { background = { border_width = 5, border_color = colors.black } },
    })

    local bracket = sbar.add("bracket", { space.name }, {
        background = {
            color        = colors.transparent,
            border_color = colors.bg2,
            height       = 28,
            border_width = 2,
        },
    })

    sbar.add("space", "space.padding." .. idx, {
        space = idx,
        script = "",
        width = settings.group_paddings,
    })

    local space_popup = sbar.add("item", {
        position      = "popup." .. space.name,
        padding_left  = 5,
        padding_right = 0,
        background    = {
            drawing = true,
            image = { corner_radius = 9, scale = 0.2 },
        },
    })

    spaces[idx] = { item = space, bracket = bracket }

    space:subscribe("mouse.clicked", function(env)
        if env.BUTTON == "other" then
            space_popup:set({ background = { image = "space." .. env.SID } })
            space:set({ popup = { drawing = "toggle" } })
        else
            sbar.exec("aerospace workspace " .. env.SID)
        end
    end)

    space:subscribe("mouse.exited", function()
        space:set({ popup = { drawing = false } })
    end)

    return spaces[idx]
end
-- ---------------------------------------------------------------------
--  Ensure SketchyBar items exist for every current workspace
-- ---------------------------------------------------------------------
local function ensureAllSpaces()
    sbar.exec(LIST_WS, function(out)
        for w in out:gmatch("%S+") do
            local id = tonumber(w)
            createSpaceItem(id)
        end
    end)
end

-- ---------------------------------------------------------------------
--  Prime cache on first run
-- ---------------------------------------------------------------------
local function primeCache(cb)
    sbar.exec(LIST_ALL, function(out)
        for line in out:gmatch("[^\r\n]+") do
            local ws, app = line:match("^([^|]+)|(.*)$")
            if ws and app then
                local id = tonumber(ws)
                app_cache[id] = app_cache[id] or {}
                app_cache[id][app] = (app_cache[id][app] or 0) + 1
            end
        end
        for id, _ in pairs(spaces) do setSpaceLabel(id) end
        refreshHighlights()
        if cb then cb() end
    end)
end

-- ---------------------------------------------------------------------
--  Observer – handles Aerospace events
-- ---------------------------------------------------------------------
local observer = sbar.add("item", { drawing = false, updates = true })

-- WORKSPACE changed (user switched to another space)
observer:subscribe("aerospace_workspace_change", function(env)
    ensureAllSpaces()
    refreshHighlights()
    local new = tonumber(env.FOCUSED_WORKSPACE)
    if new then updateWorkspaceIfNeeded(new) end
end)

observer:subscribe("aerospace_window_change", function(env)
    ensureAllSpaces()
    sbar.exec("aerospace list-workspaces --focused", function(out)
        local focused = tonumber(out:match("%d+"))
        if focused then updateWorkspaceIfNeeded(focused) end
    end)
end)

-- ---------------------------------------------------------------------
--  Initial population
-- ---------------------------------------------------------------------


-- ---------------------------------------------------------------------
--  Spaces indicator (unchanged eye-candy)
-- ---------------------------------------------------------------------
local spaces_indicator = sbar.add("item", {
    padding_left  = -3,
    padding_right = -5,
    icon          = {
        padding_left  = 8,
        padding_right = 9,
        color         = colors.grey,
        string        = icons.switch.on,
    },
    label         = {
        width         = 0,
        padding_left  = 0,
        padding_right = 8,
        string        = "Spaces",
        color         = colors.bg1,
    },
    background    = {
        color        = colors.with_alpha(colors.grey, 0.0),
        border_color = colors.with_alpha(colors.bg1, 0.0),
    },
})

spaces_indicator:subscribe("swap_menus_and_spaces", function()
    local on = spaces_indicator:query().icon.value == icons.switch.on
    spaces_indicator:set({ icon = { string = on and icons.switch.off or icons.switch.on } })
end)

spaces_indicator:subscribe("mouse.entered", function()
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = { color = { alpha = 1.0 }, border_color = { alpha = 1.0 } },
            icon       = { color = colors.bg1 },
            label      = { width = "dynamic" },
        })
    end)
end)

spaces_indicator:subscribe("mouse.exited", function()
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = { color = { alpha = 0.0 }, border_color = { alpha = 0.0 } },
            icon       = { color = colors.grey },
            label      = { width = 0 },
        })
    end)
end)

spaces_indicator:subscribe("mouse.clicked", function()
    sbar.trigger("swap_menus_and_spaces")
end)
ensureAllSpaces()
primeCache()
