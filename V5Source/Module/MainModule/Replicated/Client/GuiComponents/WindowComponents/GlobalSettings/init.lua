local basicComponents = script.Parent.Parent.Basic
local events = script.Parent.Parent.Parent.Parent.Events
local switch = require(basicComponents.Switch)
local slider = require(basicComponents.DotSlider)
local button = require(basicComponents.RoundedButton)
local theme = require(script.Parent.Parent.Parent.Themes.Current)
local data = require(script.Parent.Parent.Parent.Scripts.UpdateData)

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

	slider({
		Name = "Transition time: ",
		Min = 50,
		Max = 200,
		Round = 0,
		Default = 100,
		Setting = "Shared.Settings.TransitionTimes.Multiplier",
		EventToFire = events.ChangeTransitionSpeed,
		Suffix = "%",
	}).Parent =
		copy.TransitionTime

	local transitionButtons = {}

	for i, v in pairs({ "None", "Black", "White" }) do
		local button = button(v)
		button.Name = v
		button.LayoutOrder = i
		if v == data:get("Shared.Settings.Transition") then
			button.BackgroundColor3 = theme.Highlighted
		end
		button.Parent = copy.Transition
		button.MouseButton1Click:Connect(function()
			events.ChangeTransition:FireServer(v)
		end)
		table.insert(transitionButtons, button)
	end

	data:onChange("Shared.Settings.Transition", function()
		for i, v in pairs(transitionButtons) do
			if v.Name == data:get("Shared.Settings.Transition") then
				v.BackgroundColor3 = theme.Highlighted
			else
				v.BackgroundColor3 = theme.Base
			end
		end
	end)

	return copy
end
