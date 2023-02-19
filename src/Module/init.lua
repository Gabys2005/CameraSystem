return function(Settings, Folder)
	local players = game:GetService("Players")
	local replicatedStorage = game:GetService("ReplicatedStorage")

	local guis = script.Guis
	local mainGui = guis.Main
	local replicated = script.Replicated
	local apiScript = script.Api
	local api = require(apiScript)
	local isAdmin = require(replicated.Scripts.Utils.IsAdmin)
	local apiData = require(replicated.Data.Api)
	local SettingsData = require(replicated.Data.Settings)

	local function onPlayerAdded(plr: Player)
		mainGui:Clone().Parent = plr.PlayerGui
	end

	mainGui.Name = "CameraSystem"
	replicated.Name = "CameraSystem"
	replicated.Parent = replicatedStorage
	apiScript.Parent = Folder

	api:_SetApis(replicated, Folder)
	apiData:Set(apiScript)
	SettingsData:SetAll(Settings)

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
			Api = apiScript,
		}
	end

	replicated.Functions.GetAllCameras.OnServerInvoke = function(plr, camType)
		if isAdmin(plr) then
			local cams = api.Cameras.GetTypeByName(camType):GetCameras()
			local toReturn = {}
			for id, data in cams do
				table.insert(toReturn, { ID = id, Data = data })
			end
			return toReturn
		end
	end

	replicated.Functions.ChangeCamera.OnServerEvent:Connect(function(player, id)
		-- TODO: if is admin
		api.Cameras:Change(id)
	end)

	require(replicated.Scripts.Main.DefaultCameraTypes.Static)

	for _, plr: Player in players:GetPlayers() do
		onPlayerAdded(plr)
	end
	players.PlayerAdded:Connect(onPlayerAdded)

	return "Cameras"
end
