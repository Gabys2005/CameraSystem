local CamerasWindow = {}
local replicated = script.Parent.Parent.Parent.Parent
local TopbarMenu = require(replicated.Scripts.Control.TopbarMenu)
local Icon = require(replicated.Dependencies.TopbarPlus)
local Fusion = require(replicated.Dependencies.Fusion)
local Gui = require(replicated.Data.Gui):Get()
local Window = require(replicated.UIComponents.Window)

local Value = Fusion.Value
local New = Fusion.New
local Children = Fusion.Children

local visible = Value(false)

local topbarButton = Icon.new():setLabel("Cameras"):autoDeselect(false)
TopbarMenu:AddIcon(topbarButton)

topbarButton.selected:Connect(function()
	visible:set(true)
end)

topbarButton.deselected:Connect(function()
	visible:set(false)
end)

print("GUI: ", Gui)

local window = Window {
	[Children] = New "TextLabel" {
		Text = "haiii",
		Size = UDim2.fromScale(1, 1),
	},
	Visible = visible,
	Parent = Gui,
}

return CamerasWindow
