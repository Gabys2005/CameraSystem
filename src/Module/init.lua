return function(Settings, Folder)
	local players = game:GetService("Players")
	local replicatedStorage = game:GetService("ReplicatedStorage")

	local guis = script.Guis
	local mainGui = guis.Main
	local replicated = script.Replicated
	local apiScript = script.Api
	local api = require(apiScript)
	local systemFolder = require(replicated.Data.SystemFolder)

	systemFolder:Set(Folder)

	local function onPlayerAdded(plr: Player)
		mainGui:Clone().Parent = plr.PlayerGui
	end

	mainGui.Name = "CameraSystem"
	replicated.Name = "CameraSystem"
	replicated.Parent = replicatedStorage
	apiScript.Parent = Folder

	api:_SetApis(replicated)

	for _, themeModule in Folder.Themes:GetChildren() do
		local themeData = require(themeModule)
		api.Themes:AddTheme(themeModule.Name, themeData)
	end
	api.Themes:SetCurrent(Settings.Theme)

	replicated.Functions.GetCurrentData.OnServerInvoke = function()
		return {
			Settings = Settings,
			Themes = { All = api.Themes:GetAll(), Current = api.Themes:GetCurrentName() },
			Folder = Folder,
		}
	end

	replicated.Functions.GetNames.OnServerInvoke = function(plr, camType)
		print(camType)
		local cams = api.Cameras.GetTypeByName(camType):GetCameras()
		local toReturn = {}
		for id, data in cams do
			table.insert(toReturn, { ID = id, Name = data.Name })
		end
		print(cams)
		return toReturn
	end

	replicated.Functions.ChangeCamera.OnServerEvent:Connect(function(player, id)
		-- TODO: if is admin
		api.Cameras:Change(id)
	end)

	require(replicated.Scripts.DefaultCameraTypes.Static)

	for _, plr: Player in players:GetPlayers() do
		onPlayerAdded(plr)
	end
	players.PlayerAdded:Connect(onPlayerAdded)

	return "Cameras"
end
