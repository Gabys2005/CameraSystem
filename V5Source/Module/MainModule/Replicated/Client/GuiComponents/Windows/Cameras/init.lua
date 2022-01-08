local basicComponents = script.Parent.Parent.Basic
local windowComponents = script.Parent.Parent.WindowComponents

return function()
	local copy = script.Frame:Clone()

	local focusBox = require(windowComponents.FocusBox)()
	focusBox.Parent = copy.FocusBox

	local categoryChooser = require(basicComponents.CategoryChooser)({
		Frames = {
			{
				Name = "Static",
				Frame = require(windowComponents.StaticCameras)(),
				ComponentName = "StaticCameras",
			},
			{
				Name = "Moving",
				Frame = require(windowComponents.MovingCameras)(),
				ComponentName = "MovingCameras",
			},
			{
				Name = "Drones",
				Frame = require(windowComponents.Drones)(),
				ComponentName = "Drones",
			},
		},
	})
	categoryChooser.Parent = copy.Cameras

	return copy
end
