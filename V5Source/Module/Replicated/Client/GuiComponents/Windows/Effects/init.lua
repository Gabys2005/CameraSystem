--!strict
local events = script.Parent.Parent.Parent.Parent.Events

local main = script.Parent.Parent

local Component = require(main)
local New = require(main.New)
local Types = require(main.Types)

local ResponsiveButton = require(main.Basic.ResponsiveButton)
local DotSlider = require(main.Basic.DotSlider)

local EffectsWindow = {}
EffectsWindow.__index = EffectsWindow

type EffectsWindow = typeof(setmetatable(
	{} :: {
		Instance: ScrollingFrame,
		ButtonsFrame: Frame,
		Buttons: { ResponsiveButton.ResponsiveButton },
		Sliders: { DotSlider.DotSlider },
	},
	EffectsWindow
))

local BUTTON_SIZE = UDim2.fromOffset(90, 30)

function EffectsWindow.new()
	local self = setmetatable({}, EffectsWindow)
	self.Buttons = {}
	self.Sliders = {}

	local frame = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		ScrollBarThickness = 5,
		CanvasSize = UDim2.fromOffset(0, 0),
	}, {
		New("UIListLayout", { Padding = UDim.new(0, 10) }),
		New("UIPadding", {
			PaddingTop = UDim.new(0, 2), -- Prevents the outline of top buttons from getting cut off
			PaddingBottom = UDim.new(0, 10), -- Prevents the bottom of the last slider from getting cut off
		}),
	})
	self.Instance = frame

	local buttonsFrame = New("Frame", {
		Name = "Buttons",
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundTransparency = 0,
		Parent = frame,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),
		New("UICorner", { CornerRadius = UDim.new(0, 8) }),
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
		}),
	})
	self.ButtonsFrame = buttonsFrame

	local blackoutButton = ResponsiveButton.new({
		Text = "Blackout",
		Size = BUTTON_SIZE,
		Setting = "Shared.Effects.Blackout",
		EventToFire = events.ChangeBlackout,
	})
	blackoutButton:SetParent(buttonsFrame)
	table.insert(self.Buttons, blackoutButton)

	local barsButton = ResponsiveButton.new({
		Text = "Bars",
		Size = BUTTON_SIZE,
		Setting = "Shared.Effects.BarsEnabled",
		EventToFire = events.ChangeBarsEnabled,
	})
	barsButton:SetParent(buttonsFrame)
	table.insert(self.Buttons, barsButton)

	local fovSlider = DotSlider.new({
		Name = "Zoom",
		Min = 1,
		Max = 120,
		Round = 0,
		Default = 70,
		Setting = "Shared.Effects.Fov",
		EventToFire = events.ChangeFov,
	})
	fovSlider:SetParent(frame)
	table.insert(self.Sliders, fovSlider)

	local blurSlider = DotSlider.new({
		Name = "Blur",
		Min = 0,
		Max = 56,
		Round = 0,
		Default = 0,
		Setting = "Shared.Effects.Blur",
		EventToFire = events.ChangeBlur,
	})
	blurSlider:SetParent(frame)
	table.insert(self.Sliders, blurSlider)

	local saturationSlider = DotSlider.new({
		Name = "Saturation",
		Min = -1,
		Max = 1,
		Round = 2,
		Default = 0,
		Setting = "Shared.Effects.Saturation",
		EventToFire = events.ChangeSaturation,
	})
	saturationSlider:SetParent(frame)
	table.insert(self.Sliders, saturationSlider)

	local tiltSlider = DotSlider.new({
		Name = "Tilt",
		Min = -180,
		Max = 180,
		Round = 0,
		Default = 0,
		Setting = "Shared.Effects.Tilt",
		EventToFire = events.ChangeTilt,
	})
	tiltSlider:SetParent(frame)
	table.insert(self.Sliders, tiltSlider)

	local shakeSlider = DotSlider.new({
		Name = "Shake",
		Min = 0,
		Max = 10,
		Round = 1,
		Default = 0,
		Setting = "Shared.Effects.Shake",
		EventToFire = events.ChangeShake,
	})
	shakeSlider:SetParent(frame)
	table.insert(self.Sliders, shakeSlider)

	Component.apply(self)
	return self
end

function EffectsWindow.ApplyTheme(self: EffectsWindow, theme: Types.Theme)
	self.Instance.ScrollBarImageColor3 = theme.Buttons.Primary.Border
	self.ButtonsFrame.BackgroundColor3 = theme.Background.Dark
end

function EffectsWindow.Destroy(self: EffectsWindow)
	for _, button in self.Buttons do
		button:Destroy()
	end
	for _, slider in self.Sliders do
		slider:Destroy()
	end
	Component.cleanup(self)
end

return EffectsWindow
