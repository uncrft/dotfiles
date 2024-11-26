-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- General
config.front_end = "WebGpu"
config.window_close_confirmation = "AlwaysPrompt"
config.default_workspace = "coding"

-- Special characters with option key
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- Appearance
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_alignment = "Left"
config.window_background_opacity = 0.55
config.color_scheme = "tokyonight_night"
config.colors = {
	background = "black",
}
config.font = wezterm.font_with_fallback({
	{ family = "GeistMono Nerd Font", scale = 1.1 },
})
config.use_cap_height_to_scale_fallback_fonts = true

-- Tab bar
config.use_fancy_tab_bar = true

local function basename(s)
	if s == nil then
		return ""
	end
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function pill(text, fg, bg, pad, intensity)
	local RightSeparator = wezterm.nerdfonts.ple_right_half_circle_thick
	local LeftSeparator = wezterm.nerdfonts.ple_left_half_circle_thick

	if pad == "left" then
		LeftSeparator = " " .. LeftSeparator
	elseif pad == "right" then
		RightSeparator = RightSeparator .. " "
	end

	return {
		{ Foreground = bg },
		{ Background = { Color = "Black" } },
		{ Text = LeftSeparator },
		-- { Attribute = { Intensity = "Bold" } },
		{ Foreground = fg },
		{ Background = bg },
		{ Text = text },
		{ Foreground = bg },
		{ Background = { Color = "Black" } },
		{ Text = RightSeparator },
	}
end
--
-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

if config.use_fancy_tab_bar then
	-- config.tab_max_width = 25

	config.window_frame = {
		font = wezterm.font({ family = "GeistMono Nerd Font", weight = "Bold", scale = 1 }),
		font_size = 10.5,
	}

	wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
		local title = tab_title(tab)

		if #title > 15 then
			title = wezterm.truncate_right(title, max_width - 2) .. "…"
		end

		if tab.is_active then
			return { { Foreground = { Color = "#f7768e" } }, { Text = " " .. title } }
		end
		return { { Foreground = { Color = "#bb9af7" } }, { Text = " " .. title } }
	end)
else
	config.tab_max_width = 25

	config.tab_bar_style = {
		new_tab = wezterm.format(pill("+", { Color = "Black" }, { Color = "Gray" }, "left")),
		new_tab_hover = wezterm.format(pill("+", { Color = "Black" }, { Color = "Silver" }, "left")),
	}

	wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
		local background = "#b4f9f8"

		local foreground = "Black"

		if tab.is_active then
			background = "#1abc9c"
			foreground = "Black"
		elseif hover then
			background = "#4fd6be"
			foreground = "Black"
		end

		local title = tab_title(tab)
		if #title > max_width - 2 then
			title = wezterm.truncate_right(title, max_width - 4) .. "…"
		end

		local pad = "left"
		if tab.tab_index == 0 then
			pad = ""
		end
		return pill(title, { Color = foreground }, { Color = background }, pad)
	end)

	-- Status bar
	wezterm.on("update-right-status", function(window, pane)
		local cmd = wezterm.nerdfonts.fa_code .. " " .. basename(pane:get_foreground_process_name())
		local cwd = pane:get_current_working_dir()
		local cwd_path = ""
		if cwd ~= nil then
			cwd_path = wezterm.nerdfonts.oct_file_directory .. " " .. basename(cwd.path)
		end

		local status = wezterm.nerdfonts.cod_terminal_tmux .. " " .. window:active_workspace()
		if window:active_key_table() then
			status = wezterm.nerdfonts.cod_settings .. " " .. window:active_key_table()
		end

		local cmd_pill = wezterm.format(pill(cmd, { Color = "Black" }, { Color = "#b4f9f8" }, "right"))
		local cwd_pill = wezterm.format(pill(cwd_path, { Color = "Black" }, { Color = "#73daca" }, "right"))
		local status_pill = wezterm.format(pill(status, { Color = "Black" }, { Color = "#1abc9c" }))

		window:set_right_status(cmd_pill .. cwd_pill .. status_pill)
	end)
end

-- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
-- bar.apply_to_config(config, {
-- 	position = "top",
-- })
--
local function exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok, err
end

--- Check if a directory exists in this path
local function isdir(path)
	-- "/" works on both Unix and Windows
	return exists(path .. "/")
end

wezterm.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	if cmd == nil then
		local oe_engineering_dir = wezterm.home_dir .. "/Dev/oe-engineering"

		local tab, pane, window
		for _, dir_name in ipairs(wezterm.read_dir(oe_engineering_dir)) do
			if isdir(dir_name) then
				if window == nil then
					tab, pane, window = wezterm.mux.spawn_window({
						workspace = "coding",
						cwd = dir_name,
						-- args = {},
					})
					-- window:gui_window():maximize()
				else
					tab, pane, window = window:spawn_tab({
						cwd = dir_name,
						-- args = {},
					})
				end

				tab:set_title(basename(dir_name))

				pane = pane:split({
					direction = "Right",
					size = 0.2,
					cwd = dir_name,
					-- top_level = true,
				})

				pane = pane:split({
					direction = "Bottom",
					size = 0.5,
					cwd = dir_name,
				})
			end
		end

		-- wezterm.action.ActivateTab(0)
		wezterm.mux.set_active_workspace("coding")
	end

	-- may as well kick off a build in that pane
	-- build_pane:send_text 'cargo build\n'

	-- A workspace for interacting with a local machine that
	-- runs some docker containers for home automation
	-- local tab, pane, window = wezterm.mux.spawn_window {
	--   workspace = 'automation',
	--   args = { 'ssh', 'vault' },
	-- }

	-- We want to startup in the coding workspace
end)

-- Keybindings
local action = wezterm.action
-- config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "e",
		mods = "CTRL|SHIFT",
		action = wezterm.action({
			QuickSelectArgs = {
				patterns = {
					"https?://\\S+",
				},
				action = wezterm.action_callback(function(window, pane)
					local url = window:get_selection_text_for_pane(pane)
					wezterm.open_with(url)
				end),
			},
		}),
	},
	-- send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER", action = action.SendKey({ key = "a", mods = "CTRL" }) },
	-- copy mode
	{ key = "c", mods = "CTRL|SHIFT", action = action.ActivateCopyMode },
	-- copy/paste
	{ key = "c", mods = "CMD", action = action.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = action.PasteFrom("Clipboard") },
	-----------
	-- PANES --
	-----------
	-- close pane
	{ key = "w", mods = "CMD", action = action.CloseCurrentPane({ confirm = true }) },
	{ key = "w", mods = "CTRL|SHIFT", action = action.CloseCurrentPane({ confirm = true }) },
	-- split pane
	{ key = "|", mods = "CTRL|SHIFT", action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "_", mods = "CTRL|SHIFT", action = action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- navigate panes
	{ key = "n", mods = "CTRL|SHIFT", action = action.ActivatePaneDirection("Left") },
	{ key = "o", mods = "CTRL|SHIFT", action = action.ActivatePaneDirection("Right") },
	{ key = "i", mods = "CTRL|SHIFT", action = action.ActivatePaneDirection("Up") },
	{ key = "e", mods = "CTRL|SHIFT", action = action.ActivatePaneDirection("Down") },
	-- rotate panes
	{ key = "r", mods = "CTRL|SHIFT", action = action.RotatePanes("Clockwise") },
	-- resize panes
	{ key = "r", mods = "CMD", action = action.ActivateKeyTable({ name = "Resize Pane", one_shot = false }) },
	----------
	-- TABS --
	----------
	-- close tab
	{ key = "w", mods = "CMD|SHIFT", action = action.CloseCurrentTab({ confirm = true }) },
	-- new tab
	{ key = "t", mods = "CMD", action = action.SpawnTab("CurrentPaneDomain") },
	{ key = "t", mods = "CTRL|SHIFT", action = action.SpawnTab("CurrentPaneDomain") },
	-- navigate tabs
	{ key = "{", mods = "CTRL|SHIFT", action = action.ActivateTabRelative(-1) },
	{ key = "}", mods = "CTRL|SHIFT", action = action.ActivateTabRelative(1) },
	{ key = "t", mods = "LEADER", action = action.ShowTabNavigator },
	-- move tabs
	{ key = "m", mods = "CTRL|SHIFT", action = action.ActivateKeyTable({ name = "Move Tab", one_shot = false }) },
	----------------
	-- Workspaces --
	----------------
	{ key = "s", mods = "LEADER", action = action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "s",
		mods = "CTRL|SHIFT",
		action = action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new session" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						action.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
}

for i = 1, 9 do
	table.insert(config.keys, { key = tostring(i), mods = "CTRL|SHIFT", action = action.ActivateTab(i - 1) })
end

local copy_mode = nil
if wezterm.gui then
	copy_mode = wezterm.gui.default_key_tables().copy_mode
	table.insert(copy_mode, { key = "n", mods = "NONE", action = action.CopyMode("MoveLeft") })
	table.insert(copy_mode, { key = "e", mods = "NONE", action = action.CopyMode("MoveDown") })
	table.insert(copy_mode, { key = "i", mods = "NONE", action = action.CopyMode("MoveUp") })
	table.insert(copy_mode, { key = "o", mods = "NONE", action = action.CopyMode("MoveRight") })
	table.insert(copy_mode, { key = "j", mods = "NONE", action = action.CopyMode("MoveForwardWordEnd") })
	table.insert(copy_mode, { key = "k", mods = "NONE", action = action.CopyMode("MoveToSelectionOtherEnd") })
	table.insert(copy_mode, { key = "y", mods = "CTRL", action = action.CopyMode({ MoveByPage = 0.5 }) })
end

config.key_tables = {
	copy_mode = copy_mode,
	["Resize Pane"] = {
		-- fine
		{ key = "n", action = action.AdjustPaneSize({ "Left", 1 }) },
		{ key = "e", action = action.AdjustPaneSize({ "Down", 1 }) },
		{ key = "i", action = action.AdjustPaneSize({ "Up", 1 }) },
		{ key = "o", action = action.AdjustPaneSize({ "Right", 1 }) },
		-- medium
		{ key = "n", mods = "SHIFT", action = action.AdjustPaneSize({ "Left", 5 }) },
		{ key = "e", mods = "SHIFT", action = action.AdjustPaneSize({ "Down", 5 }) },
		{ key = "i", mods = "SHIFT", action = action.AdjustPaneSize({ "Up", 5 }) },
		{ key = "o", mods = "SHIFT", action = action.AdjustPaneSize({ "Right", 5 }) },
		-- coarse
		{ key = "n", mods = "CTRL", action = action.AdjustPaneSize({ "Left", 10 }) },
		{ key = "e", mods = "CTRL", action = action.AdjustPaneSize({ "Down", 10 }) },
		{ key = "i", mods = "CTRL", action = action.AdjustPaneSize({ "Up", 10 }) },
		{ key = "o", mods = "CTRL", action = action.AdjustPaneSize({ "Right", 10 }) },
		-- exit resize mode
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
	["Move Tab"] = {
		-- move tab
		{ key = "n", action = action.MoveTabRelative(-1) },
		{ key = "e", action = action.MoveTabRelative(-1) },
		{ key = "i", action = action.MoveTabRelative(1) },
		{ key = "o", action = action.MoveTabRelative(1) },
		-- exit move tab mode
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
}

return config
