local CamerasWindow = {}
local replicated = script.Parent.Parent
local TopbarMenu = require(replicated.Scripts.Control.TopbarMenu)
local Icon = require(replicated.Dependencies.TopbarPlus)
local Fusion = require(replicated.Dependencies.Fusion)
local Gui = require(replicated.Data.Gui):Get()
local ControlGuis = require(replicated.Data.ControlGuis):GetCameraSectionsFusion()
local Window = require(replicated.UIComponents.Window)
local CategorySwitcher = require(replicated.UIComponents.CategorySwitcher)

local Value = Fusion.Value
local Children = Fusion.Children

local visible = Value(true)

local topbarButton = Icon.new():setLabel("Cameras"):autoDeselect(false)
TopbarMenu:AddIcon(topbarButton)

topbarButton.selected:Connect(function()
	visible:set(true)
end)

topbarButton.deselected:Connect(function()
	visible:set(false)
end)

local window = Window {
	[Children] = CategorySwitcher {
		Content = ControlGuis,
	},
	Visible = visible,
	Parent = Gui,
	Title = "Cameras",
	OnClose = function()
		topbarButton:deselect()
	end,
}

return CamerasWindow
