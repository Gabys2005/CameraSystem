local basicComponents = script.Parent.Parent.Basic
local events = script.Parent.Parent.Parent.Parent.Events
local switch = require(basicComponents.Switch)
local slider = require(basicComponents.DotSlider)

return function()
	local copy = script.Frame:Clone()

	switch({
		Name = "Auto FOV: ",
		Setting = "Shared.Settings.AutoFov",
		EventToFire = events.ChangeAutoFov,
	}).Parent =
		copy.AutoFov

	switch({
		Name = "[BETA] Smooth focus: ",
		Setting = "Shared.Settings.SmoothFocus",
		EventToFire = events.SmoothFocus,
	}).Parent =
		copy.SmoothFocus

	slider({
		Name = "Bar size: ",
		Min = 0,
		Max = 50,
		Round = 0,
		Default = 20,
		Setting = "Shared.Settings.BarSize",
		EventToFire = events.ChangeBarSize,
		Suffix = "%",
	}).Parent =
		copy.BarSize

	return copy
end
