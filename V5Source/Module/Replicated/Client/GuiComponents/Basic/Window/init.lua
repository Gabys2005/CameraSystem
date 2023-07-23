--!strict

local UserInputService = game:GetService("UserInputService")

local main = script.Parent.Parent
local New = require(main.New)
local Types = require(main.Types)
local Component = require(main)

local Window = {}
Window.__index = Window

type WindowParams = {
	Title: string?,
	Visible: boolean?,
	Position: UDim2?,
	Size: UDim2?,
	MinSize: UDim2?,
	OnClose: (() -> any)?,
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
	}, { New("UICorner") })

	local mainFrame = New("Frame", {
		Size = size,
		Visible = false,
	}, { New("UICorner"), topbar, content })

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

	Component.apply(self)
	return self
end

function Window.ApplyTheme(self: Window, theme: Types.Theme)
	self.TitleLabel.TextColor3 = theme.BaseText
	self.Instance.BackgroundColor3 = theme.BaseBorder
	self.Content.BackgroundColor3 = theme.BaseDarker
	self.CloseButton.BackgroundColor3 = theme.RedButton
	self.CloseButton.TextColor3 = theme.BaseText
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
