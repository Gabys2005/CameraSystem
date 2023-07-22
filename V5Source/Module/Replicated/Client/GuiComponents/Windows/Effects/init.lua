local basicComponents = script.Parent.Parent.Basic
local slider = require(basicComponents.DotSlider)
local button = require(basicComponents.ResponsiveButton)
local events = script.Parent.Parent.Parent.Parent.Events

return function()
	local copy = script.Frame:Clone()

	button({
		Name = "Blackout",
		Setting = "Shared.Effects.Blackout",
		Size = UDim2.new(0, 90, 0, 30),
		EventToFire = events.ChangeBlackout,
	}).Parent =
		copy.Buttons

	button({
		Name = "Bars",
		Setting = "Shared.Effects.BarsEnabled",
		Size = UDim2.new(0, 90, 0, 30),
		EventToFire = events.ChangeBarsEnabled,
	}).Parent =
		copy.Buttons

	slider({
		Name = "Fov",
		Min = 1,
		Max = 120,
		Round = 0,
		Default = 70,
		Setting = "Shared.Effects.Fov",
		EventToFire = events.ChangeFov,
	}).Parent =
		copy.Sliders.FovSlider

	slider({
		Name = "Blur",
		Min = 0,
		Max = 56,
		Round = 0,
		Default = 0,
		Setting = "Shared.Effects.Blur",
		EventToFire = events.ChangeBlur,
	}).Parent =
		copy.Sliders.BlurSlider

	slider({
		Name = "Saturation",
		Min = -1,
		Max = 1,
		Round = 2,
		Default = 0,
		Setting = "Shared.Effects.Saturation",
		EventToFire = events.ChangeSaturation,
	}).Parent =
		copy.Sliders.SaturationSlider

	slider({
		Name = "Tilt",
		Min = -90,
		Max = 90,
		Round = 0,
		Default = 0,
		Setting = "Shared.Effects.Tilt",
		EventToFire = events.ChangeTilt,
	}).Parent =
		copy.Sliders.TiltSlider

	slider({
		Name = "Shake",
		Min = 0,
		Max = 10,
		Round = 1,
		Default = 0,
		Setting = "Shared.Effects.Shake",
		EventToFire = events.ChangeShake,
	}).Parent =
		copy.Sliders.ShakeSlider

	return copy
end
