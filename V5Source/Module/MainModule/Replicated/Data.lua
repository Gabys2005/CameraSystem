local data = {
	
	Shared = {
		CurrentCamera = {
			Type = "Default",
			Id = 0,
			Model = nil
		},
		CameraData = {
			Position = Vector3.new(),
			Rotation = Vector3.new(),
			CFrame = CFrame.new()
		}
	},
	
	Local = {
		Settings = {
			TransparentBlackout = false,
			Keybinds = false,
			DroneSpeed = 1
		}
	}

}

local run = game:GetService("RunService")
if run:IsClient() then
	local serverData = script.Parent.Events.RequestCurrentData:InvokeServer()
	data.Shared = serverData.Shared
end

return data