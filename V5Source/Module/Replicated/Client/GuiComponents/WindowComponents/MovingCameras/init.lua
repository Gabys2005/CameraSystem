local util = require(script.Parent.Parent.Parent.Scripts.Other)
local cameras = workspace:FindFirstChild("CameraSystem").Cameras.Moving

return function()
	local copy = script.Moving:Clone()
	util:generateButtonsForFolder(cameras, copy.Frame, "Moving")
	copy.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- One day AutomaticCanvasSize will work...
		copy.CanvasSize = UDim2.new(0, 0, 0, copy.Frame.AbsoluteSize.Y)
	end)
	return copy
end
