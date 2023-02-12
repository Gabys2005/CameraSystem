local uis = game:GetService("UserInputService")
local players = game:GetService("Players")

local replicated = script.Parent.Parent
local playerGui = players.LocalPlayer.PlayerGui
local Fusion = require(replicated.Dependencies.Fusion)
local Theme = require(replicated.Data.Themes):GetFusion()
local FusionTypes = require(replicated.Dependencies.Fusion.PubTypes)
local DragFrames = require(script.Parent.DragFrames)

local New = Fusion.New
local Children = Fusion.Children
local Value = Fusion.Value
local Spring = Fusion.Spring
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed
local Cleanup = Fusion.Cleanup
local Ref = Fusion.Ref

local mouse = players.LocalPlayer:GetMouse()

export type WindowProps = {
	Parent: Instance,
	Visible: FusionTypes.CanBeState<boolean>,
	Title: FusionTypes.CanBeState<string>,
	Position: UDim2?,
	Size: UDim2?,
	OnClose: () -> any,
}

local function findFirstWindow(instances)
	for _, ins in instances do
		if ins.Name == "CameraSystemWindow" then
			return ins
		end
	end
end

return function(props: WindowProps)
	local resizing = nil
	local isMinimised = Value(false)
	local isHoveringOverX = Value(false)
	local isHoveringOverMinimise = Value(false)
	local windowPosition = Value(props.Position or UDim2.fromOffset(50, 50))
	local size = Value(props.Size or UDim2.fromOffset(200, 200))
	local thisWindow = Value()

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

	local mainWindowSizeComputed = Computed(function()
		return if isMinimised:get() then UDim2.fromOffset(size:get().X.Offset, 30) else size:get()
	end)

	local mainWindowSize = Spring(mainWindowSizeComputed, 15)

	local contentSizeComputed = Computed(function()
		return size:get() - UDim2.fromOffset(10, 35)
	end)

	local contentSize = Spring(contentSizeComputed, 15)

	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		if resizing == nil then
			local delta = input.Position - dragStart
			windowPosition:set(
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			)
		end
	end

	local function onInputBegan(input, processed)
		if processed then
			return
		end
		local guisAtThisPosition = playerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
		if findFirstWindow(guisAtThisPosition) ~= thisWindow:get() then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragStart = input.Position
			startPos = windowPosition:get()

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end

	local function onInputChanged(input, processed)
		if processed then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragInput = input
		end
	end

	local uisConnection = uis.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	-- Resizing

	-- TODO: change
	local ROBLOX_TOPBAR_SIZE = 36
	local MINIMUM_HEIGHT = size:get().X.Offset
	local MINIMUM_WIDTH = size:get().Y.Offset
	local lastCursor = mouse.Icon
	local function startResize(input: InputObject, side: string)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end
		local draggingResize = true
		resizing = true
		local startingPosition = input.Position
		local startingSize = size:get()
		local mouseOffset = input.Position.X - windowPosition:get().X.Offset
		local startingFramePosition = windowPosition:get()
		local stopDrag

		stopDrag = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingResize = false
				resizing = nil
				mouse.Icon = lastCursor
				stopDrag:Disconnect()
			end
		end)

		while draggingResize do
			if side == "right" then
				local diff = uis:GetMouseLocation().X - startingPosition.X
				size:set(UDim2.fromOffset(math.max(startingSize.X.Offset + diff, MINIMUM_WIDTH), startingSize.Y.Offset))
			elseif side == "bottom" and not isMinimised:get() then
				local diff = uis:GetMouseLocation().Y - startingPosition.Y
				size:set(
					UDim2.new(
						0,
						startingSize.X.Offset,
						0,
						math.max(startingSize.Y.Offset + diff - ROBLOX_TOPBAR_SIZE, MINIMUM_HEIGHT)
					)
				)
			elseif side == "left" then
				local diff = startingPosition.X - uis:GetMouseLocation().X
				if startingSize.X.Offset + diff > MINIMUM_WIDTH then
					size:set(
						UDim2.fromOffset(math.max(startingSize.X.Offset + diff, MINIMUM_WIDTH), startingSize.Y.Offset)
					)
					windowPosition:set(
						UDim2.fromOffset(uis:GetMouseLocation().X - mouseOffset, startingFramePosition.Y.Offset)
					)
				end
			elseif side == "bottomleft" then
				local Xdiff = startingPosition.X - uis:GetMouseLocation().X
				local Ydiff = uis:GetMouseLocation().Y - startingPosition.Y
				size:set(
					UDim2.new(
						0,
						math.max(startingSize.X.Offset + Xdiff, MINIMUM_WIDTH),
						0,
						if isMinimised:get()
							then startingSize.Y.Offset
							else math.max(startingSize.Y.Offset + Ydiff - ROBLOX_TOPBAR_SIZE, MINIMUM_HEIGHT)
					)
				)
				if startingSize.X.Offset + Xdiff > MINIMUM_WIDTH then
					windowPosition:set(
						UDim2.fromOffset(uis:GetMouseLocation().X - mouseOffset, startingFramePosition.Y.Offset)
					)
				end
			elseif side == "bottomright" then
				local Xdiff = uis:GetMouseLocation().X - startingPosition.X
				local Ydiff = uis:GetMouseLocation().Y - startingPosition.Y
				size:set(
					UDim2.new(
						0,
						math.max(startingSize.X.Offset + Xdiff, MINIMUM_WIDTH),
						0,
						if isMinimised:get()
							then startingSize.Y.Offset
							else math.max(startingSize.Y.Offset + Ydiff - ROBLOX_TOPBAR_SIZE, MINIMUM_HEIGHT)
					)
				)
			end
			mainWindowSize:setPosition(mainWindowSizeComputed:get())
			contentSize:setPosition(contentSizeComputed:get())
			task.wait()
		end
	end

	local function showIcon(iconString: string)
		if not resizing then
			lastCursor = mouse.Icon
			mouse.Icon = iconString
		end
	end

	local function hideIcon()
		if not resizing then
			mouse.Icon = ""
		end
	end

	return New("Frame") {
		Size = mainWindowSize,
		BackgroundColor3 = Theme.General.BackgroundDark,
		Position = windowPosition,
		Visible = props.Visible,
		Name = "CameraSystemWindow", -- TODO: custom names
		[Ref] = thisWindow,

		[Children] = {
			New("UICorner") {},
			DragFrames {
				OnInput = startResize,
				ShowIcon = showIcon,
				HideIcon = hideIcon,
			},

			New("Frame") {
				Name = "Topbar",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 30),
				[Children] = {
					New("TextLabel") {
						Name = "WindowName",
						Size = UDim2.new(1, -55, 1, 0),
						Text = props.Title,
						TextXAlignment = Enum.TextXAlignment.Left,
						Font = Enum.Font.Gotham,
						BackgroundTransparency = 1,
						TextColor3 = Theme.Label.Text,
						[Children] = New("UIPadding") {
							PaddingBottom = UDim.new(0, 5),
							PaddingLeft = UDim.new(0, 15),
							PaddingRight = UDim.new(0, 5),
							PaddingTop = UDim.new(0, 5),
						},
						[OnEvent("InputBegan")] = onInputBegan,
						[OnEvent("InputChanged")] = onInputChanged,
					},
					New("TextButton") {
						Name = "CloseButton",
						Text = "X",
						Font = Enum.Font.GothamBlack,
						TextSize = 12,
						TextColor3 = Theme.Button.Text,
						Size = UDim2.fromOffset(20, 20),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -5, 0.5, 0),
						[Children] = New("UICorner") {
							CornerRadius = UDim.new(0, 5),
						},
						BackgroundTransparency = xButtonTransparency,
						BackgroundColor3 = Theme.Button.Error,
						[OnEvent("MouseEnter")] = function()
							isHoveringOverX:set(true)
						end,
						[OnEvent("MouseLeave")] = function()
							isHoveringOverX:set(false)
						end,
						[OnEvent("Activated")] = props.OnClose,
					},
					New("TextButton") {
						Name = "MinimiseButton",
						Size = UDim2.fromOffset(20, 20),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -30, 0.5, 0),
						BackgroundColor3 = Theme.Button.Primary,
						BackgroundTransparency = minimiseButtonTransparency,
						[Children] = {
							New("UICorner") {
								CornerRadius = UDim.new(0, 5),
							},
							New("ImageButton") {
								BackgroundTransparency = 1,
								AnchorPoint = Vector2.new(0.5, 0.5),
								Position = UDim2.fromScale(0.5, 0.5),
								Image = "rbxassetid://12420015035",
								ScaleType = Enum.ScaleType.Fit,
								Rotation = minimiseButtonRotation,
								Size = UDim2.fromScale(0.6, 0.6),
								ImageColor3 = Theme.Button.Text,
								[OnEvent("Activated")] = changeMinimise,
							},
						},
						[OnEvent("Activated")] = changeMinimise,
						[OnEvent("MouseEnter")] = function()
							isHoveringOverMinimise:set(true)
						end,
						[OnEvent("MouseLeave")] = function()
							isHoveringOverMinimise:set(false)
						end,
					},
				},
			},

			New("Frame") {
				Name = "ContentContainer",
				Size = contentSize,
				Position = UDim2.fromOffset(5, 30),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				[Children] = New("Frame") {
					Name = "Content",
					Size = UDim2.fromScale(1, 1),
					Position = contentPositionSpring,
					BackgroundColor3 = Theme.General.Background,
					[Children] = {
						New("UICorner") {
							CornerRadius = UDim.new(0, 5),
						},
						New("UIPadding") {
							PaddingTop = UDim.new(0, 5),
							PaddingBottom = UDim.new(0, 5),
							PaddingRight = UDim.new(0, 5),
							PaddingLeft = UDim.new(0, 5),
						},
						props[Children],
					},
				},
			},
		},
		[Cleanup] = uisConnection,
		Parent = props.Parent,
	}
end
