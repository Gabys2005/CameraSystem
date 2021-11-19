local util = require(script.Parent.Parent.Parent.Scripts.Other)
local cameras = workspace:FindFirstChild("CameraSystem").Cameras.Static

return function()
	local copy = script.Static:Clone()
	util:generateButtonsForFolder(cameras, copy.Frame, "Static")
	return copy
end
