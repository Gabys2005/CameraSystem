local Settings = {}

Settings._settings = {
	Admins = {},
}

function Settings:Get(setting: string)
	local settingValue = Settings._settings[setting]
	assert(settingValue, `[[ CameraSystem Settings ]]: Setting {setting} doesn't exist`) -- TODO: debug assert instead
	return settingValue
end

function Settings:Set(setting: string, value: any)
	Settings._settings[setting] = value
end

function Settings:GetAll()
	return Settings._settings
end

function Settings:SetAll(settings: any)
	-- TODO: check if correct and add types
	Settings._settings = settings
end

return Settings
