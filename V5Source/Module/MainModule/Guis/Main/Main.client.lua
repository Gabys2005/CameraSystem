--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local topbarPlusReference = replicatedStorage:FindFirstChild("TopbarPlusReference")
local iconModule = replicated.Client.Dependencies.TopbarPlus
local data = require(replicated.Client.Scripts.UpdateData)
local directData = data:getModule()
local api = require(workspace:WaitForChild("CameraSystem"):WaitForChild("Api"))
local cameraInstance = workspace.CurrentCamera

--// Functions

--===================== CODE =====================--
api:GetCamsById() -- index
require(replicated.Client.Scripts.CameraController)

replicated.Events.ChangeCam.OnClientEvent:Connect(function(camType,camId)
	data:set("Shared.CurrentCamera",{
		Type = camType,
		Id = camId,
		Model = api:GetCamById(camType,camId)
	})
end)