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
		BarsOffset = "table",
		BeforeLoad = "function",
		FreeAdmin = "string",
		LogActions = "boolean",
	}
	local DefaultSettings = {
		GuiOwners = {},
		Theme = "Dark",
		AccelerateStart = true,
		DecelerateEnd = true,
		ToggleGui = {},
		WatchButtonPosition = "Center",
		Keybinds = {},
		BarsOffset = {
			Players = {},
			Offset = 36,
		},
		BeforeLoad = function() end,
		FreeAdmin = "None",
		LogActions = false,
	}

	--// Functions
	local function isOwner(plr: Player)
		if Settings.FreeAdmin == "All" then
			return true
		end
		if Settings.FreeAdmin == "Owners" and game.PrivateServerOwnerId == plr.UserId then
			return true
		end
		if table.find(Settings.GuiOwners, plr.Name) then
			return true
		end
		return false
	end

	local function log(text)
		if Settings.LogActions then
			print(`[[ Camera System ]]: {text}`)
		end
	end

	local function onPlayerAdded(plr: Player)
		if isOwner(plr) then
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
			if Settings[i] == nil then
				warn("[[ Camera System ]]: The '" .. i .. "' setting is missing")
				Settings[i] = DefaultSettings[i]
			end
			if type(Settings[i]) ~= v then
				warn(
					"[[ Camera System ]]: The '"
						.. i
						.. "' setting is the wrong type, it's a '"
						.. typeof(Settings[i])
						.. "' while it should be '"
						.. v
						.. "'"
				)
				Settings[i] = DefaultSettings[i]
			end
		end
		-- Additional setting specific checks
		for i, v in pairs(Settings.GuiOwners) do
			assert(typeof(v) == "string", "[[ Camera System ]]: '" .. v .. "' isn't a string in 'GuiOwners' setting")
		end
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

	Settings.BeforeLoad()
	--// Get cameras and set the default position
	local api = require(apiModule)
	local camerasByIds = api:GetCamsById()

	data.Shared.CurrentCamera.Type = "Default"
	data.Shared.CurrentCamera.Model = camerasByIds.Default

	--// Hide focus points
	for i, v in pairs(systemFolder.FocusPoints:GetChildren()) do
		if v:IsA("BasePart") then
			v.Transparency = 1
			v.CanCollide = false
		end
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
			log(`{plr.Name} changed camera to {camType} {camId}`)
			api:ChangeCam(camType, camId)
		end
	end)

	replicatedFolder.Events.ChangeFocus.OnServerEvent:Connect(function(plr, plrString)
		if isOwner(plr) then
			log(`{plr.Name} changed focus to {plrString}`)
			if plrString then
				local point = systemFolder.FocusPoints:FindFirstChild(plrString)
				if point then
					if point:IsA("BasePart") then
						api:Focus(point)
					else
						api:Focus(point.Value)
					end
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
			log(`{plr.Name} changed fov to {fov}`)
			api:ChangeFov(fov, data.Shared.Effects.Fov.Time)
		end
	end)

	replicatedFolder.Events.ChangeAutoFov.OnServerEvent:Connect(function(plr, bool)
		if isOwner(plr) then
			log(`{plr.Name} changed auto fov to {tostring(bool)}`)
			api:ChangeAutoFov(bool)
		end
	end)

	replicatedFolder.Events.SmoothFocus.OnServerEvent:Connect(function(plr, bool)
		if isOwner(plr) then
			log(`{plr.Name} changed smooth focus to {tostring(bool)}`)
			api:ChangeSmoothFocus(bool)
		end
	end)

	replicatedFolder.Events.ChangeBlur.OnServerEvent:Connect(function(plr, blur)
		if isOwner(plr) then
			log(`{plr.Name} changed blur to {blur}`)
			api:ChangeBlur(blur)
		end
	end)

	replicatedFolder.Events.ChangeSaturation.OnServerEvent:Connect(function(plr, saturation)
		if isOwner(plr) then
			log(`{plr.Name} changed saturation to {saturation}`)
			api:ChangeSaturation(saturation)
		end
	end)

	replicatedFolder.Events.ChangeTilt.OnServerEvent:Connect(function(plr, tilt)
		if isOwner(plr) then
			log(`{plr.Name} changed tilt to {tilt}`)
			api:ChangeTilt(tilt)
		end
	end)

	replicatedFolder.Events.ChangeBlackout.OnServerEvent:Connect(function(plr, bool)
		if isOwner(plr) then
			log(`{plr.Name} changed blackout to {tostring(bool)}`)
			api:ChangeBlackout(bool)
		end
	end)

	replicatedFolder.Events.ChangeBarsEnabled.OnServerEvent:Connect(function(plr, enabled)
		if isOwner(plr) then
			log(`{plr.Name} changed bars enabled to {tostring(enabled)}`)
			api:ChangeBarsEnabled(enabled)
		end
	end)

	replicatedFolder.Events.ChangeBarSize.OnServerEvent:Connect(function(plr, size)
		if isOwner(plr) then
			log(`{plr.Name} changed bar size to {size}`)
			api:ChangeBarSize(size)
		end
	end)

	replicatedFolder.Events.ChangeTransition.OnServerEvent:Connect(function(plr, transitionName)
		if isOwner(plr) then
			log(`{plr.Name} changed transition to {transitionName}`)
			api:ChangeTransition(transitionName)
		end
	end)

	replicatedFolder.Events.ChangeTransitionSpeed.OnServerEvent:Connect(function(plr, speed)
		if isOwner(plr) then
			log(`{plr.Name} changed transition speed to {speed}`)
			api:ChangeTransitionSpeed(speed)
		end
	end)

	replicatedFolder.Events.ChangeShake.OnServerEvent:Connect(function(plr, shake)
		if isOwner(plr) then
			log(`{plr.Name} changed shake value to {shake}`)
			api:ChangeShake(shake)
		end
	end)

	replicatedFolder.Events.RunKeybind.OnServerEvent:Connect(function(plr, keybindData)
		if isOwner(plr) then
			log(`{plr.Name} ran a keybind: {keybindData[1]} {tostring(keybindData[2])} {tostring(keybindData[3])}`)
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

	replicatedFolder.Events.RequestDrone.OnServerInvoke = function(plr: Player, drone)
		if isOwner(plr) then
			drone:SetNetworkOwner(plr)
			drone.CamPos:SetNetworkOwner(plr)
		end
	end

	replicatedFolder.Events.SendDroneLocation.OnServerInvoke = function(plr: Player, drone, location: CFrame)
		if isOwner(plr) then
			drone:SetNetworkOwner()
			drone.CamPos:SetNetworkOwner()
			local nx = location:ToOrientation()
			local finalCFrame = location * CFrame.Angles(-nx, 0, 0)
			drone.BodyPosition.Position = location.Position
			drone.BodyGyro.CFrame = finalCFrame
			drone.CamPos.BodyPosition.Position = location.Position
			drone.CamPos.BodyGyro.CFrame = location
			drone.CFrame = finalCFrame
			drone.CamPos.CFrame = location
		end
	end
end
