local cameras = script.Parent.Cameras
local replicated = game.ReplicatedStorage.CameraSystem

local ID = 1

for i,v in pairs(cameras.Static:GetDescendants()) do
	if v:IsA("BasePart") then
		local val = Instance.new("IntValue")
		val.Name = "ID"
		val.Value = ID
		ID += 1
		val.Parent = v
		v.Transparency = 1
		v.CanCollide = false
	end
end

cameras.DefaultCam.Transparency = 1
cameras.DefaultCam.CanCollide = false

local ID = 1

for i,v in pairs(cameras.Drones:GetChildren()) do
	local val = Instance.new("IntValue")
	val.Name = "ID"
	val.Value = ID
	ID += 1
	val.Parent = v
	if v:FindFirstChild("BodyGyro") then
		v.BodyGyro.CFrame = v.CFrame
		v.BodyPosition.Position = v.Position
		v.CamPos.BodyGyro.CFrame = v.CFrame
		v.CamPos.BodyPosition.Position = v.Position
		v.Anchored = false
		v.CamPos.Anchored = false
		for i,v in pairs(v:GetDescendants()) do
			if v:IsA("Weld") then
				v:Destroy()
			end
		end
	end
end

local ID = 1

for i,v in pairs(cameras.Moving:GetDescendants()) do
	if v:IsA("Model") then
		local val = Instance.new("IntValue")
		val.Name = "ID"
		val.Value = ID
		ID += 1
		val.Parent = v

		local val = Instance.new("NumberValue")
		val.Name = "TotalDistance"
		for a = 1, #v:GetChildren()-3 do
			val.Value += (v[a].Position - v[a+1].Position).magnitude
		end
		for i,v in pairs(v:GetChildren()) do
			if v:IsA("BasePart") then
				v.Transparency = 1
				v.CanCollide = false
			end
		end
		val.Parent = v
	end
end

local api = require(script.Parent.API)
local Settings = require(script.Parent.Settings)
script.AccelerateStart.Value = Settings.AccelerateStart
script.DecelerateEnd.Value = Settings.DecelerateEnd

local function isOwner(plr)
	if table.find(Settings.GuiOwners,plr.Name) then
		return true
	else
		return false
	end
end

replicated.Server.PositionValue.Value = cameras.DefaultCam.Position
replicated.Server.RotationValue.Value = cameras.DefaultCam.Orientation

replicated.Events.ChangeCamera.OnServerEvent:Connect(function(plr,camType,id,noEffects)
	if isOwner(plr) then
		api:ChangeCam(camType,id,noEffects)
	end
end)

replicated.Events.FocusOn.OnServerEvent:Connect(function(plr,focusText)
	if isOwner(plr) then
		api:Focus(focusText,"ButtonClick")
	end
end)

replicated.Events.SetBlur.OnServerEvent:Connect(function(plr,level,timee)
	if isOwner(plr) then
		api:Blur(level,timee)
	end
end)

replicated.Events.SetFov.OnServerEvent:Connect(function(plr,fov,timee)
	if isOwner(plr) then
		api:Fov(fov,timee)
	end
end)

replicated.Events.SetOrientation.OnServerEvent:Connect(function(plr,orientation,timee)
	if isOwner(plr) then
		api:Tilt(orientation,timee)
	end
end)

replicated.Events.ChangeBlackout.OnServerEvent:Connect(function(plr,visible,color)
	if isOwner(plr) then
		api:Blackout(visible,color)
	end
end)

replicated.Events.SetSaturation.OnServerEvent:Connect(function(plr,level,timee)
	if isOwner(plr) then
		api:Saturation(level,timee)
	end
end)

replicated.Events.ToggleRainbow.OnServerEvent:Connect(function(plr)
	if isOwner(plr) then
		script.Rainbow.Disabled = not script.Rainbow.Disabled
		if script.Rainbow.Disabled then
			api:TintColor(Color3.fromRGB(255,255,255),0.5)
			replicated.Server.RainbowEnabled.Value = false
		else
			replicated.Server.RainbowEnabled.Value = true
		end
	end
end)

replicated.Events.ToggleBars.OnServerEvent:Connect(function(plr)
	if isOwner(plr) then
		api:Bars(not replicated.Server.ShowBars.Value)
	end
end)

replicated.Events.SetBarSize.OnServerEvent:Connect(function(plr,size)
	if isOwner(plr) then
		api:BarSize(size)
	end
end)

replicated.Events.SetTintColor.OnServerEvent:Connect(function(plr,color,hue,saturation,value)
	if isOwner(plr) then
		api:TintColor(color,0.1,hue,saturation,value)
	end
end)

replicated.Events.SetTransitionFade.OnServerEvent:Connect(function(plr,mode)
	if isOwner(plr) then
		api:TransitionFade(mode)
	end
end)

replicated.Events.Drone.OnServerEvent:Connect(function(plr,toggle,currentDrone,position,droneCframe,posCframe)
	if isOwner(plr) then
		if toggle == true then
			currentDrone:SetNetworkOwner(plr)
			currentDrone.CamPos:SetNetworkOwner(plr)
		else
			-- I don't know why, I don't want to know why, I shouldn't
			-- have to wonder why, but for whatever reason this stupid
			-- drone isn't staying in place unless I do this terribleness
			currentDrone:SetNetworkOwner(nil)
			currentDrone.CamPos:SetNetworkOwner(nil)
			currentDrone.Anchored = true
			currentDrone.CamPos.Anchored = true
			currentDrone.BodyPosition:Destroy()
			currentDrone.BodyGyro:Destroy()
			currentDrone.CamPos.BodyPosition:Destroy()
			currentDrone.CamPos.BodyGyro:Destroy()
			local new = Instance.new("BodyPosition")
			new.Position = currentDrone.Position
			new.Parent = currentDrone
			local new = Instance.new("BodyPosition")
			new.Position = currentDrone.CamPos.Position
			new.Parent = currentDrone.CamPos
			local new = Instance.new("BodyGyro")
			new.CFrame = currentDrone.CFrame
			new.MaxTorque = Vector3.new(400000, 400000, 400000)
			new.Parent = currentDrone
			local new = Instance.new("BodyGyro")
			new.CFrame = currentDrone.CamPos.CFrame
			new.MaxTorque = Vector3.new(400000, 400000, 400000)
			new.Parent = currentDrone.CamPos
			currentDrone.Anchored = false
			currentDrone.CamPos.Anchored = false
		end
	end
end)

replicated.Events.RunKeybind.OnServerEvent:Connect(function(plr,run)
	if isOwner(plr) then
		local name = string.lower(run[1])
		table.remove(run,1)
		local args = run
		if name == "fov" then
			local fov = args[1] or 70
			local timee = args[2] or 0.1
			api:Fov(fov,timee)
		elseif name == "rainbow" then
			script.Rainbow.Disabled = not script.Rainbow.Disabled
			if script.Rainbow.Disabled then
				api:TintColor(Color3.fromRGB(255,255,255),0.5)
				replicated.Server.RainbowEnabled.Value = false
			else
				replicated.Server.RainbowEnabled.Value = true
			end
		elseif name == "blackout" then
			if (replicated.Shared.BlackoutEnabled.Value == true and replicated.Shared.BlackoutColor.Value ~= Color3.fromRGB(0,0,0)) or replicated.Shared.BlackoutEnabled.Value == false then
				api:Blackout(true, Color3.fromRGB(0,0,0))
			else
				api:Blackout(false)
			end
		elseif name == "whiteout" then
			if (replicated.Shared.BlackoutEnabled.Value == true and replicated.Shared.BlackoutColor.Value ~= Color3.fromRGB(255,255,255)) or replicated.Shared.BlackoutEnabled.Value == false then
				api:Blackout(true, Color3.fromRGB(255,255,255))
			else
				api:Blackout(false)
			end
		elseif name == "colorout" then
			if (replicated.Shared.BlackoutEnabled.Value == true and replicated.Shared.BlackoutColor.Value ~= args[1]) or replicated.Shared.BlackoutEnabled.Value == false then
				api:Blackout(true, args[1])
			else
				api:Blackout(false)
			end
		elseif name == "tintcolor" then
			local color = args[1] or Color3.fromRGB(255,255,255)
			local timee = args[2] or 0.1
			api:TintColor(color,timee)
		elseif name == "saturation" then
			local saturation = args[1] or 0
			local timee = args[2] or 0.1
			api:Saturation(saturation,timee)
		elseif name == "blur" then
			local blur = args[1] or 0
			local timee = args[2] or 0.1
			api:Blur(blur,timee)
		elseif name == "changecam" then
			local camType = args[1] or "Static"
			local camIdOrName = args[2] or 1
			api:ChangeCam(camType,camIdOrName)
		elseif name == "tilt" then
			local tilt = args[1] or 0
			local timee = args[2] or 0.1
			api:Tilt(tilt,timee)
		elseif name == "macro" then
			local macroName = args[1]
			local funcName = args[2]
			for i,v in pairs(Settings.Macros) do
				if v.Name == macroName then
					v[funcName](plr)
				end
			end
		end
	end
end)

replicated.Events.RunMacro.OnServerInvoke = function(plr,macroName,funcName)
	if isOwner(plr) then
		for i,v in pairs(Settings.Macros) do
			if v.Name == macroName then
				return v[funcName](plr)
			end
		end
	end
end