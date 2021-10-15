--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local data = require(replicated.Client.Scripts.UpdateData)
local api = require(workspace:WaitForChild("CameraSystem"):WaitForChild("Api"))

--// Functions

--===================== CODE =====================--
api:GetCamsById() -- index
require(replicated.Client.Controllers.Cameras)
require(replicated.Client.Controllers.Watch)

replicated.Events.ChangeCam.OnClientEvent:Connect(function(camType,camId)
	data:set("Shared.CurrentCamera",{
		Type = camType,
		Id = camId,
		Model = api:GetCamById(camType,camId)
	})
end)