local components = script.Parent.Parent
local basicComponents = components.Basic
local button = require(basicComponents.RoundedButton)
local api = require(workspace.CameraSystem:WaitForChild("Api"))
local drones = api:GetCamsById().Drones
local droneController = require(script.Parent.Parent.Parent.Scripts.DroneController)
local theme = require(script.Parent.Parent.Parent.Themes.Current)
local smoothGrid = require(script.Parent.Parent.Parent.Scripts.SmoothGrid)
local ts = game:GetService("TweenService")

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

	local droneButtons = {}
	local lastSelectedButton

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
			for i, v in pairs(droneButtons) do
				ts:Create(v, TweenInfo.new(0.5), { BackgroundColor3 = theme.Base }):Play()
			end
			if lastSelectedButton == droneButton then
				ts:Create(copy.DroneChooser, TweenInfo.new(0.5), { Size = UDim2.new(1, -5, 1, 0) }):Play()
				ts:Create(copy.DroneActions, TweenInfo.new(0.5), { Position = UDim2.new(1, 100, 0, 0) }):Play()
				lastSelectedButton = nil
			else
				ts:Create(copy.DroneChooser, TweenInfo.new(0.5), { Size = UDim2.new(1, -105, 1, 0) }):Play()
				ts:Create(copy.DroneActions, TweenInfo.new(0.5), { Position = UDim2.new(1, 0, 0, 0) }):Play()
				ts:Create(droneButton, TweenInfo.new(0.5), { BackgroundColor3 = theme.Highlighted }):Play()
				lastSelectedButton = droneButton
			end
		end)
		table.insert(droneButtons, droneButton)
	end

	smoothGrid(copy.DroneChooser, copy.DroneChooser.UIGridLayout)

	return copy
end
