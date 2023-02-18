local run = game:GetService("RunService")
local CamerasApi = {
	Utils = {},
}
local replicated = script.Parent.Parent
local CamerasData = require(replicated.Data.Cameras)
local Signal = require(replicated.Dependencies.Signal)

CamerasApi.CameraChanged = Signal.new()

local cameraTypeObjects = {}

function CamerasApi:AddCameraType(name: string)
	CamerasData:AddCameraType(name)
	local object = {}

	function object:AddCamera(customData: any)
		CamerasData:AddCamera(name, customData)
	end

	function object:GetCameras()
		return CamerasData:GetCameras(name)
	end

	cameraTypeObjects[name] = object
	return object
end

function CamerasApi.GetTypeByName(name: string)
	return cameraTypeObjects[name]
end

function CamerasApi:Change(id: string)
	-- TODO: make this work both on the client and the server
	CamerasData:SetCurrent(id)
	print(CamerasData:GetCurrent())
	replicated.Events.CameraChanged:FireAllClients(CamerasData:GetCurrent())
end

function CamerasApi.Utils.AttachToPart(camType: string)
	return function(currentCameraData: any)
		print(currentCameraData)
		if currentCameraData.Type == camType then
			local part = currentCameraData.Data.Part
		end
	end
end

if run:IsClient() then
	replicated.Events.CameraChanged.OnClientEvent:Connect(function(data)
		print(data)
		CamerasApi.CameraChanged:Fire(data)
	end)
end

return CamerasApi
