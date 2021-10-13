return function(systemFolder)
	--// Services
	local players = game:GetService("Players")
	local replicatedStorage = game:GetService("ReplicatedStorage")
	
	--// Variables
	local Settings = require(systemFolder.Settings)
	local replicatedFolder = script.Replicated
	local data = require(replicatedFolder.Data)
	local clientApiModule = script.Apis.ClientApi
	local serverApiModule = script.Apis.ServerApi

	--// Functions	
	local function onPlayerAdded(plr)
		if table.find(Settings.GuiOwners,plr.Name) then
			local guiClone = script.Guis.Controls:Clone()
			guiClone.Name = "CameraSystemControls"
			guiClone.Parent = plr.PlayerGui
		end
		local mainGuiClone = script.Guis.Main:Clone()
		mainGuiClone.Name = "CameraSystemMain"
		mainGuiClone.Parent = plr.PlayerGui
	end
	
	--===================== CODE =====================--
	
	--// Check if the system can run
	assert(workspace.StreamingEnabled == false,"[[ Camera System ]]: StreamingEnabled can't be enabled for the cameras to work, disable it in Workspace's properties")
	
	--// Validate settings
	assert(Settings.GuiOwners, "[[ Camera System ]]: 'GuiOwners' setting is missing")
	assert(typeof(Settings.GuiOwners) == "table", "[[ Camera System ]]: 'GuiOwners' setting has to be a table")
	for i,v in pairs(Settings.GuiOwners) do
		assert(typeof(v) == "string","[[ Camera System ]]: '" .. v .. "' isn't a string in 'GuiOwners' setting")
	end

	--// Import all assets neccessary
	replicatedFolder.Name = "CameraSystem"
	replicatedFolder.Parent = replicatedStorage
	serverApiModule.Parent = systemFolder
	clientApiModule.Parent = systemFolder
	--// Get cameras
	local api = require(serverApiModule)
	local camerasByIds = api:GetCamsById()
	
	data.Shared.CurrentCamera.Type = "Default"
	data.Shared.CurrentCamera.Model = camerasByIds.Default
	
	print(camerasByIds)
	
	--// Connect events
	for i,v in pairs(players:GetPlayers()) do
		onPlayerAdded(v)
	end
	players.PlayerAdded:Connect(onPlayerAdded)
	
	replicatedFolder.Events.RequestCurrentData.OnServerInvoke = function()
		return data
	end
	
	replicatedFolder.Events.ChangeCam.OnServerEvent:Connect(function(plr,camType,camId)
		api:ChangeCam(camType,camId)
	end)
end