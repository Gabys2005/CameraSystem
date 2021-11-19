local basicComponents = script.Parent.Parent.Basic
local windowComponents = script.Parent.Parent.WindowComponents

return function()
	local copy = script.Frame:Clone()

	local categoryChooser = require(basicComponents.CategoryChooser)({
		Frames = {
			{
				Name = "Local",
				Frame = require(windowComponents.LocalSettings)(),
				ComponentName = "LocalSettings",
			},
			{
				Name = "Global",
				Frame = require(windowComponents.GlobalSettings)(),
				ComponentName = "GlobalSettings",
			},
		},
	})
	categoryChooser.Parent = copy

	return copy
end
