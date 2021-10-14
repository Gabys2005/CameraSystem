local old = workspace.CameraSystemOld
local new = workspace.CameraSystem

for i,v in pairs(old.Cameras.Static:GetChildren()) do
	local name = v.Name
	local part = v.Cam
	part.Parent = new.Cameras.Static
	part.Name = name
end

for i,v in pairs(old.Cameras.Moving:GetChildren()) do
	v.Parent = new.Cameras.Moving
end

new.Cameras.DefaultCam.CFrame = old.Cameras.DefaultCam.CFrame