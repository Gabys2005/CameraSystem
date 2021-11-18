local switch = require(script.Parent.Switch)

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

	return copy
end
