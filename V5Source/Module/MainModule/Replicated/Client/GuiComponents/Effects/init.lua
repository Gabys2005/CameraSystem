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

	return copy
end
