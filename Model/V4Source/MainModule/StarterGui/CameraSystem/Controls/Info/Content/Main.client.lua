local replicated = game.ReplicatedStorage.CameraSystem
local cameras = workspace.CameraSystem.Cameras
local ts = game:GetService("TweenService")

local barTween
local valTween

replicated.Events.ChangeCamera.OnClientEvent:Connect(function(camType,id)
	if barTween then
		barTween:Cancel()
		barTween:Destroy()
		barTween = nil
	end
	if valTween then
		valTween:Cancel()
		valTween:Destroy()
		valTween = nil
	end
	if camType == "Static" then
		script.Parent.CamType.Text = "Cam Type: Static"
		script.Parent.CamID.Text = "Cam ID: " .. id
		script.Parent.MoveProgress.Text = "Move progress: 100%"
		for i,v in pairs(cameras.Static:GetDescendants()) do
			if v:FindFirstChild("ID") and v.ID.Value == id then
				script.Parent.CamName.Text = "Cam Name: " .. v.Name
				break
			end
		end
		script.Parent.Frame.Frame.Position = UDim2.new(0,0,0,0)
	elseif camType == "Drone" then
		script.Parent.CamType.Text = "Cam Type: Drone"
		script.Parent.CamID.Text = "Cam ID: " .. id
		script.Parent.MoveProgress.Text = "Move progress: 100%"
		for i,v in pairs(cameras.Drones:GetChildren()) do
			if v.ID.Value == id then
				script.Parent.CamName.Text = "Cam Name: " .. v.Name
				break
			end
		end
		script.Parent.Frame.Frame.Position = UDim2.new(0,0,0,0)
	elseif camType == "Moving" then
		script.Parent.CamType.Text = "Cam Type: Moving"
		script.Parent.CamID.Text = "Cam ID: " .. id
		script.Parent.MoveProgress.Text = "Move progress: 0%"
		local currentCam
		for i,v in pairs(cameras.Moving:GetDescendants()) do
			if v:FindFirstChild("ID") and v.ID.Value == id then
				script.Parent.CamName.Text = "Cam Name: " .. v.Name
				currentCam = v
				break
			end
		end
		script.Parent.Frame.Frame.Position = UDim2.new(-1,0,0,0)
		local TotalTime = 0
		local totalDistance = currentCam.TotalDistance.Value
		for i = 1, #currentCam:GetChildren() - 4 do
			local startCam = currentCam[i]
			local endCam = currentCam[i+1]

			local distance = (startCam.Position-endCam.Position).magnitude

			local timee = (distance/totalDistance) * currentCam.Time.Value
			if startCam:FindFirstChild("Time") then
				timee = startCam.Time.Value
			end
			TotalTime += timee
		end
		valTween = ts:Create(script.MoveProgress,TweenInfo.new(TotalTime, Enum.EasingStyle.Linear),{Value = 100})
		barTween = ts:Create(script.Parent.Frame.Frame,TweenInfo.new(TotalTime,Enum.EasingStyle.Linear),{Position = UDim2.new(0,0,0,0)})
		valTween:Play()
		barTween:Play()
	end
end)

script.MoveProgress.Changed:Connect(function(val)
	script.Parent.MoveProgress.Text = "Move progress: " .. val .. "%"
end)