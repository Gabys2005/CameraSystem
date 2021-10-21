local UserInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local mouse = players.LocalPlayer:GetMouse()
local ICONS = {
	horizontal = "rbxassetid://7655080017",
	vertical = "rbxassetid://7655095494",
	bottomLeft = "rbxassetid://7655124995",
	bottomRight = "rbxassetid://7655117647",
}
local ROBLOX_TOPBAR_SIZE = 36
local TOPBAR_SIZE = 20

--// https://devforum.roblox.com/t/--/107689/5
return function(gui: GuiObject)
	-- Dragging
	local dragging: boolean
	local dragInput: InputObject
	local dragStart: Vector2
	local startPos: UDim2

	local function update(input: InputObject)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	gui.InputBegan:Connect(function(input: InputObject)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input: InputObject)
		if
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input: InputObject)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	-- Resizing
	local MINIMUM_HEIGHT = gui.Content.AbsoluteSize.Y
	local MINIMUM_WIDTH = gui.AbsoluteSize.X
	local resizing = nil
	local lastCursor = mouse.Icon
	local function startResize(input: InputObject, side: string)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end
		local draggingResize = true
		resizing = true
		local startingPosition = input.Position
		local startingSize = gui.Size
		local startingContentSize = gui.Content.Size
		local startingFramePosition = gui.Position
		local stopDrag = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingResize = false
				resizing = nil
				mouse.Icon = lastCursor
			end
		end)

		while draggingResize do
			if side == "right" then
				local diff = UserInputService:GetMouseLocation().X - startingPosition.X
				gui.Size = UDim2.fromOffset(math.max(startingSize.X.Offset + diff, MINIMUM_WIDTH), TOPBAR_SIZE)
			elseif side == "bottom" then
				local diff = UserInputService:GetMouseLocation().Y - startingPosition.Y
				gui.Content.Size = UDim2.new(
					1,
					0,
					0,
					math.max(startingContentSize.Y.Offset + diff - ROBLOX_TOPBAR_SIZE, MINIMUM_HEIGHT)
				)
			elseif side == "left" then
				local diff = startingPosition.X - UserInputService:GetMouseLocation().X
				if startingSize.X.Offset + diff > MINIMUM_WIDTH then
					gui.Size = UDim2.fromOffset(math.max(startingSize.X.Offset + diff, MINIMUM_WIDTH), TOPBAR_SIZE)
					gui.Position = UDim2.fromOffset(
						UserInputService:GetMouseLocation().X,
						startingFramePosition.Y.Offset
					)
				end
			elseif side == "bottomleft" then
				local Xdiff = startingPosition.X - UserInputService:GetMouseLocation().X
				local Ydiff = UserInputService:GetMouseLocation().Y - startingPosition.Y
				gui.Content.Size = UDim2.new(
					1,
					0,
					0,
					math.max(startingContentSize.Y.Offset + Ydiff - ROBLOX_TOPBAR_SIZE, MINIMUM_HEIGHT)
				)
				if startingSize.X.Offset + Xdiff > MINIMUM_WIDTH then
					gui.Size = UDim2.fromOffset(math.max(startingSize.X.Offset + Xdiff, MINIMUM_WIDTH), TOPBAR_SIZE)
					gui.Position = UDim2.fromOffset(
						UserInputService:GetMouseLocation().X,
						startingFramePosition.Y.Offset
					)
				end
			elseif side == "bottomright" then
				local Xdiff = UserInputService:GetMouseLocation().X - startingPosition.X
				local Ydiff = UserInputService:GetMouseLocation().Y - startingPosition.Y
				gui.Content.Size = UDim2.new(
					1,
					0,
					0,
					math.max(startingContentSize.Y.Offset + Ydiff - ROBLOX_TOPBAR_SIZE, MINIMUM_HEIGHT)
				)
				gui.Size = UDim2.fromOffset(math.max(startingSize.X.Offset + Xdiff, MINIMUM_WIDTH), TOPBAR_SIZE)
			end
			task.wait()
		end
	end

	-- There has to be a better way to do that
	gui.Content.Drag.Right.InputBegan:Connect(function(input: InputObject)
		startResize(input, "right")
	end)
	gui.Content.Drag.Right.MouseEnter:Connect(function()
		if not resizing then
			lastCursor = mouse.Icon
			mouse.Icon = ICONS.horizontal
		end
	end)
	gui.Content.Drag.Right.MouseLeave:Connect(function()
		if not resizing then
			mouse.Icon = ""
		end
	end)

	gui.Content.Drag.Left.InputBegan:Connect(function(input: InputObject)
		startResize(input, "left")
	end)

	gui.Content.Drag.Left.MouseEnter:Connect(function()
		if not resizing then
			lastCursor = mouse.Icon
			mouse.Icon = ICONS.horizontal
		end
	end)
	gui.Content.Drag.Left.MouseLeave:Connect(function()
		if not resizing then
			mouse.Icon = ""
		end
	end)

	gui.Content.Drag.Bottom.InputBegan:Connect(function(input: InputObject)
		startResize(input, "bottom")
	end)
	gui.Content.Drag.Bottom.MouseEnter:Connect(function()
		if not resizing then
			lastCursor = mouse.Icon
			mouse.Icon = ICONS.vertical
		end
	end)
	gui.Content.Drag.Bottom.MouseLeave:Connect(function()
		if not resizing then
			mouse.Icon = ""
		end
	end)

	gui.Content.Drag.BottomLeft.InputBegan:Connect(function(input: InputObject)
		startResize(input, "bottomleft")
	end)
	gui.Content.Drag.BottomLeft.MouseEnter:Connect(function()
		if not resizing then
			lastCursor = mouse.Icon
			mouse.Icon = ICONS.bottomLeft
		end
	end)
	gui.Content.Drag.BottomLeft.MouseLeave:Connect(function()
		if not resizing then
			mouse.Icon = ""
		end
	end)

	gui.Content.Drag.BottomRight.InputBegan:Connect(function(input: InputObject)
		startResize(input, "bottomright")
	end)
	gui.Content.Drag.BottomRight.MouseEnter:Connect(function()
		if not resizing then
			lastCursor = mouse.Icon
			mouse.Icon = ICONS.bottomRight
		end
	end)
	gui.Content.Drag.BottomRight.MouseLeave:Connect(function()
		if not resizing then
			mouse.Icon = ""
		end
	end)
end
