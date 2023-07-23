local run = game:GetService("RunService")
local theme

if run:IsRunning() then
	theme = require(script.Parent.Themes.Current)
else
	theme = require(script.Parent.Themes.Dark)
end

local componentsToUpdate = {}

local function apply(component)
	componentsToUpdate[component] = true
	component:ApplyTheme(theme)
end

local function cleanup(component)
	componentsToUpdate[component] = nil
end

return {
	apply = apply,
	cleanup = cleanup,
}
