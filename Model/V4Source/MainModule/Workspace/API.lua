local api = {}
local clientapi = {}

local replicated = game.ReplicatedStorage.CameraSystem
local players = game.Players
local cameras = workspace.CameraSystem.Cameras
local ts = game:GetService("TweenService")
local run = game:GetService("RunService")
local lastFovTime = 0.1

local events = {Blackout = {}, CamChange = {}, FocusChange = {}, FovChange = {}, SaturationChange = {}, BlurChange = {}, BarsToggle = {}, TintColorChange = {}, BarSizeChange = {}, TransitionModeChange = {}, CameraOffsetChange = {}, TiltChange = {}}
local camerasTable = {Static = {}, Moving = {}, Drone = {}}
for i,v in pairs(cameras.Static:GetDescendants()) do
	if v:IsA("Part") then
		camerasTable.Static[v:WaitForChild("ID").Value] = v
	end
end
for i,v in pairs(cameras.Moving:GetDescendants()) do
	if v:IsA("Model") then
		camerasTable.Moving[v:WaitForChild("ID").Value] = v
	end
end
for i,v in pairs(cameras.Drones:GetChildren()) do
	camerasTable.Drone[v:WaitForChild("ID").Value] = v
end

local CurrentPositionTween
local CurrentRotationTween
local LastTweenStart

local function stopTweens()
	LastTweenStart = tick()
	if CurrentPositionTween then
		CurrentPositionTween:Cancel()
		CurrentPositionTween:Destroy()
		CurrentPositionTween = nil
	end
	if CurrentRotationTween then
		CurrentRotationTween:Cancel()
		CurrentRotationTween:Destroy()
		CurrentRotationTween = nil
	end
end

function api:ChangeCam(camType,id,noEffects)
	spawn(function()
		for i,v in pairs(events.CamChange) do
			spawn(function()
				v(camType,id)
			end)
		end
	end)
	
	replicated.Server.CurrentCamType.Value = camType
	replicated.Server.CurrentCamID.Value = id
	if camType == "Drone" then
		local droneToUse
		for i,v in pairs(script.Parent.Cameras.Drones:GetChildren()) do
			if v.ID.Value == id then
				droneToUse = v.CamPos
				break
			end
		end
		replicated.Server.UseDrone.Value = droneToUse
	else
		replicated.Server.UseDrone.Value = nil
	end
	replicated.Events.ChangeCamera:FireAllClients(camType,id)
	
	
	stopTweens()
	local currentTweenStart = tick()
	LastTweenStart = currentTweenStart
	if camType == "Static" then
		replicated.Server.PositionValue.Value = camerasTable.Static[id].Position
		replicated.Server.RotationValue.Value = camerasTable.Static[id].Orientation
		if camerasTable.Static[id]:FindFirstChild("FOV") and not noEffects then
			api:Fov(camerasTable.Static[id].FOV.Value,0)
		else
			api:Fov(api:GetFov())
		end
	elseif camType == "Moving" then
		local currentCam = camerasTable.Moving[id]
		local totalDistance = currentCam.TotalDistance.Value
		if currentCam["1"]:FindFirstChild("FOV") and not noEffects then
			api:Fov(currentCam["1"].FOV.Value,0)
			wait()
		else
			api:Fov(api:GetFov())
		end
		for i = 1, #currentCam:GetChildren() - 4 do
			if LastTweenStart ~= currentTweenStart then
				break
			end
			local startCam = currentCam[i]
			local endCam = currentCam[i+1]
			replicated.Server.PositionValue.Value = startCam.Position
			replicated.Server.RotationValue.Value = startCam.Orientation

			local distance = (startCam.Position-endCam.Position).magnitude

			local timee = (distance/totalDistance) * currentCam.Time.Value
			if startCam:FindFirstChild("Time") then
				timee = startCam.Time.Value
			end
			--if endCam:FindFirstChild("FOV") then
			--	api:Fov(endCam.FOV.Value,timee)
			--end
			local nextFov
			local nextFovTime = 0
			for a = i,#currentCam:GetChildren() - 4 do
				local startCam = currentCam[a]
				local endCam = currentCam[a+1]
				local distance = (startCam.Position-endCam.Position).magnitude
				local timeToAdd = (distance/totalDistance) * currentCam.Time.Value
				if startCam:FindFirstChild("Time") then
					timeToAdd = startCam.Time.Value
				end
				nextFovTime += timeToAdd
				if endCam:FindFirstChild("FOV") then
					nextFov = endCam.FOV.Value
					break
				end
			end
			if nextFov and not noEffects then
				api:Fov(nextFov,nextFovTime)
			end
			local easingStyle = Enum.EasingStyle.Linear
			local easingDirection = Enum.EasingDirection.Out

			if #currentCam:GetChildren() - 4 == 1 and script.Parent.Main.AccelerateStart.Value and script.Parent.Main.DecelerateEnd.Value then
				easingStyle = Enum.EasingStyle.Sine
				easingDirection = Enum.EasingDirection.InOut
			elseif i == 1 and script.Parent.Main.AccelerateStart.Value then
				easingStyle = Enum.EasingStyle.Sine
				easingDirection = Enum.EasingDirection.In
			elseif i == #currentCam:GetChildren() - 4 and script.Parent.Main.DecelerateEnd.Value then
				easingStyle = Enum.EasingStyle.Sine
				easingDirection = Enum.EasingDirection.Out
			end

			local tinfo = TweenInfo.new(timee,easingStyle,easingDirection)

			CurrentPositionTween = ts:Create(replicated.Server.PositionValue,tinfo,{Value = endCam.Position})
			CurrentRotationTween = ts:Create(replicated.Server.RotationValue,tinfo,{Value = endCam.Orientation})
			CurrentPositionTween:Play()
			CurrentRotationTween:Play()
			CurrentPositionTween.Completed:Wait()
		end
	elseif camType == "Drone" then
		LastTweenStart = tick()
	end
end

function api:GetCurrentCam()
	local camId = replicated.Server.CurrentCamID.Value
	local camType = replicated.Server.CurrentCamType.Value
	local camName = camerasTable[camType][camId].Name
	local currentCam = camerasTable[camType][camId]
	
	local TotalTime
	if camType == "Moving" then
		TotalTime = 0
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
	end
	return {Type = camType, Name = camName, Id = camId, Time = TotalTime, Model = currentCam}
end

function api:Focus(playerText,source)
	source = source or "API"
	if playerText == nil or playerText == "" then
		replicated.Shared.FocusedOn.Value = nil
		for _,func in pairs(events.FocusChange) do
			spawn(function()
				func(nil,source)
			end)
		end
		return
	end
	
	for i,v in pairs(players:GetPlayers()) do
		if string.sub(string.lower(v.Name),1,string.len(playerText)) == string.lower(playerText) or string.sub(string.lower(v.DisplayName),1,string.len(playerText)) == string.lower(playerText) then
			replicated.Shared.FocusedOn.Value = v.Character
			spawn(function()
				for _,func in pairs(events.FocusChange) do
					spawn(function()
						func(v,source)
					end)
				end
			end)
			return v
		end
	end
end

function api:GetCamIdFromName(category, name)
	if script.Parent.Cameras[category]:FindFirstChild(name,true) then
		return script.Parent.Cameras[category]:FindFirstChild(name,true):WaitForChild("ID").Value
	end
end

function clientapi:GetCamIdFromName(category, name)
	if script.Parent.Cameras[category]:FindFirstChild(name,true) then
		return script.Parent.Cameras[category]:FindFirstChild(name,true):WaitForChild("ID").Value
	end
end

function api:GetFocus()
	return replicated.Shared.FocusedOn.Value
end

function api:Blur(level,timee)
	timee = timee or 0.1
	replicated.Shared.BlurTweenTime.Value = timee
	replicated.Server.Blur.Value = math.clamp(level,0,56)
	for _,func in pairs(events.BlurChange) do
		spawn(function()
			func(level,timee)
		end)
	end
end

function api:GetBlur()
	return replicated.Server.Blur.Value
end

function api:Fov(fov,timee)
	timee = timee or lastFovTime
	local newFov = math.clamp(fov,1,120)
	lastFovTime = timee
	replicated.Server.Fov.Value = newFov
	replicated.Events.SendToClients.ChangeFov:FireAllClients(newFov, timee)
	for _,func in pairs(events.FovChange) do
		spawn(function()
			func(fov,timee)
		end)
	end
end

function api:GetFov()
	return replicated.Server.Fov.Value
end

function api:Tilt(tilt,timee)
	timee = timee or 0.1
	local newTilt = math.clamp(tilt,-90,90)
	replicated.Server.CameraOrientation.Value = newTilt
	replicated.Events.SendToClients.ChangeOrientation:FireAllClients(newTilt, timee)
	for _,func in pairs(events.TiltChange) do
		spawn(function()
			func(tilt,timee)
		end)
	end
end

function api:GetTilt()
	return replicated.Server.CameraOrientation.Value
end

function api:Blackout(visible,color)
	if color then
		replicated.Shared.BlackoutColor.Value = color
	end
	replicated.Shared.BlackoutEnabled.Value = visible
	for _,func in pairs(events.Blackout) do
		spawn(function()
			func(visible,color)
		end)
	end
end

function api:GetBlackout()
	return replicated.Shared.BlackoutEnabled.Value, replicated.Shared.BlackoutColor.Value
end

function api:Saturation(level,timee)
	timee = timee or 0
	replicated.Shared.SaturationTweenTime.Value = timee
	replicated.Server.Saturation.Value = math.clamp(level,-1,1)
	for _,func in pairs(events.SaturationChange) do
		spawn(function()
			func(level,timee)
		end)
	end
end

function api:GetSaturation()
	return replicated.Server.Saturation.Value
end

function api:TintColor(color,timee,hue,saturation,value)
	timee = timee or 0.1
	replicated.Shared.TintColorTweenTime.Value = timee
	replicated.Server.TintColor.Value = color
	if not hue then
		hue, saturation,value = color:ToHSV()
	end
	replicated.Server.TintColorValues.Hue.Value = hue
	replicated.Server.TintColorValues.Saturation.Value = saturation
	replicated.Server.TintColorValues.Value.Value = value
end

function api:GetTintColor()
	return replicated.Shared.TintColor.Value
end

function api:Bars(bool)
	replicated.Server.ShowBars.Value = bool
	for _,func in pairs(events.BarsToggle) do
		spawn(function()
			func(bool)
		end)
	end
end

function api:GetBars()
	return replicated.Server.ShowBars.Value, replicated.Server.BarSize.Value
end

function api:BarSize(num)
	replicated.Server.BarSize.Value = num
	for _,func in pairs(events.BarSizeChange) do
		spawn(function()
			func(num)
		end)
	end
end

function api:TransitionFade(mode)
	replicated.Shared.TransitionMode.Value = mode
	for _,func in pairs(events.TransitionModeChange) do
		spawn(function()
			func(mode)
		end)
	end
end

function api:GetTransition()
	return replicated.Shared.TransitionMode.Value
end

function api:CameraOffset(cframe)
	replicated.Shared.CameraOffset.Value = cframe
	for _,func in pairs(events.CameraOffsetChange) do
		spawn(function()
			func(cframe)
		end)
	end
end

function api:GetCameraOffset()
	return replicated.Shared.CameraOffset.Value
end

function api:AskForValues(plr,data)
	local response = replicated.Events.MacroAskForValues:InvokeClient(plr,data)
	if typeof(response) == "table" then
		return unpack(response)
	else
		return nil
	end
end

function api:On(event,func)
	if events[event] then
		table.insert(events[event],func)
	end
end

if run:IsServer() then
	return api
else
	return clientapi
end