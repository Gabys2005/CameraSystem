--!strict
local main = script.Parent.Parent
local New = require(main.New)
local Types = require(main.Types)
local Component = require(main)

local Button = {}
Button.__index = Button

type ButtonParams = {
	Text: string,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	OnClick: (() -> any)?,
	OnRightClick: (() -> any)?,
	Parent: Instance?,
}

export type Button = typeof(setmetatable(
	{} :: {
		Instance: TextButton,
		Stroke: UIStroke,
		Connections: { RBXScriptConnection },
	},
	Button
))

function Button.new(params: ButtonParams)
	local self = setmetatable({}, Button)
	self.Connections = {}

	local stroke = New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 1.5,
	})

	local button = New("TextButton", {
		Text = params.Text,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextWrapped = true,
		Size = params.Size or UDim2.fromOffset(100, 30),
	}, { New("UICorner"), stroke })

	self.Instance = button
	self.Stroke = stroke

	if params.Position then
		button.Position = params.Position
	end
	if params.AnchorPoint then
		button.AnchorPoint = params.AnchorPoint
	end

	if params.OnClick then
		table.insert(self.Connections, button.MouseButton1Click:Connect(params.OnClick))
	end

	if params.OnRightClick then
		table.insert(self.Connections, button.MouseButton2Click:Connect(params.OnRightClick))
	end

	if params.Parent then
		button.Parent = params.Parent
	end

	Component.apply(self)
	return self
end

function Button.ApplyTheme(self: Button, theme: Types.Theme)
	self.Instance.BackgroundColor3 = theme.Buttons.Primary.Background
	self.Stroke.Color = theme.Buttons.Primary.Border
	self.Instance.TextColor3 = theme.Text.Primary
end

function Button.SetBackgroundColor(self: Button, color: Color3)
	self.Instance.BackgroundColor3 = color
end

function Button.Destroy(self: Button)
	self.Instance:Destroy()
	for _, connection in self.Connections do
		connection:Disconnect()
	end
	Component.cleanup(self)
end

return Button
