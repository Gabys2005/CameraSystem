--// Services
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local data = require(replicated.Client.Scripts.UpdateData)
local api = require(workspace:WaitForChild("CameraSystem"):WaitForChild("Api"))
local lerper = require(replicated.Client.Scripts.Lerper)
local spring = require(replicated.Client.Dependencies.Spring)
local utils = require(replicated.Client.Scripts.Utils)
local localPlayer = players.LocalPlayer

--// Functions

--===================== CODE =====================--
-- Setup springs
local focusSpring = spring.new(Vector3.new())
focusSpring.Speed = 10
data:set("Local.Springs.Focus", focusSpring)

-- Offset bars
local barsOffset = data:get("Local.Settings.BarsOffset")
if table.find(barsOffset.Players, localPlayer.Name) then
	script.Parent.Bars.Position = UDim2.fromOffset(0, barsOffset.Offset)
	script.Parent.Bars.Size = UDim2.new(1, 0, 1, -barsOffset.Offset)
end

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

replicated.Events.SmoothFocus.OnClientEvent:Connect(function(bool)
	if bool then
		data:get("Local.Springs.Focus").Position = utils:CFrameToRotation(
			CFrame.lookAt(data:get("Shared.CameraData.Position"), utils:getFocusPosition())
		)
	end
	data:set("Shared.Settings.SmoothFocus", bool)
end)

replicated.Events.ChangeBlur.OnClientEvent:Connect(function(blur)
	data:set("Shared.Effects.Blur", blur)
end)

replicated.Events.ChangeSaturation.OnClientEvent:Connect(function(saturation)
	data:set("Shared.Effects.Saturation", saturation)
end)

replicated.Events.ChangeTilt.OnClientEvent:Connect(function(tilt)
	data:set("Shared.Effects.Tilt", tilt)
	lerper.data({ LerpTime = tilt.Time, Setting = "Local.LerpedValues.Tilt", Goal = tilt.Value })
end)

replicated.Events.ChangeBlackout.OnClientEvent:Connect(function(blackout)
	data:set("Shared.Effects.Blackout", blackout)
end)

replicated.Events.ChangeBarsEnabled.OnClientEvent:Connect(function(enabled)
	data:set("Shared.Effects.BarsEnabled", enabled)
end)

replicated.Events.ChangeBarSize.OnClientEvent:Connect(function(size)
	data:set("Shared.Settings.BarSize", size)
end)

replicated.Events.ChangeTransition.OnClientEvent:Connect(function(transition)
	data:set("Shared.Settings.Transition", transition)
end)

replicated.Events.ChangeTransitionSpeed.OnClientEvent:Connect(function(speed)
	data:set("Shared.Settings.TransitionTimes.Multiplier", speed)
end)

replicated.Events.ChangeShake.OnClientEvent:Connect(function(shake)
	data:set("Shared.Effects.Shake", shake)
end)
