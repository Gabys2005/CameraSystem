local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local replicated = script.Parent.Parent

local consts = require(replicated.Shared.Constants)
local Window = require(replicated.Client.GuiComponents.Basic.Window)

return function(mainGui)
	local iconModule = replicated.Client.Dependencies.TopbarPlus
	local menuNames = {
		-- {
		-- 	Name = "Cameras",
		-- 	Width = 225,
		-- 	Height = 300,
		-- },
		{
			Module = "Effects",
			Name = "Effects",
			Width = 225,
			Height = 300,
		},
		{
			Module = "Settings",
			Name = "Settings",
			Width = 240,
			Height = 280,
		},
		{
			Module = "FocusList",
			Name = "Focus List",
			Width = 250,
			Height = 150,
		},
		{
			Module = "Info",
			Name = "Camera Info",
			Width = 225,
			Height = 165,
			VerticallyResizable = false,
		},
	}
	-- local window = require(replicated.Client.Scripts.NewWindow)
	local data = require(replicated.Data)

	--// Functions

	--===================== CODE =====================--
	if replicatedStorage:FindFirstChild("TopbarPlus") then
		iconModule = replicatedStorage:FindFirstChild("TopbarPlus")
	end
	local Icon = require(iconModule)

	-- window:setParent(mainGui)

	local menuIcons = {}
	for i, v in pairs(menuNames) do
		local icon = Icon.new():setLabel(v.Name):setName(`CameraSystemControls-{v.Name}`)
		-- local gui = window:new({
		-- 	Title = v.Title or v.Name,
		-- 	Name = v.Name,
		-- 	MinimumWidth = v.Width,
		-- 	MinimumHeight = v.Height,
		-- 	Position = UDim2.fromOffset(250 * (i - 1) + 20, 50),
		-- 	Enabled = false,
		-- 	DeleteWhenClosed = false,
		-- 	Icon = icon,
		-- })
		local window = Window.new({
			Title = v.Name,
			MinSize = UDim2.fromOffset(v.Width, v.Height),
			Position = UDim2.fromOffset(250 * (i - 1) + 20, 50),
			OnClose = function()
				icon:deselect()
			end,
			VerticallyResizable = v.VerticallyResizable,
		})
		window.Instance.Parent = mainGui

		local contentComponentModule = require(script.Parent.GuiComponents.Windows[v.Module])
		local contentComponent = contentComponentModule.new()
		contentComponent.Instance.Parent = window.Content
		-- contentComponent().Parent = window.Content

		icon:bindToggleItem(window.Instance)
		icon.deselectWhenOtherIconSelected = false
		table.insert(menuIcons, icon)
	end

	local controlIcon = Icon.new():setImage(consts.CONTROL_ICON_ID):setName("CameraSystemControls")
	local controlButtonPosition = data.Local.Settings.ControlButtonPosition

	-- running :setLeft() makes the menu not save the scroll position
	if controlButtonPosition == "Center" then
		controlIcon:setMid()
	elseif controlButtonPosition == "Right" then
		controlIcon:setRight()
	end

	-- If :setMenu is called before :setLeft/Mid/Right, then
	-- it doesn't open properly
	controlIcon:setMenu(menuIcons)

	--// Keybinds

	local keysToGetAffectedBy = {}

	for i, v in pairs(data.Local.Settings.Keybinds) do
		for _, key in pairs(v.Keys) do
			if not keysToGetAffectedBy[key] then
				keysToGetAffectedBy[key] = {}
			end
		end
	end

	userInputService.InputBegan:Connect(function(input, processed)
		if processed or not data.Local.Settings.KeybindsEnabled then
			return
		end
		if keysToGetAffectedBy[input.KeyCode] then
			for i, v in pairs(data.Local.Settings.Keybinds) do
				local shouldRun = true
				for _, key in pairs(v.Keys) do
					if not userInputService:IsKeyDown(key) then
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
end
