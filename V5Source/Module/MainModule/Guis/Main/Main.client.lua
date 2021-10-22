--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local data = require(replicated.Client.Scripts.UpdateData)
local api = require(workspace:WaitForChild("CameraSystem"):WaitForChild("Api"))
local lerper = require(replicated.Client.Scripts.Lerper)
local spring = require(replicated.Client.Dependencies.Spring)
local utils = require(replicated.Client.Scripts.Utils)

--// Functions

--===================== CODE =====================--
-- Setup springs
local focusSpring = spring.new(Vector3.new())
focusSpring.Speed = 10
data:set("Local.Springs.Focus", focusSpring)

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

replicated.Events.UseSprings.OnClientEvent:Connect(function(bool)
	if bool then
		data:get("Local.Springs.Focus").Position = utils:CFrameToRotation(
			CFrame.lookAt(data:get("Shared.CameraData.Position"), utils:getFocusPosition())
		)
	end
	data:set("Shared.Settings.UseSprings", bool)
end)
