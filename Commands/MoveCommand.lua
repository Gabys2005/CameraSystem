local old = workspace.CameraSystemOld
local new = workspace.CameraSystem

for i,v in pairs(old.Cameras.StaticCams:GetChildren()) do
    v.Parent = new.Cameras.Static
    v.Name = v.Namer.Value
    v.Namer:Destroy()
    v.Camera.Name = "Cam"
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

local default = old.Cameras.DefaultCam.Camera
default.Name = "DefaultCam"
default.Parent = new.Cameras