local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local LIST_ALL = "aerospace list-windows --all --format '%{workspace}|%{app-name}'"
local spaces = {} -- spaces[idx] = { item=<sb>, bracket=<sb>, last_label="", last_highlight=false }
local max_static = 9
local current_focused_workspace = -1

local function iconForApp(app)
	return app_icons[app] or "?"
end

local function setSpaceHighlight(idx, selected)
	local obj = spaces[idx]
	if not obj or obj.last_highlight == selected then
		return
	end

	obj.item:set({
		icon = { highlight = selected },
		label = { highlight = selected },
		background = { border_color = selected and colors.black or colors.bg2 },
	})
	obj.bracket:set({
		background = {
			border_color = selected and colors.grey or colors.bg2,
		},
	})
	obj.last_highlight = selected
end

local function updateHighlight(focused_id)
	if current_focused_workspace ~= -1 and current_focused_workspace ~= focused_id then
		setSpaceHighlight(current_focused_workspace, false)
	end
	setSpaceHighlight(focused_id, true)
	current_focused_workspace = focused_id
end

local function refreshSpaces()
	sbar.exec(LIST_ALL, function(out)
		local workspace_apps = {}
		for line in out:gmatch("[^\r\n]+") do
			local ws, app = line:match("^([^|]+)|(.*)$")
			if ws and app then
				local id = tonumber(ws)
				if id then
					workspace_apps[id] = workspace_apps[id] or {}
					workspace_apps[id][app] = true
				end
			end
		end

		for id, obj in pairs(spaces) do
			local apps = workspace_apps[id] or {}
			local lbl = ""

			local sorted_apps = {}
			for app, _ in pairs(apps) do
				table.insert(sorted_apps, app)
			end
			-- table.sort(sorted_apps)

			for _, app in ipairs(sorted_apps) do
				lbl = lbl .. iconForApp(app)
			end
			if lbl == "" then
				lbl = "-"
			end

			if obj.last_label ~= lbl then
				obj.item:set({ label = { string = lbl } })
				obj.last_label = lbl
			end
		end
	end)
end

local function createSpaceItem(idx)
	if spaces[idx] then
		return spaces[idx]
	end

	local name = "space." .. idx
	local space = sbar.add("item", name, {
		position = "left",
		icon = {
			font = { family = settings.font.space_numbers },
			string = tostring(idx),
			padding_left = 8,
			padding_right = 3,
			color = colors.white,
			highlight_color = colors.blue,
			y_offset = 1,
		},
		label = {
			padding_left = 4,
			padding_right = 10,
			color = colors.grey,
			highlight_color = colors.white,
			font = "sketchybar-app-font:Regular:16.0",
			string = "—",
		},
		padding_left = 1,
		padding_right = 1,
		background = {
			color = colors.bg1,
			border_width = 1,
			height = 26,
			border_color = colors.black,
		},
	})

	local bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = colors.bg2,
			height = 28,
			border_width = 2,
		},
	})

	sbar.add("item", "space.padding." .. idx, {
		position = "left",
		width = settings.group_paddings,
	})

	spaces[idx] = {
		item = space,
		bracket = bracket,
		last_label = "— ",
		last_highlight = false,
	}

	space:subscribe("mouse.clicked", function()
		sbar.exec("aerospace workspace " .. idx)
	end)

	return spaces[idx]
end

for i = 1, max_static do
	createSpaceItem(i)
end

refreshSpaces()

local observer = sbar.add("item", { drawing = false, updates = true })

observer:subscribe("aerospace_workspace_change", function(env)
	local focused = tonumber(env.FOCUSED_WORKSPACE)
	if focused then
		-- 1. If a new workspace was created beyond 9, ensure it exists
		if not spaces[focused] then
			createSpaceItem(focused)
		end
		updateHighlight(focused)
	end
	refreshSpaces()
end)

observer:subscribe("aerospace_window_change", function()
	refreshSpaces()
end)

local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = -5,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

spaces_indicator:subscribe("mouse.entered", function()
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = { color = { alpha = 1.0 }, border_color = { alpha = 1.0 } },
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function()
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = { color = { alpha = 0.0 }, border_color = { alpha = 0.0 } },
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function()
	sbar.trigger("swap_menus_and_spaces")
end)
