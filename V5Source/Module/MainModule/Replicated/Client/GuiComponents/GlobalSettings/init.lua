local switch = require(script.Parent.Switch)

return function()
	local copy = script.Frame:Clone()

	switch({
		Name = "Auto FOV: ",
		Setting = "Shared.Settings.AutoFov",
		EventToFire = script.Parent.Parent.Parent.Events.ChangeAutoFov,
	}).Parent =
		copy.AutoFov

	return copy
end
