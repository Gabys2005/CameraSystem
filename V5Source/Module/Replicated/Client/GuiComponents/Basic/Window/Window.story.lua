--!strict

local Window = require(script.Parent)

return function(target)
	local window = Window.new({
		Title = "Title Test",
		Visible = true,
		Position = UDim2.fromOffset(100, 50),
		Size = UDim2.fromOffset(500, 200),
	})
	window.Instance.Parent = target
	return function()
		window:Destroy()
	end
end
