local run = game:GetService("RunService")
local replicated = script.Parent.Parent.Parent
local camerasApi = require(replicated.Apis.Cameras)
local guisApi = require(replicated.Apis.Guis)
local systemFolder = require(replicated.Data.SystemFolder):Get()

if run:IsServer() then
	local cameraSection = camerasApi:AddCameraType("Static")
	for _, cameraPart in systemFolder.Cameras.Static:GetChildren() do
		cameraSection:AddCamera { Name = cameraPart.Name, Part = cameraPart }
	end
else
	guisApi.Cameras:AddSection("Static", guisApi.Utils.GenerateCameraGrid("Static"))
	camerasApi.CameraChanged:Connect(camerasApi.Utils.AttachToPart("Static"))
end

return true
