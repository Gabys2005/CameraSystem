--!strict
local TweenService = game:GetService("TweenService")

local main = script.Parent.Parent
local New = require(main.New)
local Types = require(main.Types)
local Component = require(main)

local Label = require(main.Basic.Label)

local data = require(main.Parent.Scripts.UpdateData)

local Switch = {}
Switch.__index = Switch

type SwitchParams = {
	Name: string,
	Checked: boolean?,
	Setting: string,
	EventToFire: RemoteEvent?,
}

export type Switch = typeof(setmetatable(
	{} :: {
		Instance: Frame,
		SwitchBackground: TextButton,
		Dot: Frame,
		Label: Label.Label,
		Connection: RBXScriptConnection,
	},
	Switch
))

function Switch.new(params: SwitchParams)
	local self = setmetatable({}, Switch)

	local mainFrame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
	})

	local label = Label.new({
		Text = params.Name,
		Size = UDim2.fromScale(0.7, 1),
		Align = "Right",
	})
	label:SetParent(mainFrame)
	self.Label = label

	local switchMain = New("TextButton", {
		Position = UDim2.new(0.7, 5, 0.5, 0),
		Size = UDim2.fromScale(1, 0.7),
		AnchorPoint = Vector2.new(0, 0.5),
		Text = "",
		Parent = mainFrame,
	}, {
		New("UICorner", { CornerRadius = UDim.new(1, 0) }),
		New("UIAspectRatioConstraint", { AspectRatio = 2, DominantAxis = Enum.DominantAxis.Height }),
	})
	self.SwitchBackground = switchMain

	local dot = New("Frame", {
		Position = UDim2.fromScale(0.05, 0.5),
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.fromScale(1, 0.7),
		Parent = switchMain,
	}, {
		New("UIAspectRatioConstraint", { AspectRatio = 1 }),
		New("UICorner", { CornerRadius = UDim.new(1, 0) }),
	})
	self.Dot = dot

	local function updateDot()
		local isActive = data:get(params.Setting)
		local position = if isActive then UDim2.fromScale(0.95, 0.5) else UDim2.fromScale(0.05, 0.5)
		local anchorPoint = if isActive then Vector2.new(1, 0.5) else Vector2.new(0, 0.5)
		TweenService:Create(dot, TweenInfo.new(0.2), { Position = position, AnchorPoint = anchorPoint }):Play()
	end
	updateDot()
	self.Connection = switchMain.MouseButton1Click:Connect(function()
		local newval = not data:get(params.Setting)
		if params.EventToFire then
			params.EventToFire:FireServer(newval)
		else
			data:set(params.Setting, not data:get(params.Setting))
		end
	end)
	data:onChange(params.Setting, updateDot)

	self.Instance = mainFrame

	Component.apply(self)
	return self
end

function Switch.ApplyTheme(self: Switch, theme: Types.Theme)
	self.SwitchBackground.BackgroundColor3 = theme.Buttons.Primary.Background
	self.Dot.BackgroundColor3 = theme.Buttons.Primary.Selected
end

function Switch.SetParent(self: Switch, newParent: Instance)
	self.Instance.Parent = newParent
end

function Switch.Destroy(self: Switch)
	Component.cleanup(self)
	self.Instance:Destroy()
	self.Label:Destroy()
	self.Connection:Disconnect()
end

return Switch
