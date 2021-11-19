local slider = require(script.Parent.DotSlider)
local button = require(script.Parent.ResponsiveButton)

return function()
	local copy = script.Frame:Clone()

	button({
		Name = "Blackout",
		Setting = "Shared.Effects.Blackout",
		Size = UDim2.new(0, 90, 0, 30),
		EventToFire = script.Parent.Parent.Parent.Events.ChangeBlackout,
	}).Parent =
		copy.Buttons

	button({
		Name = "Bars",
		Setting = "Shared.Effects.BarsEnabled",
		Size = UDim2.new(0, 90, 0, 30),
		EventToFire = script.Parent.Parent.Parent.Events.ChangeBarsEnabled,
	}).Parent =
		copy.Buttons

	slider({
		Name = "Fov",
		Min = 1,
		Max = 120,
		Round = 0,
		Default = 70,
		Setting = "Shared.Effects.Fov",
		EventToFire = script.Parent.Parent.Parent.Events.ChangeFov,
	}).Parent =
		copy.Sliders.FovSlider

	slider({
		Name = "Blur",
		Min = 0,
		Max = 56,
		Round = 0,
		Default = 0,
		Setting = "Shared.Effects.Blur",
		EventToFire = script.Parent.Parent.Parent.Events.ChangeBlur,
	}).Parent =
		copy.Sliders.BlurSlider

	slider({
		Name = "Saturation",
		Min = -1,
		Max = 1,
		Round = 2,
		Default = 0,
		Setting = "Shared.Effects.Saturation",
		EventToFire = script.Parent.Parent.Parent.Events.ChangeSaturation,
	}).Parent =
		copy.Sliders.SaturationSlider

	slider({
		Name = "Tilt",
		Min = -90,
		Max = 90,
		Round = 0,
		Default = 0,
		Setting = "Shared.Effects.Tilt",
		EventToFire = script.Parent.Parent.Parent.Events.ChangeTilt,
	}).Parent =
		copy.Sliders.TiltSlider

	return copy
end
