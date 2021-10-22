--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local data = require(replicated.Client.Scripts.UpdateData)
local api = require(workspace:WaitForChild("CameraSystem"):WaitForChild("Api"))
local lerper = require(replicated.Client.Scripts.Lerper)

--// Functions

--===================== CODE =====================--
-- Index the cameras and initiate the controllers
api:GetCamsById()
require(replicated.Client.Controllers.Cameras)
require(replicated.Client.Controllers.Effects)
require(replicated.Client.Controllers.Watch)

replicated.Events.ChangeCam.OnClientEvent:Connect(function(camType, camId)
	data:set("Shared.CurrentCamera", {
		Type = camType,
		Id = camId,
		Model = api:GetCamById(camType, camId),
	})
end)

replicated.Events.ChangeFocus.OnClientEvent:Connect(function(newdata)
	data:set("Shared.Focus", newdata)
end)

replicated.Events.ChangeFov.OnClientEvent:Connect(function(newfov)
	data:set("Shared.Effects.Fov", newfov)
	lerper.data({ LerpTime = newfov.Time, Setting = "Local.LerpedValues.Fov", Goal = newfov.Value })
end)

replicated.Events.ChangeAutoFov.OnClientEvent:Connect(function(bool)
	data:set("Shared.Settings.AutoFov", bool)
end)
