--!strict

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local main = script.Parent.Parent
local New = require(main.New)
local Types = require(main.Types)
local Component = require(main)
local consts = require(main.Parent.Parent.Shared.Constants)

local localPlayer = Players.LocalPlayer
local mouse = localPlayer and localPlayer:GetMouse()

local draggingFrameWidth = 5
local cornerDraggingFrameSize = 20

local Window = {}
Window.__index = Window

type WindowParams = {
	Title: string?,
	Visible: boolean?,
	Position: UDim2?,
	Size: UDim2?,
	MinSize: UDim2?,
	OnClose: (() -> any)?,
	VerticallyResizable: boolean?,
}

type Window = typeof(setmetatable(
	{} :: {
		Instance: Frame,
		TitleLabel: TextLabel,
		Topbar: Frame,
		Content: Frame,
		CloseButton: TextButton,
		Connections: { RBXScriptConnection },
	},
	Window
))

function Window.new(params: WindowParams)
	local self = setmetatable({}, Window)

	local size = params.Size or params.MinSize or UDim2.fromOffset(200, 300)
	local draggingFrames = {}
	local allowVerticalResizing = if params.VerticallyResizable ~= nil then params.VerticallyResizable else true

	local MINIMUM_WIDTH = if params.MinSize then params.MinSize.X.Offset else 100
	local MINIMUM_HEIGHT = if params.MinSize then params.MinSize.Y.Offset else 100

	local titleLabel = New("TextLabel", {
		Size = UDim2.new(1, -50, 1, 0),
		Font = Enum.Font.GothamBold,
		BackgroundTransparency = 1,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, New("UIPadding", { PaddingLeft = UDim.new(0, 10) }))

	local closeButton = New("TextButton", {
		Text = "X",
		Font = Enum.Font.GothamBlack,
		TextSize = 12,
		Size = UDim2.fromOffset(20, 20),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -5, 0, 5),
	}, New("UICorner", { CornerRadius = UDim.new(0, 5) }))

	local topbar = New("Frame", {
		Name = "Topbar",
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
	}, { titleLabel, closeButton })

	local content = New("Frame", {
		Name = "Content",
		Size = UDim2.new(1, -10, 1, -35),
		Position = UDim2.fromOffset(5, 30),
	}, {
		New("UICorner"),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 5),
			PaddingRight = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 5),
		}),
	})

	local mainFrame = New("Frame", {
		Size = size,
		Visible = false,
	}, { New("UICorner"), topbar, content })

	draggingFrames.Right = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, draggingFrameWidth, 1, -cornerDraggingFrameSize * 2),
		Position = UDim2.fromScale(1, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = mainFrame,
	})
	draggingFrames.Left = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, draggingFrameWidth, 1, -cornerDraggingFrameSize * 2),
		Position = UDim2.fromScale(0, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = mainFrame,
	})
	draggingFrames.Bottom = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -cornerDraggingFrameSize * 2, 0, draggingFrameWidth),
		Position = UDim2.fromScale(0.5, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = mainFrame,
	})
	draggingFrames.BottomLeft = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, cornerDraggingFrameSize, 0, cornerDraggingFrameSize),
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = mainFrame,
	})
	draggingFrames.BottomRight = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, cornerDraggingFrameSize, 0, cornerDraggingFrameSize),
		Position = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Parent = mainFrame,
	})

	self.TitleLabel = titleLabel
	self.Topbar = topbar
	self.Content = content
	self.CloseButton = closeButton

	self.Instance = mainFrame
	self.Connections = {}

	local dragging: boolean = false
	local dragStart: Vector3
	local startPos: UDim2
	local dragInput: InputObject

	local function update(input: InputObject)
		local delta = input.Position - dragStart
		mainFrame.Position =
			UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	table.insert(
		self.Connections,
		topbar.InputBegan:Connect(function(input: InputObject)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				dragging = true
				dragStart = input.Position
				startPos = mainFrame.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
	)

	table.insert(
		self.Connections,
		topbar.InputChanged:Connect(function(input: InputObject)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			then
				dragInput = input
			end
		end)
	)

	table.insert(
		self.Connections,
		UserInputService.InputChanged:Connect(function(input: InputObject)
			if input == dragInput and dragging then
				update(input)
			end
		end)
	)

	table.insert(
		self.Connections,
		closeButton.MouseButton1Click:Connect(function()
			mainFrame.Visible = false
			if params.OnClose then
				params.OnClose()
			end
		end)
	)

	self:SetTitle(params.Title or "Untitled")

	if params.Visible then
		mainFrame.Visible = true
	end
	if params.Position then
		mainFrame.Position = params.Position
	end

	-- Resizing
	local resizing = false
	local lastCursor = ""

	local function startResize(input: InputObject, side: string)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end
		local draggingResize = true
		resizing = true
		local startingPosition = input.Position
		local startingSize = mainFrame.Size
		local startingFramePosition = mainFrame.Position
		local stopDrag
		stopDrag = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingResize = false
				resizing = false
				mouse.Icon = lastCursor
				stopDrag:Disconnect()
			end
		end)

		while draggingResize do
			if side == "right" then
				local diff = UserInputService:GetMouseLocation().X - startingPosition.X
				mainFrame.Size =
					UDim2.fromOffset(math.max(startingSize.X.Offset + diff, MINIMUM_WIDTH), mainFrame.Size.Y.Offset)
			elseif side == "bottom" then
				local diff = UserInputService:GetMouseLocation().Y - startingPosition.Y
				mainFrame.Size = UDim2.fromOffset(
					mainFrame.Size.X.Offset,
					math.max(startingSize.Y.Offset + diff - consts.TOPBAR_SIZE, MINIMUM_HEIGHT)
				)
			elseif side == "left" then
				local diff = startingPosition.X - UserInputService:GetMouseLocation().X
				if startingSize.X.Offset + diff > MINIMUM_WIDTH then
					mainFrame.Size =
						UDim2.fromOffset(math.max(startingSize.X.Offset + diff, MINIMUM_WIDTH), mainFrame.Size.Y.Offset)
					mainFrame.Position =
						UDim2.fromOffset(UserInputService:GetMouseLocation().X, startingFramePosition.Y.Offset)
				end
			elseif side == "bottomleft" then
				local Xdiff = startingPosition.X - UserInputService:GetMouseLocation().X
				local Ydiff = UserInputService:GetMouseLocation().Y - startingPosition.Y
				if startingSize.X.Offset + Xdiff > MINIMUM_WIDTH then
					mainFrame.Size = UDim2.fromOffset(
						math.max(startingSize.X.Offset + Xdiff, MINIMUM_WIDTH),
						math.max(startingSize.Y.Offset + Ydiff - consts.TOPBAR_SIZE, MINIMUM_HEIGHT)
					)
					mainFrame.Position =
						UDim2.fromOffset(UserInputService:GetMouseLocation().X, startingFramePosition.Y.Offset)
				else
					mainFrame.Size = UDim2.fromOffset(
						startingSize.X.Offset,
						math.max(startingSize.Y.Offset + Ydiff - consts.TOPBAR_SIZE, MINIMUM_HEIGHT)
					)
				end
			elseif side == "bottomright" then
				local Xdiff = UserInputService:GetMouseLocation().X - startingPosition.X
				local Ydiff = UserInputService:GetMouseLocation().Y - startingPosition.Y
				mainFrame.Size = UDim2.fromOffset(
					math.max(startingSize.X.Offset + Xdiff, MINIMUM_WIDTH),
					math.max(startingSize.Y.Offset + Ydiff - consts.TOPBAR_SIZE, MINIMUM_HEIGHT)
				)
			end
			task.wait()
		end
	end

	draggingFrames.Right.InputBegan:Connect(function(input: InputObject)
		startResize(input, "right")
	end)
	draggingFrames.Right.MouseEnter:Connect(function()
		if not resizing then
			lastCursor = mouse.Icon
			mouse.Icon = consts.RESIZE_ICONS.HORIZONTAL
		end
	end)
	draggingFrames.Right.MouseLeave:Connect(function()
		if not resizing then
			mouse.Icon = ""
		end
	end)

	draggingFrames.Left.InputBegan:Connect(function(input: InputObject)
		startResize(input, "left")
	end)

	draggingFrames.Left.MouseEnter:Connect(function()
		if not resizing then
			lastCursor = mouse.Icon
			mouse.Icon = consts.RESIZE_ICONS.HORIZONTAL
		end
	end)
	draggingFrames.Left.MouseLeave:Connect(function()
		if not resizing then
			mouse.Icon = ""
		end
	end)

	if allowVerticalResizing then
		draggingFrames.Bottom.InputBegan:Connect(function(input: InputObject)
			startResize(input, "bottom")
		end)
		draggingFrames.Bottom.MouseEnter:Connect(function()
			if not resizing then
				lastCursor = mouse.Icon
				mouse.Icon = consts.RESIZE_ICONS.VERTICAL
			end
		end)
		draggingFrames.Bottom.MouseLeave:Connect(function()
			if not resizing then
				mouse.Icon = ""
			end
		end)

		draggingFrames.BottomLeft.InputBegan:Connect(function(input: InputObject)
			startResize(input, "bottomleft")
		end)
		draggingFrames.BottomLeft.MouseEnter:Connect(function()
			if not resizing then
				lastCursor = mouse.Icon
				mouse.Icon = consts.RESIZE_ICONS.BOTTOM_LEFT
			end
		end)
		draggingFrames.BottomLeft.MouseLeave:Connect(function()
			if not resizing then
				mouse.Icon = ""
			end
		end)

		draggingFrames.BottomRight.InputBegan:Connect(function(input: InputObject)
			startResize(input, "bottomright")
		end)
		draggingFrames.BottomRight.MouseEnter:Connect(function()
			if not resizing then
				lastCursor = mouse.Icon
				mouse.Icon = consts.RESIZE_ICONS.BOTTOM_RIGHT
			end
		end)
		draggingFrames.BottomRight.MouseLeave:Connect(function()
			if not resizing then
				mouse.Icon = ""
			end
		end)
	end

	Component.apply(self)
	return self
end

function Window.ApplyTheme(self: Window, theme: Types.Theme)
	self.TitleLabel.TextColor3 = theme.Text.Primary
	self.Instance.BackgroundColor3 = theme.Background.Dark
	self.Content.BackgroundColor3 = theme.Background.Primary
	self.CloseButton.BackgroundColor3 = theme.Buttons.Danger
	self.CloseButton.TextColor3 = theme.Text.Primary
end

function Window.SetTitle(self: Window, title: string)
	self.TitleLabel.Text = title
end

function Window.Destroy(self: Window)
	self.Instance:Destroy()
	for _, connection in self.Connections do
		connection:Disconnect()
	end
	Component.cleanup(self)
end

return Window
