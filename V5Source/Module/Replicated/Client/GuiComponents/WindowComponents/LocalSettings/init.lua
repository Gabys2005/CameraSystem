--!strict

local main = script.Parent.Parent
local New = require(main.New)
local Component = require(main)
local Types = require(main.Types)

local DotSlider = require(main.Basic.DotSlider)
local Switch = require(main.Basic.Switch)

local LocalSettingsWindow = {}
LocalSettingsWindow.__index = LocalSettingsWindow

type LocalSettingsWindow = typeof(setmetatable({} :: { Instance: Frame, SwitchesFrame: Frame }, LocalSettingsWindow))

function LocalSettingsWindow.new()
	local self = setmetatable({}, LocalSettingsWindow)

	local mainFrame = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) }))

	local switchesFrame = New("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = mainFrame,
	}, {
		New("UICorner"),
		New("UIListLayout"),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
			PaddingRight = UDim.new(0, 5),
		}),
	})
	self.SwitchesFrame = switchesFrame

	local transparentOverlaysSwitch = Switch.new({
		Name = "Transparent overlays:",
		Setting = "Local.Settings.TransparentOverlays",
	})
	transparentOverlaysSwitch:SetParent(switchesFrame)

	local keybindsSwitch = Switch.new({
		Name = "Keybinds:",
		Setting = "Local.Settings.KeybindsEnabled",
	})
	keybindsSwitch:SetParent(switchesFrame)

	local droneSpeedSlider = DotSlider.new({
		Name = "Drone Speed",
		Min = 0,
		Max = 2,
		Round = 2,
		Default = 1,
		Setting = "Local.Settings.DroneSpeed",
	})
	droneSpeedSlider:SetParent(mainFrame)

	self.Instance = mainFrame
	Component.apply(self)
	return self
end

function LocalSettingsWindow.ApplyTheme(self: LocalSettingsWindow, theme: Types.Theme)
	self.SwitchesFrame.BackgroundColor3 = theme.Background.Dark
end

function LocalSettingsWindow.Destroy(self: LocalSettingsWindow)
	Component.cleanup(self)
	self.Instance:Destroy()
end

return LocalSettingsWindow
