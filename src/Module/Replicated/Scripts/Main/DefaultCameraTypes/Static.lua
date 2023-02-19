local run = game:GetService("RunService")
local replicated = script.Parent.Parent.Parent.Parent
local api = require(replicated.Data.Api):Get()

if run:IsServer() then
	local cameraSection = api.Cameras:AddCameraType("Static")
	for _, cameraPart in api:GetSystemFolder().Cameras.Static:GetChildren() do
		cameraSection:AddCamera { Name = cameraPart.Name, Part = cameraPart }
	end
else
	api.Guis.Cameras:AddSection("Static", api.Guis.Utils.GenerateCameraGrid("Static"))
	api.Cameras.CameraChanged:Connect(api.Cameras.Utils.AttachToPart("Static"))
end

return true
