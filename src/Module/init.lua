return function(Settings)
	local players = game:GetService("Players")
	local replicatedStorage = game:GetService("ReplicatedStorage")

	local guis = script.Guis
	local mainGui = guis.Main
	local replicated = script.Replicated

	local function onPlayerAdded(plr: Player)
		mainGui:Clone().Parent = plr.PlayerGui
	end

	mainGui.Name = "CameraSystem"
	replicated.Name = "CameraSystem"
	replicated.Parent = replicatedStorage

	for _, plr: Player in players:GetPlayers() do
		onPlayerAdded(plr)
	end
	players.PlayerAdded:Connect(onPlayerAdded)

	replicated.Functions.GetCurrentData.OnServerInvoke = function()
		return { Settings = Settings }
	end

	return "Cameras"
end