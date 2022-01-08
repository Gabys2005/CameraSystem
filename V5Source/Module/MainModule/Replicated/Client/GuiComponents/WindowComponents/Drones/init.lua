local components = script.Parent.Parent
local basicComponents = components.Basic
local button = require(basicComponents.RoundedButton)
local api = require(workspace.CameraSystem:WaitForChild("Api"))
local drones = api:GetCamsById().Drones
local droneController = require(script.Parent.Parent.Parent.Scripts.DroneController)

return function()
	local currentlySelectedDrone
	local copy = script.Frame:Clone()
	local switchToButton = button("Switch To")
	local controlButton = button("Control")
	local stopControllingButton = button("Stop Controlling")
	switchToButton.Size = UDim2.fromOffset(90, 30)
	controlButton.Size = UDim2.fromOffset(90, 30)
	stopControllingButton.Size = UDim2.fromOffset(90, 30)
	switchToButton.Parent = copy.DroneActions
	controlButton.Parent = copy.DroneActions
	stopControllingButton.Parent = copy.DroneActions

	switchToButton.MouseButton1Click:Connect(function()
		script.Parent.Parent.Parent.Parent.Events.ChangeCam:FireServer(
			"Drones",
			currentlySelectedDrone:GetAttribute("ID")
		)
	end)

	controlButton.MouseButton1Click:Connect(function()
		if currentlySelectedDrone then
			droneController:Start(currentlySelectedDrone)
		end
	end)

	stopControllingButton.MouseButton1Click:Connect(function()
		if currentlySelectedDrone then
			droneController:Stop()
		end
	end)

	for id, drone in pairs(drones) do
		local droneButton = button(drone.Name)
		droneButton.Size = UDim2.fromOffset(100, 30)
		droneButton.Parent = copy.DroneChooser
		droneButton.MouseButton1Click:Connect(function()
			currentlySelectedDrone = drone
			copy.DroneActions.Visible = true
		end)
	end
	return copy
end
