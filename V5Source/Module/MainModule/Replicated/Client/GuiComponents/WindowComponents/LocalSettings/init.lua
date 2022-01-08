local basicComponents = script.Parent.Parent.Basic
local dotslider = require(basicComponents.DotSlider)
local switch = require(basicComponents.Switch)
local smoothGrid = require(script.Parent.Parent.Parent.Scripts.SmoothGrid)

return function()
	local copy = script.Frame:Clone()
	switch({
		Name = "Transparent overlays:",
		Setting = "Local.Settings.TransparentOverlays",
	}).Parent =
		copy.TopSwitches.TransparentBlackout

	switch({
		Name = "Keybinds:",
		Setting = "Local.Settings.KeybindsEnabled",
	}).Parent = copy.TopSwitches.Keybinds

	dotslider({
		Name = "Drone Speed",
		Min = 0,
		Max = 2,
		Round = 2,
		Setting = "Local.Settings.DroneSpeed",
	}).Parent =
		copy.SomeSlider
	smoothGrid(copy.TopSwitches, copy.TopSwitches.UIGridLayout)
	return copy
end
