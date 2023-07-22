local util = require(script.Parent.Parent.Parent.Scripts.Other)
local cameras = workspace:FindFirstChild("CameraSystem").Cameras.Static

return function()
	local copy = script.Static:Clone()
	util:generateButtonsForFolder(cameras, copy.Frame, "Static")
	copy.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- One day AutomaticCanvasSize will work...
		copy.CanvasSize = UDim2.new(0, 0, 0, copy.Frame.AbsoluteSize.Y)
	end)
	return copy
end
