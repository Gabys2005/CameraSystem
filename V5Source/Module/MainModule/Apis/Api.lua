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
	Default = nil,
}

--// Functions
local function idCameraFolder(folder: Folder)
	local camById = {}
	if folder then
		for i, v in pairs(folder:GetChildren()) do
			if run:IsServer() then
				v:SetAttribute("ID", i)
				camById[i] = v
			else
				camById[v:GetAttribute("ID")] = v
			end
		end
		for i, v in pairs(folder:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 1
				v.CanCollide = false
			end
		end
	end
	return camById
end

local function timeMovingCams(folder: Folder)
	for i, v in pairs(folder:GetChildren()) do
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

local function indexCameras()
	camerasByIds.Static = idCameraFolder(workspaceFolder.Cameras.Static)
	camerasByIds.Moving = idCameraFolder(workspaceFolder.Cameras.Moving)
	if run:IsServer() then
		timeMovingCams(workspaceFolder.Cameras.Moving)
	end
	if workspaceFolder.Cameras:FindFirstChild("Default") then
		camerasByIds.Default = workspaceFolder.Cameras.Default.CFrame
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

--// Server only apis
if run:IsServer() then
	function api:ChangeCam(camType: string, camId: number)
		if typeof(camType) ~= "string" or typeof(camId) ~= "number" then
			error("[[ Camera System ]] Incorrect types supplied to api:ChangeCam")
		end
		if not camerasByIds[camType] or not camerasByIds[camType][camId] then
			error("[[ Camera System ]] api:ChangeCam called with incorrect CamType or CamId")
		end
		data.Shared.CurrentCamera.Type = camType
		data.Shared.CurrentCamera.Id = camId
		data.Shared.CurrentCamera.Model = camerasByIds[camType][camId]
		replicatedFolder.Events.ChangeCam:FireAllClients(camType, camId)
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
	end

	function api:ChangeFov(fov: number, time: number?)
		time = time or 0.1
		data.Shared.Effects.Fov = {
			Value = fov,
			Time = time,
		}
		replicatedFolder.Events.ChangeFov:FireAllClients(data.Shared.Effects.Fov)
	end

	-- TODO find a replacement for repeated functions like this
	function api:ChangeAutoFov(bool: boolean)
		data.Shared.Settings.AutoFov = bool
		replicatedFolder.Events.ChangeAutoFov:FireAllClients(bool)
	end

	function api:ChangeUseSprings(bool: boolean)
		data.Shared.Settings.UseSprings = bool
		replicatedFolder.Events.UseSprings:FireAllClients(bool)
	end
end

--// Client only apis
-- if run:IsClient() then

-- end

return api
