local switch = require(script.Parent.Switch)
local slider = require(script.Parent.DotSlider)

return function()
	local copy = script.Frame:Clone()

	switch({
		Name = "Auto FOV: ",
		Setting = "Shared.Settings.AutoFov",
		EventToFire = script.Parent.Parent.Parent.Events.ChangeAutoFov,
	}).Parent =
		copy.AutoFov

	switch({
		Name = "[BETA] Smooth focus: ",
		Setting = "Shared.Settings.SmoothFocus",
		EventToFire = script.Parent.Parent.Parent.Events.SmoothFocus,
	}).Parent =
		copy.SmoothFocus

	slider({
		Name = "Bar size: ",
		Min = 0,
		Max = 50,
		Round = 0,
		Default = 20,
		Setting = "Shared.Settings.BarSize",
		EventToFire = script.Parent.Parent.Parent.Events.ChangeBarSize,
		Suffix = "%",
	}).Parent =
		copy.BarSize

	return copy
end
