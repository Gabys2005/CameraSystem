local toggle = false

local uis = game:GetService("UserInputService")

script.Parent.MouseButton1Click:Connect(function()
	toggle = not toggle
	if toggle == true then
		game.ReplicatedStorage.CameraSystem.ControlDrone:FireServer(toggle)
		script.ControlDrone.Disabled = false
		script.ControlDrone.Start.Value = true
		script.Parent.Parent.Parent.Parent.IsWatching.Value = false
		workspace.CameraSystem.Drone.Transparency = 1
		script.Parent.Parent.Parent.Parent.Watch.Visible = false
	else
		game.ReplicatedStorage.CameraSystem.ControlDrone:FireServer(toggle,workspace.CameraSystem.Drone.BodyPosition.Position,workspace.CameraSystem.Drone.BodyGyro.CFrame,workspace.CameraSystem.DroneCFrame.BodyGyro.CFrame)
		script.ControlDrone.Start.Value = false
		workspace.CameraSystem.Drone.Transparency = 0
		script.Parent.Parent.Parent.Parent.Watch.Visible = true
	end
end)

--uis.InputBegan:Connect(function(input, processed)
--	if not processed then
--		if input.KeyCode == Enum.KeyCode.P then
--			if toggle == true then
--				toggle = false
--				game.ReplicatedStorage.CameraSystem.ControlDrone:FireServer(toggle,workspace.CameraSystem.Drone.BodyPosition.Position,workspace.CameraSystem.Drone.BodyGyro.CFrame,workspace.CameraSystem.DroneCFrame.BodyGyro.CFrame)
--				script.ControlDrone.Start.Value = false
--				workspace.CameraSystem.Drone.Transparency = 0
--			end
--		end
--	end
--end)

game.ReplicatedStorage.CameraSystem.CurrentDroneOperator.Changed:Connect(function()
	if game.ReplicatedStorage.CameraSystem.CurrentDroneOperator.Value ~= game.Players.LocalPlayer.Name then
		if toggle == true then
				toggle = false
				game.ReplicatedStorage.CameraSystem.ControlDrone:FireServer(toggle,workspace.CameraSystem.Drone.BodyPosition.Position,workspace.CameraSystem.Drone.BodyGyro.CFrame,workspace.CameraSystem.DroneCFrame.BodyGyro.CFrame)
				script.ControlDrone.Start.Value = false
				workspace.CameraSystem.Drone.Transparency = 0
			end
	end
end)