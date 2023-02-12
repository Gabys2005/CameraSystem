local ThemesApi = {}
local ThemesData = require(script.Parent.Parent.Data.Themes)

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
