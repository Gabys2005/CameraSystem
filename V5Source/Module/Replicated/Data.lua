--!strict

local data = {

	Shared = {
		CurrentCamera = {
			Type = "Default",
			Id = 1,
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
			Shake = 0,
			Blackout = false,
			BarsEnabled = false,
		},
		Settings = {
			AutoFov = false,
			SmoothFocus = false,
			BarSize = {
				Value = 20,
				Time = 0.1,
			},
			Transition = "None",
			TransitionTimes = {
				Multiplier = 100,
				Black = 0.3,
				White = 0.3,
			},
		},
	},

	Local = {
		Settings = {
			TransparentOverlays = false,
			KeybindsEnabled = false,
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
		ControllingDrone = false,
	},
}

-- If the client requests this module (for the first time, on join), then import the current data from the server to sync it
local run = game:GetService("RunService")
if run:IsClient() then
	local serverData = script.Parent.Events.RequestCurrentData:InvokeServer()
	data.Shared = serverData.Data.Shared
	for settingName, settingValue in serverData.Settings do
		data.Local.Settings[settingName] = settingValue
	end
	data.Local.LerpedValues.Fov = data.Shared.Effects.Fov.Value
	data.Local.LerpedValues.Tilt = data.Shared.Effects.Tilt.Value
end

return data
