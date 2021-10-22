return function(systemFolder)
	--// Services
	local players = game:GetService("Players")
	local replicatedStorage = game:GetService("ReplicatedStorage")

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
		UseSprings = "boolean",
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
end
