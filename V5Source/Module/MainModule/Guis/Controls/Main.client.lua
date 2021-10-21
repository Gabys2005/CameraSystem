--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local topbarPlusReference = replicatedStorage:FindFirstChild("TopbarPlusReference")
local iconModule = replicated.Client.Dependencies.TopbarPlus
local menuNames = {
	{
		Name = "Cameras",
		Width = 220,
		Height = 300,
	},
	{
		Name = "Settings",
		Width = 220,
		Height = 150,
	},
	{
		Name = "FocusList",
		Width = 220,
		Height = 220,
	},
}
local window = require(replicated.Client.Scripts.NewWindow)

--// Functions

--===================== CODE =====================--
if topbarPlusReference then
	iconModule = topbarPlusReference.Value
end
local Icon = require(iconModule)

window:setParent(script.Parent)

local menuIcons = {}
for i, v in pairs(menuNames) do
	local gui = window:new({
		Title = v.Name,
		Name = v.Name,
		MinimumWidth = v.Width,
		MinimumHeight = v.Height,
		Enabled = false,
	})
	local icon = Icon.new():setLabel(v.Name):bindToggleItem(gui)
	icon.deselectWhenOtherIconSelected = false
	table.insert(menuIcons, icon)
end
local controlIcon = Icon.new():setImage(5036765717):setMenu(menuIcons)
