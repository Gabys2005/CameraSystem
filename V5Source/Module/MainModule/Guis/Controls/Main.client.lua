--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
-- local topbarPlusReference = replicatedStorage:FindFirstChild("TopbarPlusReference")
local iconModule = replicated.Client.Dependencies.TopbarPlus
local menuNames = {
	{
		Name = "Cameras",
		Width = 225,
		Height = 300,
	},
	{
		Name = "Effects",
		Width = 225,
		Height = 300,
	},
	{
		Name = "Settings",
		Width = 225,
		Height = 280,
	},
	{
		Name = "FocusList",
		Width = 225,
		Height = 100,
	},
	{
		Name = "Info",
		Title = "[Beta] Info",
		Width = 225,
		Height = 150,
	},
}
local window = require(replicated.Client.Scripts.NewWindow)
local data = require(replicated.Data)

--// Functions

--===================== CODE =====================--
if replicatedStorage:FindFirstChild("TopbarPlus") then
	iconModule = replicatedStorage:FindFirstChild("TopbarPlus")
end
local Icon = require(iconModule)

window:setParent(script.Parent)

local menuIcons = {}
for i, v in pairs(menuNames) do
	local icon = Icon.new():setLabel(v.Name):setName(`CameraSystemControls-{v.Name}`)
	local gui = window:new {
		Title = v.Title or v.Name,
		Name = v.Name,
		MinimumWidth = v.Width,
		MinimumHeight = v.Height,
		Position = UDim2.fromOffset(250 * (i - 1) + 20, 50),
		Enabled = false,
		DeleteWhenClosed = false,
		Icon = icon,
	}
	icon:bindToggleItem(gui)
	icon.deselectWhenOtherIconSelected = false
	table.insert(menuIcons, icon)
end
local controlIcon = Icon.new():setImage(5036765717):setMenu(menuIcons):setName("CameraSystemControls")

--// Keybinds

local keysToGetAffectedBy = {}

for i, v in pairs(data.Local.Settings.Keybinds) do
	for _, key in pairs(v.Keys) do
		if not keysToGetAffectedBy[key] then
			keysToGetAffectedBy[key] = {}
		end
	end
end

uis.InputBegan:Connect(function(input, processed)
	if processed or not data.Local.Settings.KeybindsEnabled then
		return
	end
	if keysToGetAffectedBy[input.KeyCode] then
		for i, v in pairs(data.Local.Settings.Keybinds) do
			local shouldRun = true
			for _, key in pairs(v.Keys) do
				if not uis:IsKeyDown(key) then
					shouldRun = false
					break
				end
			end
			if shouldRun then
				replicated.Events.RunKeybind:FireServer(v.Action)
				-- break
			end
		end
	end
end)
