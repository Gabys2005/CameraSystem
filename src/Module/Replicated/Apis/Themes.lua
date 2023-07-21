local ThemesApi = {}
local replicated = script.Parent.Parent
local ThemesData = require(replicated.Data.Themes)

ThemesApi.ThemeChanged = ThemesData.ThemeChanged
ThemesApi.ThemeAdded = ThemesData.ThemeAdded

function ThemesApi:AddTheme(name, themeData)
	ThemesData:Add(name, themeData)
end

function ThemesApi:GetCurrent()
	return ThemesData:Get()
end

function ThemesApi:GetCurrentName()
	return ThemesData:GetName()
end

function ThemesApi:GetAll()
	return ThemesData._themes
end

function ThemesApi:SetCurrent(name)
	ThemesData:SetCurrent(name)
end

return ThemesApi
