--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local data = require(replicated.Client.Scripts.UpdateData)
local api = require(workspace:WaitForChild("CameraSystem"):WaitForChild("Api"))
local spring = require(replicated.Client.Dependencies.Spring)

--// Functions

--===================== CODE =====================--
-- Index the cameras and initiate the controllers
api:GetCamsById()
if data:get("Local.Settings.UseSprings") == true then
	local spr = spring.new(Vector3.new())
	spr.Speed = 10
	data:set("Local.Springs.Focus", spr)
end
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
end)
