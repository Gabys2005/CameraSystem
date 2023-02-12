local DragFrames = require(script.Parent.Parent.DragFrames)
local replicated = script.Parent.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)

local New = Fusion.New
local Children = Fusion.Children

return function(target)
	local frame = New "Frame" {
		Size = UDim2.fromOffset(150, 150),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(0, 0, 255),

		[Children] = DragFrames {
			OnInput = function(input, direction)
				print(direction)
			end,
		},
		Parent = target,
	}

	return function()
		frame:Destroy()
	end
end
