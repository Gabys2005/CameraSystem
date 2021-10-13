return function()
	local copy = script.Frame:Clone()
	
	local focusBox = require(script.Parent.FocusBox)()
	focusBox.Parent = copy.FocusBox
	
	local categoryChooser = require(script.Parent.CategoryChooser)({
		Frames = {
			{
				Name = "Static",
				Frame = require(script.Parent.StaticCameras)(),
				ComponentName = "StaticCameras"
			},
			{
				Name = "Moving",
				Frame = require(script.Parent.MovingCameras)(),
				ComponentName = "MovingCameras"
			},
			{
				Name = "Drones",
				Frame = require(script.Parent.Blank)(),
				ComponentName = "Blank"
			}
		}
	})
	categoryChooser.Parent = copy.Cameras
	
	return copy
end