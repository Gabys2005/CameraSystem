local api = {}
local replicated = game:GetService("ReplicatedStorage")
local replicatedFolder = replicated:WaitForChild("CameraSystem")
local workspaceFolder = workspace:WaitForChild("CameraSystem")
local data = require(replicatedFolder.Data)
local run = game:GetService("RunService")

local camerasByIds = {
	Static = {},
	Moving = {},
	Default = nil
}

--// Shared apis
function api:GetCamsById()
    warn("running get cams by id")
	if not camerasByIds.Default then
        warn("indexing")
		camerasByIds.Static = idCameraFolder(workspaceFolder.Cameras.Static)
		camerasByIds.Moving = idCameraFolder(workspaceFolder.Cameras.Moving)
		if workspaceFolder.Cameras:FindFirstChild("Default") then
			camerasByIds.Default = workspaceFolder.Cameras.Default.CFrame
		else
			warn("[[ Camera System ]]: Default camera is missing, using first static camera or fallback position instead")
			camerasByIds.Default = camerasByIds.Static[1] and camerasByIds.Static[1].CFrame or CFrame.new(0,10,0)
		end
	end
	return camerasByIds
end

function api:GetCamById(camType,camId)
    if not camerasByIds then api:getCamsById() end
    print(camerasByIds)
    return camerasByIds[camType][camId]
end

function api:GetDefaultCamPosition()
    return camerasByIds.Default
end

--// Server only apis
if run:IsServer() then
    function api:ChangeCam(camType,camId)
		if typeof(camType) ~= "string" or typeof(camId) ~= "number" then
			error("[[ Camera System ]] Incorrect types supplied to api:ChangeCam")
		end
		if not camerasByIds[camType] or not camerasByIds[camType][camId] then
			error("[[ Camera System ]] api:ChangeCam called with incorrect CamType or CamId")
		end
        data.Shared.CurrentCamera.Type = camType
        data.Shared.CurrentCamera.Id = camId
        data.Shared.CurrentCamera.Model = camerasByIds[camType][camId]
        replicatedFolder.Events.ChangeCam:FireAllClients(camType,camId)
    end
end

--// Client only apis
-- if run:IsClient() then
    
-- end

--// Other junk
function idCameraFolder(folder)
	local camById = {}
	if folder then
		for i,v in pairs(folder:GetChildren()) do
			v:SetAttribute("ID",i)
			camById[i] = v
		end
	end
	return camById
end

return api