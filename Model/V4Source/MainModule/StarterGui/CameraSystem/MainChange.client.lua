local ts = game:GetService("TweenService")
local Settings = require(workspace.CameraSystem.Settings)
local cameras = workspace.CameraSystem.Cameras
local replicated = game.ReplicatedStorage.CameraSystem
local lighting = game.Lighting
local run = game:GetService("RunService")

local camerasTable = {Static = {}, Moving = {}, Drones = {}}
for i,v in pairs(cameras.Static:GetDescendants()) do
	if v:IsA("Part") then
		camerasTable.Static[v.ID.Value] = v
	end
end
for i,v in pairs(cameras.Moving:GetDescendants()) do
	if v:IsA("Model") then
		camerasTable.Moving[v.ID.Value] = v
	end
end
for i,v in pairs(cameras.Drones:GetChildren()) do
	camerasTable.Drones[v.ID.Value] = v
end

local function wait(t)
	local endTime = tick()+t
	repeat run.RenderStepped:Wait() until tick() >= endTime
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
	if Settings.DronesVisibleFromOtherCams == true then
		for i,v in pairs(cameras.Drones:GetChildren()) do
			v.Transparency = 0
		end
	end
end

replicated.Events.ChangeCamera.OnClientEvent:Connect(function(camType,id)
	local blurForLater = 0
	local blurTransitionTimeForLater = 0
	if replicated.Shared.TransitionMode.Value == "Black" then
		script.Parent.TransitionFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
		local tween = ts:Create(script.Parent.TransitionFrame,TweenInfo.new(0.3),{Transparency = 0})
		tween:Play()
		tween.Completed:Wait()
	elseif replicated.Shared.TransitionMode.Value == "White" then
		script.Parent.TransitionFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
		local tween = ts:Create(script.Parent.TransitionFrame,TweenInfo.new(0.3),{Transparency = 0})
		tween:Play()
		tween.Completed:Wait()
	elseif replicated.Shared.TransitionMode.Value == "Bars" then
		for i,v in pairs(script.Parent.TransitionBars:GetChildren()) do
			if v.Name == "Left" then
				v.Position = UDim2.new(-1.5,0,v.Position.Y.Scale,0)
				ts:Create(v,TweenInfo.new(0.3),{Position = UDim2.new(0,0,v.Position.Y.Scale,0)}):Play()
			else
				v.Position = UDim2.new(1,0,v.Position.Y.Scale,0)
				ts:Create(v,TweenInfo.new(0.3),{Position = UDim2.new(-0.5,0,v.Position.Y.Scale,0)}):Play()
			end
		end
		wait(0.3)
	elseif replicated.Shared.TransitionMode.Value == "Blur" then
		blurForLater = replicated.Server.Blur.Value
		blurTransitionTimeForLater = replicated.Shared.BlurTweenTime.Value
		replicated.Shared.BlurTweenTime.Value = 0.3
		replicated.Server.Blur.Value = 56
		wait(0.3)
	end
	stopTweens()
	replicated.Client.UseClient.Value = true
	local currentTweenStart = tick()
	LastTweenStart = currentTweenStart
	if camType == "Static" then
		replicated.Client.PositionValue.Value = camerasTable.Static[id].Position
		replicated.Client.RotationValue.Value = camerasTable.Static[id].Orientation
		if replicated.Shared.TransitionMode.Value == "Black" then
			script.Parent.TransitionFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
			local tween = ts:Create(script.Parent.TransitionFrame,TweenInfo.new(0.3),{Transparency = 1})
			tween:Play()
		elseif replicated.Shared.TransitionMode.Value == "White" then
			script.Parent.TransitionFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
			local tween = ts:Create(script.Parent.TransitionFrame,TweenInfo.new(0.3),{Transparency = 1})
			tween:Play()
		elseif replicated.Shared.TransitionMode.Value == "Bars" then
			for i,v in pairs(script.Parent.TransitionBars:GetChildren()) do
				local pos = UDim2.new(1,0,v.Position.Y.Scale,0)
				if v.Name == "Right" then
					pos = UDim2.new(-1.5,0,v.Position.Y.Scale,0)
				end
				ts:Create(v,TweenInfo.new(0.3),{Position = pos}):Play()
			end
		elseif replicated.Shared.TransitionMode.Value == "Blur" then
			replicated.Shared.BlurTweenTime.Value = 0.3
			replicated.Server.Blur.Value = blurForLater
			replicated.Shared.BlurTweenTime.Value = blurTransitionTimeForLater
		end
	elseif camType == "Moving" then
		local currentCam = camerasTable.Moving[id]
		local totalDistance = currentCam.TotalDistance.Value
		for i = 1, #currentCam:GetChildren() - 4 do
			if LastTweenStart ~= currentTweenStart then
				break
			end
			local startCam = currentCam[i]
			local endCam = currentCam[i+1]
			replicated.Client.PositionValue.Value = startCam.Position
			replicated.Client.RotationValue.Value = startCam.Orientation
			
			local distance = (startCam.Position-endCam.Position).magnitude
			
			local timee = (distance/totalDistance) * currentCam.Time.Value
			if startCam:FindFirstChild("Time") then
				timee = startCam.Time.Value
			end
			local easingStyle = Enum.EasingStyle.Linear
			local easingDirection = Enum.EasingDirection.Out
			
			if #currentCam:GetChildren() - 4 == 1 and Settings.AccelerateStart and Settings.DecelerateEnd then
				easingStyle = Enum.EasingStyle.Sine
				easingDirection = Enum.EasingDirection.InOut
			elseif i == 1 and Settings.AccelerateStart then
				easingStyle = Enum.EasingStyle.Sine
				easingDirection = Enum.EasingDirection.In
			elseif i == #currentCam:GetChildren() - 4 and Settings.DecelerateEnd then
				easingStyle = Enum.EasingStyle.Sine
				easingDirection = Enum.EasingDirection.Out
			end
			
			local tinfo = TweenInfo.new(timee,easingStyle,easingDirection)
			
			CurrentPositionTween = ts:Create(replicated.Client.PositionValue,tinfo,{Value = endCam.Position})
			CurrentRotationTween = ts:Create(replicated.Client.RotationValue,tinfo,{Value = endCam.Orientation})
			CurrentPositionTween:Play()
			CurrentRotationTween:Play()
			if replicated.Shared.TransitionMode.Value == "Black" then
				script.Parent.TransitionFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
				local tween = ts:Create(script.Parent.TransitionFrame,TweenInfo.new(0.3),{Transparency = 1})
				tween:Play()
			elseif replicated.Shared.TransitionMode.Value == "White" then
				script.Parent.TransitionFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
				local tween = ts:Create(script.Parent.TransitionFrame,TweenInfo.new(0.3),{Transparency = 1})
				tween:Play()
			elseif replicated.Shared.TransitionMode.Value == "Bars" then
				for i,v in pairs(script.Parent.TransitionBars:GetChildren()) do
					local pos = UDim2.new(1,0,v.Position.Y.Scale,0)
					if v.Name == "Right" then
						pos = UDim2.new(-1.5,0,v.Position.Y.Scale,0)
					end
					ts:Create(v,TweenInfo.new(0.3),{Position = pos}):Play()
				end
			elseif replicated.Shared.TransitionMode.Value == "Blur" then
				replicated.Shared.BlurTweenTime.Value = 0.3
				replicated.Server.Blur.Value = blurForLater
				replicated.Shared.BlurTweenTime.Value = blurTransitionTimeForLater
			end
			CurrentPositionTween.Completed:Wait()
		end
	elseif camType == "Drone" then
		if replicated.Shared.TransitionMode.Value == "Black" then
			script.Parent.TransitionFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
			local tween = ts:Create(script.Parent.TransitionFrame,TweenInfo.new(0.3),{Transparency = 1})
			tween:Play()
		elseif replicated.Shared.TransitionMode.Value == "White" then
			script.Parent.TransitionFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
			local tween = ts:Create(script.Parent.TransitionFrame,TweenInfo.new(0.3),{Transparency = 1})
			tween:Play()
		elseif replicated.Shared.TransitionMode.Value == "Bars" then
			for i,v in pairs(script.Parent.TransitionBars:GetChildren()) do
				local pos = UDim2.new(1,0,v.Position.Y.Scale,0)
				if v.Name == "Right" then
					pos = UDim2.new(-1.5,0,v.Position.Y.Scale,0)
				end
				ts:Create(v,TweenInfo.new(0.3),{Position = pos}):Play()
			end
		elseif replicated.Shared.TransitionMode.Value == "Blur" then
			replicated.Shared.BlurTweenTime.Value = 0.3
			replicated.Server.Blur.Value = blurForLater
			replicated.Shared.BlurTweenTime.Value = blurTransitionTimeForLater
		end
		LastTweenStart = tick()
		camerasTable.Drones[id].Transparency = 1
	end
end)

local function setBlur(level)
	level = level or replicated.Server.Blur.Value
	ts:Create(lighting.CameraSystemBlur,TweenInfo.new(replicated.Shared.BlurTweenTime.Value),{Size = level}):Play()
end

local function setFov(fov,timee)
	fov = fov or replicated.Server.Fov.Value
	timee = timee or 0.1
	if timee == 0 then
		replicated.Client.Fov.Value = fov
	else
		ts:Create(replicated.Client.Fov,TweenInfo.new(timee),{Value = fov}):Play()
	end
end

local function setOrientation(orientation,timee)
	orientation = orientation or replicated.Server.CameraOrientation.Value
	timee = timee or 0.1
	if timee == 0 then
		replicated.Client.CameraOrientation.Value = orientation
	else
		ts:Create(replicated.Client.CameraOrientation,TweenInfo.new(timee),{Value = orientation}):Play()
	end
end

local function setBlackout()
	local visible = replicated.Shared.BlackoutEnabled.Value
	local color = replicated.Shared.BlackoutColor.Value
	local transparency = script.Parent.BlackoutTransparency.Value
	if visible == false then
		transparency = 1
	end
	ts:Create(script.Parent.BlackOut,TweenInfo.new(0.5),{BackgroundColor3 = color, Transparency = transparency}):Play()
end

local function setSaturation(level)
	level = level or replicated.Server.Saturation.Value
	ts:Create(lighting.CameraSystemColorCorrection,TweenInfo.new(replicated.Shared.SaturationTweenTime.Value),{Saturation = level}):Play()
end

local function setTintColor(color)
	color = color or replicated.Server.TintColor.Value
	ts:Create(lighting.CameraSystemColorCorrection,TweenInfo.new(replicated.Shared.TintColorTweenTime.Value),{TintColor = color}):Play()
end

local topBarOverride = 0
local bottomBarOverride = 0

if Settings.BarsOverrides and table.find(Settings.BarsOverrides.Users, game.Players.LocalPlayer.Name) then
	topBarOverride = Settings.BarsOverrides.Top
	bottomBarOverride = Settings.BarsOverrides.Bottom
end

local function setBars(bool)
	bool = bool or replicated.Server.ShowBars.Value
	if typeof(bool) == "number" then
		bool = replicated.Server.ShowBars.Value
	end
	if bool == true then
		ts:Create(script.Parent.Bars.TopBar,TweenInfo.new(0.5),{Size = UDim2.new(1,0,replicated.Server.BarSize.Value/100,topBarOverride), Position = UDim2.new(0,0,0,0)}):Play()
		ts:Create(script.Parent.Bars.BottomBar,TweenInfo.new(0.5),{Size = UDim2.new(1,0,replicated.Server.BarSize.Value/100,bottomBarOverride), Position = UDim2.new(0,0,1,0)}):Play()
	else
		ts:Create(script.Parent.Bars.TopBar,TweenInfo.new(0.5),{Size = UDim2.new(1,0,replicated.Server.BarSize.Value/100,topBarOverride), Position = UDim2.new(0,0,-replicated.Server.BarSize.Value/100,-topBarOverride)}):Play()
		ts:Create(script.Parent.Bars.BottomBar,TweenInfo.new(0.5),{Size = UDim2.new(1,0,replicated.Server.BarSize.Value/100,bottomBarOverride), Position = UDim2.new(0,0,replicated.Server.BarSize.Value/100 + 1,bottomBarOverride)}):Play()
	end
end

replicated.Server.Blur.Changed:Connect(setBlur)
replicated.Events.SendToClients.ChangeFov.OnClientEvent:Connect(setFov)
replicated.Events.SendToClients.ChangeOrientation.OnClientEvent:Connect(setOrientation)
replicated.Shared.BlackoutEnabled.Changed:Connect(setBlackout)
replicated.Shared.BlackoutColor.Changed:Connect(setBlackout)
replicated.Server.Saturation.Changed:Connect(setSaturation)
replicated.Server.TintColor.Changed:Connect(setTintColor)
replicated.Server.ShowBars.Changed:Connect(setBars)
script.Parent.BlackoutTransparency.Changed:Connect(setBlackout)
replicated.Server.BarSize.Changed:Connect(setBars)

-- // Set up after joinin
setBlur()
setFov()
setOrientation()
setBlackout()
setSaturation()
setTintColor()
setBars()