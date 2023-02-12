local Window = require(script.Parent.Parent.Window)
local replicated = script.Parent.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)

local Children = Fusion.Children
local New = Fusion.New

return function(target)
	local blackFrame = New "Frame" {
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		Size = UDim2.fromScale(1, 1),
		Parent = target,
	}

	local window = Window {
		Parent = target,
		Title = "Window",
		[Children] = New "TextLabel" {
			Size = UDim2.fromOffset(50, 50),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
		},
	}

	return function()
		blackFrame:Destroy()
		window:Destroy()
	end
end
