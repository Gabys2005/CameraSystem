local run = game:GetService("RunService")
local replicated = game.ReplicatedStorage.CameraSystem
local lighting = game.Lighting
local cameraInstance = workspace.CurrentCamera
local watching = script.Parent.Watching
local Settings = require(workspace.CameraSystem.Settings)
local cameras = workspace.CameraSystem.Cameras
local plrGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local function watchLoop()
	if cameraInstance.CameraType ~= Enum.CameraType.Scriptable then
		cameraInstance.CameraType = Enum.CameraType.Scriptable
	end

	cameraInstance.FieldOfView = replicated.Client.Fov.Value
	-- Calculate FinalCFrame
	local valContainer = "Client"
	if not replicated.Client.UseClient.Value then
		valContainer = "Server"
	end
	local position = replicated[valContainer].PositionValue.Value
	local rotation = replicated[valContainer].RotationValue.Value
	if replicated.Server.UseDrone.Value then
		replicated.Client.FinalCFrame.Value = replicated.Server.UseDrone.Value.CFrame * replicated.Shared.CameraOffset.Value
	else
		if replicated.Shared.FocusedOn.Value then
			replicated.Client.FinalCFrame.Value = CFrame.new(position,replicated.Shared.FocusedOn.Value.HumanoidRootPart.Position + Vector3.new(0,2,0)) * replicated.Shared.CameraOffset.Value
		else
			replicated.Client.FinalCFrame.Value = CFrame.new(position.X,position.Y,position.Z) * CFrame.fromOrientation(math.rad(rotation.X),math.rad(rotation.Y),math.rad(rotation.Z)) * replicated.Shared.CameraOffset.Value
		end
	end

	cameraInstance.CFrame = replicated.Client.FinalCFrame.Value
end

watching.Changed:Connect(function()
	if watching.Value == false then
		run:UnbindFromRenderStep("CameraSystemWatchLoop")
		cameraInstance.CameraType = Enum.CameraType.Custom
		lighting.CameraSystemBlur.Enabled = false
		lighting.CameraSystemColorCorrection.Enabled = false
		script.Parent.Bars.Visible = false
		script.Parent.BlackOut.Visible = false
		script.Parent.WatchButton.Text = "Watch"
		script.Parent.TransitionFrame.Visible = false
		script.Parent.TransitionBars.Visible = false
		for i,v in pairs(cameras.Drones:GetChildren()) do
			v.Transparency = 0
		end
		cameraInstance.FieldOfView = 70
		for i,v in pairs(Settings.ToggleGui) do
			if plrGui:FindFirstChild(v) then
				plrGui:FindFirstChild(v).Enabled = false
			end
		end
	else
		run:BindToRenderStep("CameraSystemWatchLoop", Enum.RenderPriority.Camera.Value - 1, watchLoop)
		lighting.CameraSystemBlur.Enabled = true
		lighting.CameraSystemColorCorrection.Enabled = true
		script.Parent.Bars.Visible = true
		script.Parent.BlackOut.Visible = true
		script.Parent.WatchButton.Text = "Exit"
		script.Parent.TransitionFrame.Visible = true
		script.Parent.TransitionBars.Visible = true
		if Settings.DronesVisibleFromOtherCams == false then
			for i,v in pairs(cameras.Drones:GetChildren()) do
				v.Transparency = 1
			end
		end
		for i,v in pairs(Settings.ToggleGui) do
			if plrGui:FindFirstChild(v) then
				plrGui:FindFirstChild(v).Enabled = true
			end
		end
	end
end)

script.Parent.WatchButton.MouseButton1Click:Connect(function()
	watching.Value = not watching.Value
end)

if not run:IsStudio() then
	print("Camera System V4 by Gabys2005")
end

if Settings.WatchButton.UseSettings then
	script.Parent.WatchButton.BackgroundColor3 = Settings.WatchButton.BackgroundColor
	script.Parent.WatchButton.BackgroundTransparency = Settings.WatchButton.BackgroundTransparency
	script.Parent.WatchButton.TextColor3 = Settings.WatchButton.TextColor
	script.Parent.WatchButton.TextTransparency = Settings.WatchButton.TextTransparency
	script.Parent.WatchButton.TextStrokeColor3 = Settings.WatchButton.TextStrokeColor
	script.Parent.WatchButton.TextStrokeTransparency = Settings.WatchButton.TextStrokeTransparency
	script.Parent.WatchButton.TextSize = Settings.WatchButton.TextSize
	script.Parent.WatchButton.Position = Settings.WatchButton.Position
	script.Parent.WatchButton.Size = Settings.WatchButton.Size
	script.Parent.WatchButton.AnchorPoint = Settings.WatchButton.AnchorPoint
	if not Settings.WatchButton.Rounded then
		script.Parent.WatchButton.UICorner:Destroy()
	end
end

--run.RenderStepped:Connect(function()
--	if watching.Value == true then
--		if cameraInstance.CameraType ~= Enum.CameraType.Scriptable then
--			cameraInstance.CameraType = Enum.CameraType.Scriptable
--		end
		
--		cameraInstance.FieldOfView = replicated.Client.Fov.Value
--		-- Calculate FinalCFrame
--		local position = replicated.Client.PositionValue.Value
--		local rotation = replicated.Client.RotationValue.Value
--		if replicated.Shared.FocusedOn.Value then
--			replicated.Client.FinalCFrame.Value = CFrame.new(position,replicated.Shared.FocusedOn.Value.HumanoidRootPart.Position + Vector3.new(0,2,0))
--		else
--			replicated.Client.FinalCFrame.Value = CFrame.new(position.X,position.Y,position.Z) * CFrame.fromOrientation(math.rad(rotation.X),math.rad(rotation.Y),math.rad(rotation.Z))
--		end
		
--		cameraInstance.CFrame = replicated.Client.FinalCFrame.Value
--	end
--end)