local replicated = script.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)
local Theme = require(replicated.Data.Theme):Get()

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Spring = Fusion.Spring
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed

return function(props) -- TODO: types
	local isMinimised = Value(false)
	local isHoveringOverX = Value(false)
	local isHoveringOverMinimise = Value(false)

	local xButtonTransparency = Spring(
		Computed(function()
			return if isHoveringOverX:get() then 0 else 0.6
		end),
		25
	)

	local minimiseButtonTransparency = Spring(
		Computed(function()
			return if isHoveringOverMinimise:get() then 0 else 0.6
		end),
		25
	)

	local minimiseButtonRotation = Spring(
		Computed(function()
			return if isMinimised:get() then 0 else 180
		end),
		25
	)

	local contentPositionSpring = Spring(
		Computed(function()
			return if isMinimised:get() then UDim2.fromScale(0, -1) else UDim2.fromScale(0, 0)
		end),
		15
	)

	local function changeMinimise()
		isMinimised:set(not isMinimised:get())
	end

	local size = props.Size or UDim2.fromOffset(200, 200)

	local mainWindowSize = Spring(
		Computed(function()
			return if isMinimised:get() then UDim2.fromOffset(size.X.Offset, 30) else size
		end),
		15
	)

	return New "Frame" {
		Size = mainWindowSize,
		BackgroundColor3 = Theme.General.BackgroundDark,
		Position = UDim2.fromOffset(50, 50),

		[Children] = {
			New "UICorner" {},

			New "Frame" {
				Name = "Topbar",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 30),
				[Children] = {
					New "TextLabel" {
						Name = "WindowName",
						Size = UDim2.new(1, -55, 1, 0),
						Text = props.Name or "Window",
						TextXAlignment = Enum.TextXAlignment.Left,
						Font = Enum.Font.Gotham,
						BackgroundTransparency = 1,
						TextColor3 = Theme.Label.Text,
						[Children] = New "UIPadding" {
							PaddingBottom = UDim.new(0, 5),
							PaddingLeft = UDim.new(0, 15),
							PaddingRight = UDim.new(0, 5),
							PaddingTop = UDim.new(0, 5),
						},
					},
					New "TextButton" {
						Name = "CloseButton",
						Text = "X",
						Font = Enum.Font.GothamBlack,
						TextSize = 12,
						TextColor3 = Theme.Button.Text,
						Size = UDim2.fromOffset(20, 20),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -5, 0.5, 0),
						[Children] = New "UICorner" {
							CornerRadius = UDim.new(0, 5),
						},
						BackgroundTransparency = xButtonTransparency,
						BackgroundColor3 = Theme.Button.Error,
						[OnEvent "MouseEnter"] = function()
							isHoveringOverX:set(true)
						end,
						[OnEvent "MouseLeave"] = function()
							isHoveringOverX:set(false)
						end,
					},
					New "TextButton" {
						Name = "MinimiseButton",
						Size = UDim2.fromOffset(20, 20),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -30, 0.5, 0),
						BackgroundColor3 = Theme.Button.Primary,
						BackgroundTransparency = minimiseButtonTransparency,
						[Children] = {
							New "UICorner" {
								CornerRadius = UDim.new(0, 5),
							},
							New "ImageButton" {
								BackgroundTransparency = 1,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.5, 0.5),
								Image = "rbxassetid://12420015035",
								ScaleType = Enum.ScaleType.Fit,
								Rotation = minimiseButtonRotation,
								Size = UDim2.fromScale(0.6, 0.6),
								ImageColor3 = Theme.Button.Text,
								[OnEvent "Activated"] = changeMinimise,
							},
						},
						[OnEvent "Activated"] = changeMinimise,
						[OnEvent "MouseEnter"] = function()
							isHoveringOverMinimise:set(true)
						end,
						[OnEvent "MouseLeave"] = function()
							isHoveringOverMinimise:set(false)
						end,
					},
				},
			},

			New "Frame" {
				Name = "ContentContainer",
				Size = size - UDim2.fromOffset(10, 35),
				Position = UDim2.fromOffset(5, 30),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				[Children] = New "Frame" {
					Name = "Content",
					Size = UDim2.fromScale(1, 1),
					Position = contentPositionSpring,
					BackgroundColor3 = Theme.General.Background,
					[Children] = {
						New "UICorner" {
							CornerRadius = UDim.new(0, 5),
						},
						props[Children],
					},
				},
			},
		},
		Parent = props.Parent,
	}
end
