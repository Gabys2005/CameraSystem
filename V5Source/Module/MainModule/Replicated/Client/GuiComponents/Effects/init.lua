local slider = require(script.Parent.DotSlider)

return function()
	local copy = script.Frame:Clone()

	slider({
		Name = "Fov",
		Min = 1,
		Max = 120,
		Round = 0,
		Default = 70,
		Setting = "Shared.Effects.Fov",
		EventToFire = script.Parent.Parent.Parent.Events.ChangeFov,
	}).Parent =
		copy.FovSlider

	slider({
		Name = "Blur",
		Min = 0,
		Max = 56,
		Round = 0,
		Default = 0,
		Setting = "Shared.Effects.Blur",
		EventToFire = script.Parent.Parent.Parent.Events.ChangeBlur,
	}).Parent =
		copy.BlurSlider

	slider({
		Name = "Saturation",
		Min = -1,
		Max = 1,
		Round = 2,
		Default = 0,
		Setting = "Shared.Effects.Saturation",
		EventToFire = script.Parent.Parent.Parent.Events.ChangeSaturation,
	}).Parent =
		copy.SaturationSlider

	return copy
end
