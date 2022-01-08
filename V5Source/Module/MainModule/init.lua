return function(systemFolder)
	--// Services
	local players = game:GetService("Players")
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local lighting = game:GetService("Lighting")

	--// Variables
	local Settings = require(systemFolder.Settings)
	local replicatedFolder = script.Replicated
	local data = require(replicatedFolder.Data)
	local apiModule = script.Apis.Api
	local SettingsWithTypes = {
		GuiOwners = "table",
		Theme = "string",
		AccelerateStart = "boolean",
		DecelerateEnd = "boolean",
		ToggleGui = "table",
		WatchButtonPosition = "string",
		Keybinds = "table",
	}

	--// Functions
	local function onPlayerAdded(plr: Player)
		if table.find(Settings.GuiOwners, plr.Name) then
			local guiClone = script.Guis.Controls:Clone()
			guiClone.Name = "CameraSystemControls"
			guiClone.Parent = plr.PlayerGui
		end
		local mainGuiClone = script.Guis.Main:Clone()
		mainGuiClone.Name = "CameraSystemMain"
		mainGuiClone.Parent = plr.PlayerGui
	end

	local function validateSettings()
		for i, v in pairs(SettingsWithTypes) do
			assert(Settings[i] ~= nil, "[[ Camera System ]]: The '" .. i .. "' setting is missing")
			assert(
				typeof(Settings[i]) == v,
				"[[ Camera System ]]: The '"
					.. i
					.. "' setting is the wrong type, it's a '"
					.. typeof(Settings[i])
					.. "' while it should be '"
					.. v
					.. "'"
			)
		end
		-- Additional setting specific checks
		for i, v in pairs(Settings.GuiOwners) do
			assert(typeof(v) == "string", "[[ Camera System ]]: '" .. v .. "' isn't a string in 'GuiOwners' setting")
		end
	end

	local function isOwner(plr: Player)
		if table.find(Settings.GuiOwners, plr.Name) then
			return true
		end
		return false
	end

	--===================== CODE =====================--

	--// Check if the system can run
	assert(
		workspace.StreamingEnabled == false,
		"[[ Camera System ]]: StreamingEnabled can't be enabled for the cameras to work, disable it in Workspace's properties"
	)

	--// Validate settings
	validateSettings()

	--// Import all assets neccessary
	replicatedFolder.Name = "CameraSystem"
	replicatedFolder.Parent = replicatedStorage
	apiModule.Parent = systemFolder

	script.Lighting.CameraSystemBlur.Parent = lighting
	script.Lighting.CameraSystemColorCorrection.Parent = lighting

	--// Get cameras and set the default position
	local api = require(apiModule)
	local camerasByIds = api:GetCamsById()

	data.Shared.CurrentCamera.Type = "Default"
	data.Shared.CurrentCamera.Model = camerasByIds.Default

	--// Hide focus points
	for i, v in pairs(systemFolder.FocusPoints:GetChildren()) do
		v.Transparency = 1
		v.CanCollide = false
	end

	--// Connect events
	for i, v in pairs(players:GetPlayers()) do
		onPlayerAdded(v)
	end
	players.PlayerAdded:Connect(onPlayerAdded)

	replicatedFolder.Events.RequestCurrentData.OnServerInvoke = function()
		return data
	end

	replicatedFolder.Events.ChangeCam.OnServerEvent:Connect(function(plr, camType, camId)
		if isOwner(plr) then
			api:ChangeCam(camType, camId)
		end
	end)

	replicatedFolder.Events.ChangeFocus.OnServerEvent:Connect(function(plr, plrString)
		if isOwner(plr) then
			if plrString then
				local point = systemFolder.FocusPoints:FindFirstChild(plrString)
				if point then
					api:Focus(point)
				else
					api:Focus(plrString)
				end
			else
				api:Focus(nil)
			end
		end
	end)

	replicatedFolder.Events.ChangeFov.OnServerEvent:Connect(function(plr, fov)
		if isOwner(plr) then
			api:ChangeFov(fov)
		end
	end)

	replicatedFolder.Events.ChangeAutoFov.OnServerEvent:Connect(function(plr, bool)
		if isOwner(plr) then
			api:ChangeAutoFov(bool)
		end
	end)

	replicatedFolder.Events.SmoothFocus.OnServerEvent:Connect(function(plr, bool)
		if isOwner(plr) then
			api:ChangeSmoothFocus(bool)
		end
	end)

	replicatedFolder.Events.ChangeBlur.OnServerEvent:Connect(function(plr, blur)
		if isOwner(plr) then
			api:ChangeBlur(blur)
		end
	end)

	replicatedFolder.Events.ChangeSaturation.OnServerEvent:Connect(function(player, saturation)
		if isOwner(player) then
			api:ChangeSaturation(saturation)
		end
	end)

	replicatedFolder.Events.ChangeTilt.OnServerEvent:Connect(function(plr, tilt)
		if isOwner(plr) then
			api:ChangeTilt(tilt)
		end
	end)

	replicatedFolder.Events.ChangeBlackout.OnServerEvent:Connect(function(plr, bool)
		if isOwner(plr) then
			api:ChangeBlackout(bool)
		end
	end)

	replicatedFolder.Events.ChangeBarsEnabled.OnServerEvent:Connect(function(plr, enabled)
		if isOwner(plr) then
			api:ChangeBarsEnabled(enabled)
		end
	end)

	replicatedFolder.Events.ChangeBarSize.OnServerEvent:Connect(function(plr, size)
		if isOwner(plr) then
			api:ChangeBarSize(size)
		end
	end)

	replicatedFolder.Events.ChangeTransition.OnServerEvent:Connect(function(plr, transitionName)
		if isOwner(plr) then
			api:ChangeTransition(transitionName)
		end
	end)

	replicatedFolder.Events.ChangeTransitionSpeed.OnServerEvent:Connect(function(plr, speed)
		if isOwner(plr) then
			api:ChangeTransitionSpeed(speed)
		end
	end)

	replicatedFolder.Events.ChangeShake.OnServerEvent:Connect(function(plr, shake)
		if isOwner(plr) then
			api:ChangeShake(shake)
		end
	end)

	replicatedFolder.Events.RunKeybind.OnServerEvent:Connect(function(plr, keybindData)
		print(plr, keybindData)
		if isOwner(plr) then
			if keybindData[1] == "Fov" then
				api:ChangeFov(keybindData[2], keybindData[3])
			elseif keybindData[1] == "Blackout" then
				api:ChangeBlackout(keybindData[2])
			elseif keybindData[1] == "Bars" then
				api:ChangeBarsEnabled(keybindData[2])
			elseif keybindData[1] == "Transition" then
				api:ChangeTransition(keybindData[2])
			elseif keybindData[1] == "TransitionSpeed" then
				api:ChangeTransitionSpeed(keybindData[2])
			elseif keybindData[1] == "Shake" then
				api:ChangeShake(keybindData[2])
			elseif keybindData[1] == "Blur" then
				api:ChangeBlur(keybindData[2], keybindData[3])
			elseif keybindData[1] == "Saturation" then
				api:ChangeSaturation(keybindData[2], keybindData[3])
			elseif keybindData[1] == "Tilt" then
				api:ChangeTilt(keybindData[2], keybindData[3])
			elseif keybindData[1] == "Camera" then
				api:ChangeCam(keybindData[2], keybindData[3])
			end
		end
	end)
end
