--!strict

local RunService = game:GetService("RunService")
local Types = require(script.Types)
local theme

if RunService:IsRunning() then
	theme = require(script.Parent.Themes.Current)
else
	theme = require(script.Parent.Themes.Dark)
end

local componentsToUpdate = {}

local function apply(component: any)
	componentsToUpdate[component] = true
	component:ApplyTheme(theme)
end

local function cleanup(component: any)
	componentsToUpdate[component] = nil
end

local function getTheme(): Types.Theme
	return theme
end

return {
	apply = apply,
	cleanup = cleanup,
	getTheme = getTheme,
}
