local util = require(script.Parent.Parent.Scripts.Other)
local cameras = workspace:FindFirstChild("CameraSystem").Cameras.Moving

return function()
	local copy = script.Moving:Clone()
	util:generateButtonsForFolder(cameras,copy.Frame,"Moving")
	return copy
end