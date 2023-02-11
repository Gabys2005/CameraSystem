local replicated = script.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

local dragHandleWidth = 10
local cornerHandleSize = 15
local doubleCornerHandleSize = cornerHandleSize * 2
local centerAnchor = Vector2.new(0.5, 0.5)

local ICONS = {
	horizontal = "rbxassetid://12453553297",
	vertical = "rbxassetid://12453567771",
	bottomLeft = "rbxassetid://12453582472",
	bottomRight = "rbxassetid://12453591047",
}

local horizontalSize = UDim2.new(1, -doubleCornerHandleSize, 0, dragHandleWidth)
local verticalSize = UDim2.new(0, dragHandleWidth, 1, -doubleCornerHandleSize)
local cornerSize = UDim2.fromOffset(cornerHandleSize * 3 / 2, cornerHandleSize * 3 / 2)

export type DragFramesProps = {
	OnInput: (InputObject, string) -> any,
	ShowIcon: (string) -> any,
	HideIcon: () -> (),
}

return function(props: DragFramesProps)
	return New "Frame" {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[Children] = {
			New "Frame" {
				AnchorPoint = centerAnchor,
				Position = UDim2.fromScale(0.5, 0),
				Size = horizontalSize,
				BackgroundTransparency = 1,
				Name = "TopCenter",
				[OnEvent "InputBegan"] = function(input)
					props.OnInput(input, "top")
				end,
			},
			New "Frame" {
				AnchorPoint = centerAnchor,
				Position = UDim2.fromScale(1, 0.5),
				Size = verticalSize,
				BackgroundTransparency = 1,
				Name = "MiddleRight",
				[OnEvent "InputBegan"] = function(input)
					props.OnInput(input, "right")
				end,
				[OnEvent "MouseEnter"] = function()
					props.ShowIcon(ICONS.horizontal)
				end,
				[OnEvent "MouseLeave"] = function()
					props.HideIcon()
				end,
			},
			New "Frame" {
				AnchorPoint = centerAnchor,
				Position = UDim2.fromScale(0.5, 1),
				Size = horizontalSize,
				BackgroundTransparency = 1,
				Name = "BottomCenter",
				[OnEvent "InputBegan"] = function(input)
					props.OnInput(input, "bottom")
				end,
				[OnEvent "MouseEnter"] = function()
					props.ShowIcon(ICONS.vertical)
				end,
				[OnEvent "MouseLeave"] = function()
					props.HideIcon()
				end,
			},
			New "Frame" {
				AnchorPoint = centerAnchor,
				Position = UDim2.fromScale(0, 0.5),
				Size = verticalSize,
				BackgroundTransparency = 1,
				Name = "MiddleLeft",
				[OnEvent "InputBegan"] = function(input)
					props.OnInput(input, "left")
				end,
				[OnEvent "MouseEnter"] = function()
					props.ShowIcon(ICONS.horizontal)
				end,
				[OnEvent "MouseLeave"] = function()
					props.HideIcon()
				end,
			},

			New "Frame" {
				BackgroundTransparency = 1,
				AnchorPoint = centerAnchor,
				Position = UDim2.fromScale(0, 0),
				Size = cornerSize,
				Name = "TopLeft",
			},
			New "Frame" {
				BackgroundTransparency = 1,
				AnchorPoint = centerAnchor,
				Position = UDim2.fromScale(1, 0),
				Size = cornerSize,
				Name = "TopRight",
			},
			New "Frame" {
				BackgroundTransparency = 1,
				AnchorPoint = centerAnchor,
				Position = UDim2.fromScale(0, 1),
				Size = cornerSize,
				Name = "BottomLeft",
				[OnEvent "InputBegan"] = function(input)
					props.OnInput(input, "bottomleft")
				end,
				[OnEvent "MouseEnter"] = function()
					props.ShowIcon(ICONS.bottomLeft)
				end,
				[OnEvent "MouseLeave"] = function()
					props.HideIcon()
				end,
			},
			New "Frame" {
				BackgroundTransparency = 1,
				AnchorPoint = centerAnchor,
				Position = UDim2.fromScale(1, 1),
				Size = cornerSize,
				Name = "BottomRight",
				[OnEvent "InputBegan"] = function(input)
					props.OnInput(input, "bottomright")
				end,
				[OnEvent "MouseEnter"] = function()
					props.ShowIcon(ICONS.bottomRight)
				end,
				[OnEvent "MouseLeave"] = function()
					props.HideIcon()
				end,
			},
		},
	}
end
