local dotslider = require(script.Parent.DotSlider)
local switch = require(script.Parent.Switch)
local smoothGrid = require(script.Parent.Parent.Scripts.SmoothGrid)

return function()
	local copy = script.Frame:Clone()
	switch({Name = "Transparent blackout:", SettingToUpdate = "Local.Settings.TransparentBlackout"}).Parent = copy.TopSwitches.TransparentBlackout
	switch({Name = "Keybinds:", SettingToUpdate = "Local.Settings.Keybinds"}).Parent = copy.TopSwitches.Keybinds
	dotslider({Name = "Drone Speed", Min = 0, Max = 2, Round = 2, SettingToUpdate = "Local.Settings.DroneSpeed"}).Parent = copy.SomeSlider
	smoothGrid(copy.TopSwitches,copy.TopSwitches.UIGridLayout)
	return copy
end