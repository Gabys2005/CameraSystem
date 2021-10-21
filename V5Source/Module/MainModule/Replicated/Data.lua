local data = {

	Shared = {
		CurrentCamera = {
			Type = "Default",
			Id = 0,
			Model = nil,
		},
		CameraData = { -- This is used purely by the lerper and only includes the data of the currently lerped camera
			Position = Vector3.new(),
			Rotation = Vector3.new(),
			CFrame = CFrame.new(),
		},
		Focus = {
			Type = nil, -- Either "Part" or "Player", nil is used when focus is disabled
			Instance = nil,
		},
	},

	Local = {
		Settings = {
			TransparentBlackout = false,
			Keybinds = false,
			DroneSpeed = 1,
		},
		Springs = {
			Focus = nil,
		},
	},
}

-- If the client requests this module (for the first time, on join), then import the current data from the server to sync it
local run = game:GetService("RunService")
if run:IsClient() then
	local serverData = script.Parent.Events.RequestCurrentData:InvokeServer()
	data.Shared = serverData.Shared
	local SettingsModule = require(workspace:WaitForChild("CameraSystem").Settings)
	local SettingsToImport = { "AccelerateStart", "DecelerateEnd", "UseSprings" }
	for i, v in pairs(SettingsToImport) do
		data.Local.Settings[v] = SettingsModule[v]
	end
end

return data
