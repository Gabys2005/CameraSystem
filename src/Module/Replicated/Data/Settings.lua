local Settings = {}

export type Settings = {
	Admins: { string },
	FreeAdmin: "Disabled" | "PrivateServerOwner" | "Always",
	Theme: string,
}

local defaultSettings: Settings = {
	Admins = {},
	FreeAdmin = "Disabled",
	Theme = "Default",
}

Settings._settings = table.clone(defaultSettings)

function Settings:Get(setting: string)
	local settingValue = Settings._settings[setting]
	assert(settingValue, `[[ CameraSystem Settings ]]: Setting {setting} doesn't exist`) -- TODO: debug assert instead
	return settingValue
end

function Settings:Set(setting: string, value: any)
	assert(defaultSettings[setting], `[[ CameraSystem Settings ]]: Setting {setting} doesn't exist`)
	assert(
		typeof(defaultSettings[setting]) == typeof(value),
		`[[ CameraSystem Setting ]]: Setting {setting} uses incorrect type`
	)
	Settings._settings[setting] = value
end

function Settings:GetAll()
	return Settings._settings
end

function Settings:SetAll(settings: Settings)
	for settingName, settingValue in settings do
		Settings:Set(settingName, settingValue)
	end
end

return Settings
