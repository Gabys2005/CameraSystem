return function()
	local copy = script.Frame:Clone()
	
	local categoryChooser = require(script.Parent.CategoryChooser)({
		Frames = {
			{
				Name = "Local",
				Frame = require(script.Parent.LocalSettings)(),
				ComponentName = "LocalSettings"
			},
			{
				Name = "Global",
				Frame = require(script.Parent.GlobalSettings)(),
				ComponentName = "GlobalSettings"
			}
		}
	})
	categoryChooser.Parent = copy
	
	return copy
end