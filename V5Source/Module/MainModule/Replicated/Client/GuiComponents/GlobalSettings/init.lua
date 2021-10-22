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
		Name = "Use springs: ",
		Setting = "Shared.Settings.UseSprings",
		EventToFire = script.Parent.Parent.Parent.Events.UseSprings,
	}).Parent =
		copy.UseSprings

	return copy
end
