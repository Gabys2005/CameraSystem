--// Services
local replicated = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")
local players = game:GetService("Players")

--// Variables
local api = {}
local replicatedFolder = replicated:WaitForChild("CameraSystem")
local workspaceFolder = workspace:WaitForChild("CameraSystem")
local data = require(replicatedFolder.Data)
local camerasByIds = {
	Static = {},
	Moving = {},
	Drones = {},
	Default = nil,
}
local signal = require(replicatedFolder.Client.Dependencies.Signal)

--// Functions
local function idCameraFolder(folder: Folder, hideCams: boolean)
	local id = 1
	local camById = {}
	if folder then
		for i, v in pairs(folder:GetChildren()) do
			if run:IsServer() then
				if v:IsA("BasePart") or v:IsA("Model") then
					v:SetAttribute("ID", id)
					camById[id] = v
					id += 1
				elseif v:IsA("Folder") or v:IsA("Color3Value") then
					for a, b in pairs(v:GetChildren()) do
						if b:IsA("BasePart") or b:IsA("Model") then
							b:SetAttribute("ID", id)
							camById[id] = b
							id += 1
						end
					end
				end
			else
				if v:IsA("BasePart") or v:IsA("Model") then
					camById[v:GetAttribute("ID")] = v
				elseif v:IsA("Folder") or v:IsA("Color3Value") then
					for a, b in pairs(v:GetChildren()) do
						if b:IsA("BasePart") or b:IsA("Model") then
							camById[b:GetAttribute("ID")] = b
						end
					end
				end
			end
		end
		if not hideCams then
			for i, v in pairs(folder:GetDescendants()) do
				if v:IsA("BasePart") then
					v.Transparency = 1
					v.CanCollide = false
				end
			end
		end
	end
	return camById
end

local function timeMovingCams()
	local cams = camerasByIds.Moving
	for i, v in pairs(cams) do
		local totalTime = v:GetAttribute("Time") or 5
		local totalDistance = 0
		local totalPoints = #v:GetChildren()
		-- It needs to loop twice, first to calculate the total distance between all points,
		-- then to calculate the individual ones. I don't think there's a better way to do that?
		for i = 1, totalPoints - 1 do
			local currentPoint = v[i]
			local nextPoint = v[i + 1]
			local distance = (currentPoint.Position - nextPoint.Position).magnitude
			totalDistance += distance
		end
		for i = 1, totalPoints - 1 do
			local currentPoint = v[i]
			local nextPoint = v[i + 1]
			if not currentPoint:GetAttribute("Time") then
				local distance = (currentPoint.Position - nextPoint.Position).magnitude
				local timee = totalTime / totalDistance * distance
				currentPoint:SetAttribute("Time", timee)
			end
		end
	end
end

local function fixCameras(cameraGroup)
	for i, camera in pairs(cameraGroup) do
		local isBroken = false
		if camera:FindFirstChild("FOV") then
			isBroken = true
			camera:SetAttribute("Fov", camera.FOV.Value)
			camera.FOV:Destroy()
		end
		if camera:FindFirstChild("Time") then
			isBroken = true
			camera:SetAttribute("Time", camera.Time.Value)
			camera.Time:Destroy()
		end
		for i, v in pairs(camera:GetChildren()) do
			if v:FindFirstChild("FOV") then
				isBroken = true
				v:SetAttribute("Fov", v.FOV.Value)
				v.FOV:Destroy()
			end
			if v:FindFirstChild("Time") then
				isBroken = true
				v:SetAttribute("Time", v.Time.Value)
				v.Time:Destroy()
			end
		end
		if isBroken then
			warn(
				"[[ Camera System ]]: "
					.. camera.Name
					.. " is using an outdated format, consider changing the Values to Attributes."
			)
		end
	end
end

local function indexCameras()
	camerasByIds.Static = idCameraFolder(workspaceFolder.Cameras.Static)
	camerasByIds.Moving = idCameraFolder(workspaceFolder.Cameras.Moving)
	camerasByIds.Drones = idCameraFolder(workspaceFolder.Cameras.Drones, true)
	if run:IsServer() then
		fixCameras(camerasByIds.Static) -- In case someone uses the V4 plugin
		fixCameras(camerasByIds.Moving)
		timeMovingCams()
	end
	if workspaceFolder.Cameras:FindFirstChild("Default") then
		camerasByIds.Default = workspaceFolder.Cameras.Default.CFrame
		workspaceFolder.Cameras.Default.Transparency = 1
		workspaceFolder.Cameras.Default.CanCollide = false
	else
		warn("[[ Camera System ]]: Default camera is missing, using first static camera or fallback position instead")
		camerasByIds.Default = camerasByIds.Static[1] and camerasByIds.Static[1].CFrame or CFrame.new(0, 10, 0)
	end
end

local function getPlayerByName(name: string)
	for i, v in pairs(players:GetPlayers()) do
		if
			string.lower(string.sub(v.Name, 1, #name)) == string.lower(name)
			or string.lower(string.sub(v.DisplayName, 1, #name)) == string.lower(name)
		then
			return v
		end
	end
	return nil
end

--======= EXPORTED =======--
--// Shared apis
function api:GetCamsById()
	if not camerasByIds.Default then
		indexCameras()
	end
	return camerasByIds
end

function api:GetCamIdByName(camType: string, camName: string)
	for i, v in pairs(camerasByIds[camType]) do
		if v.Name == camName then
			return i
		end
	end
end

function api:GetCamById(camType: string, camId: number)
	if not camerasByIds.Default then
		indexCameras()
	end
	return camerasByIds[camType][camId]
end

function api:GetDefaultCamPosition()
	if not camerasByIds.Default then
		indexCameras()
	end
	return camerasByIds.Default
end

function api:GetFocus()
	return data.Shared.Focus
end

--// Server only apis
if run:IsServer() then
	function api:ChangeCam(camType: string, camIdOrName: number | string)
		if typeof(camType) ~= "string" or (typeof(camIdOrName) ~= "number" and typeof(camIdOrName) ~= "string") then
			error("[[ Camera System ]] Incorrect types supplied to api:ChangeCam")
		end
		local camId
		if typeof(camIdOrName) == "number" then
			camId = camIdOrName
		else
			camId = api:GetCamIdByName(camType, camIdOrName)
		end
		if not camId then
			error("[[ Camera System ]] Camera not found")
		end
		data.Shared.CurrentCamera.Type = camType
		data.Shared.CurrentCamera.Id = camId
		data.Shared.CurrentCamera.Model = camerasByIds[camType][camId]
		replicatedFolder.Events.ChangeCam:FireAllClients(camType, camId)
		api.CameraChanged:Fire(camType, camId)
	end

	function api:GetCurrentCamera()
		return data.Shared.CurrentCamera
	end

	function api:Focus(ins: BasePart | string | nil)
		if ins then
			if typeof(ins) == "Instance" and ins:IsA("Part") then
				data.Shared.Focus = {
					Type = "Part",
					Instance = ins,
				}
				replicatedFolder.Events.ChangeFocus:FireAllClients(data.Shared.Focus)
			elseif typeof(ins) == "string" then
				local player = getPlayerByName(ins)
				if player then
					data.Shared.Focus = {
						Type = "Player",
						Instance = player.Character.HumanoidRootPart,
					}
					replicatedFolder.Events.ChangeFocus:FireAllClients(data.Shared.Focus)
				end
			end
		else
			data.Shared.Focus = {
				Type = nil,
				Instance = nil,
			}
			replicatedFolder.Events.ChangeFocus:FireAllClients(data.Shared.Focus)
		end
		api.FocusChanged:Fire(data.Shared.Focus)
	end

	function api:ChangeFov(fov: number, time: number?)
		time = time or 0.1
		data.Shared.Effects.Fov = {
			Value = fov,
			Time = time,
		}
		replicatedFolder.Events.ChangeFov:FireAllClients(data.Shared.Effects.Fov)
		api.FovChanged:Fire(fov, time)
	end

	function api:GetFov()
		return data.Shared.Effects.Fov
	end

	-- TODO find a replacement for repeated functions like this
	function api:ChangeAutoFov(bool: boolean)
		data.Shared.Settings.AutoFov = bool
		replicatedFolder.Events.ChangeAutoFov:FireAllClients(bool)
	end

	function api:ChangeSmoothFocus(bool: boolean)
		data.Shared.Settings.SmoothFocus = bool
		replicatedFolder.Events.SmoothFocus:FireAllClients(bool)
	end

	function api:ChangeBlur(blur: number, time: number?)
		time = time or 0.1
		data.Shared.Effects.Blur = {
			Value = blur,
			Time = time,
		}
		replicatedFolder.Events.ChangeBlur:FireAllClients(data.Shared.Effects.Blur)
		api.BlurChanged:Fire(blur, time)
	end

	function api:GetBlur()
		return data.Shared.Effects.Blur
	end

	function api:ChangeSaturation(saturation: number, time: number?)
		time = time or 0.1
		data.Shared.Effects.Saturation = {
			Value = saturation,
			Time = time,
		}
		replicatedFolder.Events.ChangeSaturation:FireAllClients(data.Shared.Effects.Saturation)
		api.SaturationChanged:Fire(saturation, time)
	end

	function api:GetSaturation()
		return data.Shared.Effects.Saturation
	end

	function api:ChangeTilt(tilt: number, time: number?)
		time = time or 0.1
		data.Shared.Effects.Tilt = {
			Value = tilt,
			Time = time,
		}
		replicatedFolder.Events.ChangeTilt:FireAllClients(data.Shared.Effects.Tilt)
		api.TiltChanged:Fire(tilt, time)
	end

	function api:GetTilt()
		return data.Shared.Effects.Tilt
	end

	function api:ChangeBlackout(enabled: boolean)
		if enabled == nil then
			enabled = not data.Shared.Effects.Blackout
		end
		data.Shared.Effects.Blackout = enabled
		replicatedFolder.Events.ChangeBlackout:FireAllClients(enabled)
		api.BlackoutChanged:Fire(enabled)
	end

	function api:GetBlackout()
		return data.Shared.Effects.Blackout
	end

	function api:ChangeBarsEnabled(enabled: boolean)
		if enabled == nil then
			enabled = not data.Shared.Effects.BarsEnabled
		end
		data.Shared.Effects.BarsEnabled = enabled
		replicatedFolder.Events.ChangeBarsEnabled:FireAllClients(enabled)
		api.BarsEnabledChanged:Fire(enabled)
	end

	function api:GetBarsEnabled()
		return data.Shared.Effects.BarsEnabled
	end

	function api:ChangeBarSize(size: number, time: number?)
		time = time or 0.1
		data.Shared.Settings.BarSize = {
			Value = size,
			Time = time,
		}
		replicatedFolder.Events.ChangeBarSize:FireAllClients(data.Shared.Settings.BarSize)
		api.BarSizeChanged:Fire(size, time)
	end

	function api:GetBarSize()
		return data.Shared.Settings.BarSize
	end

	function api:ChangeTransition(name: string)
		data.Shared.Settings.Transition = name
		replicatedFolder.Events.ChangeTransition:FireAllClients(name)
		api.TransitionChanged:Fire(name)
	end

	function api:GetTransition()
		return data.Shared.Settings.Transition
	end

	function api:ChangeTransitionSpeed(speed: number)
		data.Shared.Settings.TransitionTimes.Multiplier = speed
		replicatedFolder.Events.ChangeTransitionSpeed:FireAllClients(speed)
		api.TransitionSpeedChanged:Fire(speed)
	end

	function api:GetTransitionSpeed()
		return data.Shared.Settings.TransitionTimes.Multiplier
	end

	function api:ChangeShake(shake: number)
		data.Shared.Effects.Shake = shake
		replicatedFolder.Events.ChangeShake:FireAllClients(shake)
		api.ShakeChanged:Fire(shake)
	end

	function api:GetShake()
		return data.Shared.Effects.Shake
	end

	api.CameraChanged = signal.new()
	api.FocusChanged = signal.new()
	api.FovChanged = signal.new()
	api.BlurChanged = signal.new()
	api.SaturationChanged = signal.new()
	api.TiltChanged = signal.new()
	api.BlackoutChanged = signal.new()
	api.BarsEnabledChanged = signal.new()
	api.BarSizeChanged = signal.new()
	api.TransitionChanged = signal.new()
	api.TransitionSpeedChanged = signal.new()
	api.ShakeChanged = signal.new()
end

--// Client only apis
if run:IsClient() then
	local makeWindow = require(replicatedFolder.Client.Scripts.NewWindow)

	api.StartedWatching = signal.new()
	api.StoppedWatching = signal.new()

	function api:MakeWindow(Settings: any)
		return makeWindow:new(Settings)
	end

	api.Components = {}
	function api.Components:CategoryChooser(Settings)
		return require(replicatedFolder.Client.GuiComponents.Basic.CategoryChooser)(Settings)
	end
	function api.Components:Button(text)
		return require(replicatedFolder.Client.GuiComponents.Basic.RoundedButton)(text)
	end

	function api:GetTheme()
		return require(replicatedFolder.Client.Themes.Current)
	end
end

return api
