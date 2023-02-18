local http = game:GetService("HttpService")
local Cameras = {}

Cameras._types = {}
Cameras._byId = {}
Cameras._current = nil

function Cameras:AddCameraType(name: string)
	assert(Cameras._types[name] == nil, `[[ Camera System ]]: Camera type "{name}" added already`)
	Cameras._types[name] = {
		Cameras = {},
	}
end

function Cameras:AddCamera(camType: string, customData: any)
	local id = http:GenerateGUID(false)
	Cameras._types[camType].Cameras[id] = customData
	Cameras._byId[id] = { Type = camType, Data = customData }
	print(Cameras._types)
end

function Cameras:GetCameras(camType: string)
	return Cameras._types[camType].Cameras
end

function Cameras:SetCurrent(id)
	local cam = Cameras._byId[id]
	print(cam)
	Cameras._current = cam
	print(`Switched cameras`)
end

function Cameras:GetCurrent()
	return Cameras._current
end

return Cameras
