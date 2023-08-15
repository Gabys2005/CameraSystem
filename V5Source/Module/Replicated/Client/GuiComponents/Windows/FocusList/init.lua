--!strict
local points = workspace:FindFirstChild("CameraSystem"):WaitForChild("FocusPoints")
local replicated = script.Parent.Parent.Parent.Parent

local main = script.Parent.Parent
local New = require(main.New)
local Types = require(main.Types)
local Component = require(main)

local Button = require(main.Basic.Button)
local SmoothGrid = require(main.Parent.Scripts.SmoothGrid)

local FocusListWindow = {}
FocusListWindow.__index = FocusListWindow

type FocusListWindow = typeof(setmetatable({} :: {
	Instance: Frame,
	Buttons: { any },
}, FocusListWindow))

function FocusListWindow.new()
	local self = setmetatable({}, FocusListWindow)
	self.Buttons = {}

	local grid = New("UIGridLayout", { CellSize = UDim2.new(0, 100, 0, 30), CellPadding = UDim2.fromOffset(7, 7) })

	local frame = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromOffset(0, 0),
		ScrollBarThickness = 5,
		BorderSizePixel = 0,
	}, {
		grid,
		New("UIPadding", {
			PaddingRight = UDim.new(0, 5),
			PaddingLeft = UDim.new(0, 2),
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2),
		}),
	})

	for _, point in points:GetChildren() do
		local button = Button.new({
			Text = point.Name,
			OnClick = function()
				if point:IsA("BasePart") then
					replicated.Events.ChangeFocus:FireServer(point)
				elseif point:IsA("ObjectValue") then
					replicated.Events.ChangeFocus:FireServer(point.Value)
				end
				return
			end,
		})
		button.Instance.Parent = frame
		table.insert(self.Buttons, button)
	end

	self.Instance = frame

	SmoothGrid(frame, grid)

	Component.apply(self)
	return self
end

function FocusListWindow.ApplyTheme() end

function FocusListWindow.Destroy(self: FocusListWindow)
	self.Instance:Destroy()
	for _, button in self.Buttons do
		button:Destroy()
	end
	Component.cleanup(self)
end

return FocusListWindow
