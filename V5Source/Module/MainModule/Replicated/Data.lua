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
		Effects = {
			Fov = {
				Value = 70,
				Time = 0.1,
			},
			Blur = {
				Value = 0,
				Time = 0.1,
			},
			Saturation = {
				Value = 0,
				Time = 0.1,
			},
			Tilt = {
				Value = 0,
				Time = 0.1,
			},
			Blackout = false,
		},
		Settings = {
			AutoFov = false,
			SmoothFocus = false,
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
		Watching = false,
		LerpedValues = {
			Fov = 70,
			Tilt = 0,
		},
	},
}

-- If the client requests this module (for the first time, on join), then import the current data from the server to sync it
local run = game:GetService("RunService")
if run:IsClient() then
	local serverData = script.Parent.Events.RequestCurrentData:InvokeServer()
	data.Shared = serverData.Shared
	local SettingsModule = require(workspace:WaitForChild("CameraSystem").Settings)
	local SettingsToImport = { "AccelerateStart", "DecelerateEnd" }
	for i, v in pairs(SettingsToImport) do
		data.Local.Settings[v] = SettingsModule[v]
	end
end

return data
