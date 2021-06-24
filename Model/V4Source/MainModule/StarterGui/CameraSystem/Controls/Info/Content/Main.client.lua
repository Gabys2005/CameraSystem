local replicated = game.ReplicatedStorage.CameraSystem
local cameras = workspace.CameraSystem.Cameras
local ts = game:GetService("TweenService")

local barTween
local valTween

local folders = {
	Static = cameras.Static,
	Moving = cameras.Moving,
	Drone = cameras.Drones
}

replicated.Events.ChangeCamera.OnClientEvent:Connect(function(camType,id)
	script.Parent.CamType.Text = "Cam Type: " .. camType
	script.Parent.CamID.Text = "Cam ID: " .. id
	local currentCam
	for i,v in pairs(folders[camType]:GetDescendants()) do
		if v.Name == "ID" and v.Value == id then
			currentCam = v.Parent
			script.Parent.CamName.Text = "Cam Name: " .. v.Parent.Name
			break
		end
	end
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
	if camType == "Moving" then
		script.MoveProgress.Value = 0
		valTween = ts:Create(script.MoveProgress,TweenInfo.new(currentCam.Time.Value,Enum.EasingStyle.Linear),{Value = 100})
		valTween:Play()
		script.Parent.Frame.Frame.Position = UDim2.fromScale(-1,0)
		barTween = ts:Create(script.Parent.Frame.Frame,TweenInfo.new(currentCam.Time.Value,Enum.EasingStyle.Linear),{Position = UDim2.fromScale(0,0)})
		barTween:Play()
	else
		script.MoveProgress.Value = 100
		script.Parent.Frame.Frame.Position = UDim2.fromScale(0,0)
	end
end)

script.MoveProgress.Changed:Connect(function(val)
	script.Parent.MoveProgress.Text = "Move progress: " .. val .. "%"
end)