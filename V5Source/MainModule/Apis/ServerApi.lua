local api = {}
local replicated = game:GetService("ReplicatedStorage")
local replicatedFolder = replicated:WaitForChild("CameraSystem")
local workspaceFolder = workspace:WaitForChild("CameraSystem")
local data = require(replicatedFolder.Data)

local camerasByIds = {
	Static = {},
	Moving = {},
	Default = nil
}

function api:ChangeCam(camType,camId)
	data.Shared.CurrentCamera.Type = camType
	data.Shared.CurrentCamera.Id = camId
	data.Shared.CurrentCamera.Model = camerasByIds[camType][camId]
	replicatedFolder.Events.ChangeCam:FireAllClients(camType,camId)
end

function api:GetCamsById()
	if not camerasByIds.Default then
		idCameraFolder(workspaceFolder.Cameras.Static)
		idCameraFolder(workspaceFolder.Cameras.Moving)
		if workspaceFolder.Cameras:FindFirstChild("Default") then
			camerasByIds.Default = workspaceFolder.Cameras.Default.CFrame
		else
			warn("[[ Camera System ]]: Default camera is missing, using first static camera or fallback position instead")
			camerasByIds.Default = camerasByIds.Static[1] and camerasByIds.Static[1].CFrame or CFrame.new(0,10,0)
		end
	end
	return camerasByIds
end

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