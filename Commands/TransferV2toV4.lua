local old = workspace.CameraSystemOld
local new = workspace.CameraSystem

for i,v in pairs(old.Cameras.StaticCams:GetChildren()) do
	local name = v.Namer.Value
	local part = v.Camera
	part.Parent = new.Cameras.Static
	part.Name = name
end

for i,v in pairs(old.Cameras.MovingCams:GetChildren()) do
	v.Parent = new.Cameras.Moving
	v.Name = v.Namer.Value
	v.Namer:Destroy()
	for a,b in pairs(v:GetChildren()) do
		if b:IsA("BasePart") then
			b.Name = string.sub(b.Name,4)
		end
	end
end

new.Cameras.DefaultCam.CFrame = old.Cameras.DefaultCam.Camera.CFrame