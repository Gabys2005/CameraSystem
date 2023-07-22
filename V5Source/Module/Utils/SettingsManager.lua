--!strict

local Types = require(script.Parent.Parent.Types)

type IndividualTemplate = {
	Default: any,
	Table: boolean?,
	Type: string?,
	Values: { any }?,
}

type SettingsTemplate = { [string]: IndividualTemplate }

local SettingsTemplate: SettingsTemplate = {

	GuiOwners = {
		Type = "string",
		Default = {},
		Table = true,
	},

	Theme = {
		Values = { "Light", "Dark" }, -- TODO: consts module
		Default = "Dark",
	},

	AccelerateStart = {
		Type = "boolean",
		Default = true,
	},

	DecelerateEnd = {
		Type = "boolean",
		Default = true,
	},

	ToggleGui = {
		Type = "string",
		Default = {},
		Table = true,
	},

	WatchButtonPosition = {
		Values = { "Left", "Center", "Right" },
		Default = "Center",
	},

	ControlButtonPosition = {
		Values = { "Left", "Center", "Right" },
		Default = "Left",
	},

	Keybinds = {
		Type = "table",
		Default = {},
		Table = true,
	},

	BarsOffset = {
		Type = "table",
		Default = {
			Players = {},
			Offset = 36,
		},
	},

	BeforeLoad = {
		Type = "function",
		Default = function() end,
	},

	FreeAdmin = {
		Values = { "None", "Owners", "All" },
		Default = "None",
	},

	LogActions = {
		Type = "boolean",
		Default = false,
	},
}

local function FixSettings(SettingsTable: { [any]: any })
	for settingName, settingData in SettingsTemplate do
		local value = SettingsTable[settingName]

		if value == nil then
			warn(
				`[[ CameraSystem ]]: Setting {settingName} is missing. Using default ({tostring(settingData.Default)})`
			)
			SettingsTable[settingName] = settingData.Default
			continue
		end

		if settingData.Table then
			if typeof(value) ~= "table" then
				warn(`[[ CameraSystem ]]: Setting {settingName} should be a table. Using default value instead`)
				SettingsTable[settingName] = settingData.Default
				continue
			end

			if settingData.Type then
				for i = #value, 1, -1 do
					local v = value[i]
					if typeof(v) ~= settingData.Type then
						warn(
							`[[ CameraSystem ]]: Setting {settingName} should be a table of {settingData.Type}s. Removing {tostring(v)} to ensure nothing breaks`
						)
						table.remove(SettingsTable[settingName], i)
					end
				end
			end
		else
			if settingData.Type then
				if typeof(value) ~= settingData.Type then
					warn(
						`[[ CameraSystem ]]: Setting {settingName} should be a {settingData.Type}. Using default instead`
					)
					SettingsTable[settingName] = settingData.Default
					continue
				end
			elseif settingData.Values then
				if not table.find(settingData.Values, value) then
					warn(
						`[[ CameraSystem ]]: Setting {settingName} is not one of allowed values. Using default instead`
					)
					SettingsTable[settingName] = settingData.Default
					continue
				end
			end
		end
	end

	-- Setting specific stuff
	for _, admin in SettingsTable.GuiOwners do
		if string.find(admin, ",") then
			-- TODO: show this in a popup
			warn(
				`[[ CameraSystem ]]: GuiOwner "{admin}" seems to have a comma in it, that's probably not intended. Each GuiOwner should be in separate quotes, and the quotes should be separated by commas`
			)
		end
	end

	-- TODO: fix Keybinds and BarsOffset
end

local function GetDefaultSettings(): Types.Settings
	local Settings = {}
	for name, data in SettingsTemplate do
		Settings[name] = data.Default
	end
	return Settings
end

return {
	FixSettings = FixSettings,
	GetDefaultSettings = GetDefaultSettings,
}
